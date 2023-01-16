using Drizzle.Lingo.Runtime;
using K4os.Compression.LZ4;
using System;
using System.Collections.Generic;
using System.IO.Compression;
using System.IO;

namespace Drizzle.Logic.Rendering;

public partial class LevelRenderer
{
    private void RenderSaveVoxels()
    {
        RenderStartFrame(RenderStage.SaveFile);

        var fileName = Path.Combine(
            LingoRuntime.MovieBasePath,
            "Levels",
            $"{Movie.gLoadedName}.vx2.gz");

        using var bw = new BinaryWriter(new MemoryStream());

        /*
         * File:
         *  2 - version
         *  1 - decal color count (D)
         *  3*D - RGB decal colors
         *  2 - chunk width
         *  2 - chunk height
         *  2 - width in chunks (W)
         *  2 - height in chunks (H)
         *  2 - subchunk size
         *  4*W*H - pointers to chunk data
         *  4*W*H - pointers to effect data, or 0
         *  X - LZ4 chunk data
         *  Y - LZ4 effect data
         */

        // Need to add rainbow/grime
        // Check adjacent diagonals and adjacent + 1 spacer orthogonals
        // 5 or more must be on a different layer for grime to appear
        // If the nearby voxels are closer to the camera, they may count as up to 2 voxels for this calculation
        // Decal color gPEcolors[1][2] actually means grime

        // Version
        bw.Write((ushort)0);

        // Decal color palette
        var decalColors = new List<LingoColor>();

        for(int z = 0; z < 30; z++)
        {
            var dc = _runtime.GetCastMember($"layer{z}dc")!.image!;

            for(int y = 0; y < dc.Height; y++)
            {
                for(int x = 0; x < dc.Width; x++)
                {
                    var col = dc.getpixel(x, y);
                    if (decalColors.IndexOf(col) == -1)
                    {
                        decalColors.Add(col);
                        if (decalColors.Count > 254)
                            throw new Exception("Too many decal colors!");
                    }
                }
            }
        }

        byte colorCount = (byte)decalColors.Count;

        bw.Write(colorCount);
        for (int i = 0; i < colorCount; i++)
        {
            var col = decalColors[i] as LingoColor? ?? new LingoColor(0, 0, 0);
            bw.Write(col.RedByte);
            bw.Write(col.GreenByte);
            bw.Write(col.BlueByte);
        }

        // Chunk width and height in voxels
        int chunkWidth = _voxelSettings.ChunkWidth;
        int chunkHeight = _voxelSettings.ChunkHeight;
        int chunkDepth = 32;
        bw.Write((ushort)chunkWidth);
        bw.Write((ushort)chunkHeight);

        // Level width and height in chunks
        int xVoxels = _runtime.GetCastMember("layer0")!.image!.Width;
        int yVoxels = _runtime.GetCastMember("layer0")!.image!.Height;
        int zVoxels = 30;
        int xChunks = (xVoxels + chunkWidth - 1) / chunkWidth;
        int yChunks = (yVoxels + chunkHeight - 1) / chunkHeight;
        bw.Write((ushort)xChunks);
        bw.Write((ushort)yChunks);

        // Subchunk size
        bw.Write((ushort)_voxelSettings.SubchunkSize);

        // Offsets to voxel chunks and effect data to be filled in later
        int offsetsPosition = (int)bw.BaseStream.Position;
        var chunkOffsets = new int[xChunks * yChunks];
        var effectOffsets = new int[xChunks * yChunks];
        for (int i = 0; i < xChunks * yChunks; i++)
        {
            bw.Write(0);
            bw.Write(0);
        }

        // Write all chunks, lz4 compressed
        var chunkData = new byte[chunkWidth * chunkHeight * chunkDepth];
        var effectData = new byte[chunkWidth * chunkHeight * chunkDepth];
        var lz4Data = new byte[LZ4Codec.MaximumOutputSize(chunkData.Length)];

        LingoColor decalRainbow = Movie.gPEcolors[1]![2];

        // Mask for visible voxels
        int[]? visibility = null;
        if(_voxelSettings.DoCulling)
        {
            visibility = ComputeVisibility();
        }

        int chunkIndex = 0;
        for (int cy = 0; cy < yChunks; cy++)
        {
            for (int cx = 0; cx < xChunks; cx++)
            {
                int voxelIndex = 0;
                bool anyEffects = false;
                byte lastVoxel = 0b00100000;

                // Loop through all voxels in the chunk
                for (int z = 0; z < zVoxels; z++)
                {
                    LingoImage layer = _runtime.GetCastMember($"layer{z}")!.image!;
                    LingoImage shadow = _runtime.GetCastMember($"layer{z}sh")!.image!;
                    LingoImage decal = _runtime.GetCastMember($"layer{z}dc")!.image!;
                    LingoImage effectA = _runtime.GetCastMember($"gradientA{z}")!.image!;
                    LingoImage effectB = _runtime.GetCastMember($"gradientB{z}")!.image!;

                    var layerHeight = layer.Height;
                    const int lightMargin = 150;

                    for (int y = cy * chunkHeight; y < (cy + 1) * chunkHeight; y++)
                    {
                        for (int x = cx * chunkWidth; x < (cx + 1) * chunkWidth; x++)
                        {
                            bool visible = visibility == null
                                || x >= xVoxels || y >= yVoxels
                                || (visibility[x + y * xVoxels] & (1 << z)) != 0;

                            if (visible)
                            {
                                // Voxel is visible

                                // LPPDdREE = Terrain
                                // L - lit
                                // P - palette index (air, 0, 1, 2)
                                // D - effect color dark
                                // d - decal
                                // R - rainbow
                                // E - effect index (none, A, B, white)
                                int voxel;

                                LingoColor lc = layer.getpixel(x, layerHeight - 1 - y);
                                int lcRgb = lc.BitPack & 0xFFFFFF;

                                if (lcRgb == 0xFFFFFF)
                                {
                                    // Sky
                                    voxel = 0;
                                }
                                else
                                {
                                    // Terrain
                                    bool lit = false;
                                    int palette = 2;
                                    int effect = 0;
                                    bool decalEffect = false;
                                    bool effectDark = false;
                                    bool rainbow = false;

                                    lit = shadow.getpixel(x + lightMargin, layerHeight - 1 - y + lightMargin).BlueByte == 0;

                                    switch (lcRgb)
                                    {
                                        case 0xFF0000: palette = 1; break;
                                        case 0x00FF00: palette = 2; break;
                                        case 0x0000FF: palette = 3; break;
                                        case 0xFF00FF: palette = 2; effect = 1; break;
                                        case 0x00FFFF: palette = 2; effect = 2; break;
                                        case 0x960000: palette = 1; effectDark = true; break;
                                        case 0x009600: palette = 2; effectDark = true; break;
                                        case 0x000096: palette = 3; effectDark = true; break;
                                    }

                                    if ((lcRgb & 0x00FFFF) == 0x00FF96)
                                    {
                                        palette = 1;
                                        effect = 3;
                                    }

                                    // Find effect color amount
                                    byte effectAmount = 0;

                                    switch (effect)
                                    {
                                        // Gradients
                                        case 3: effectAmount = lc.RedByte; break;
                                        case 2: effectAmount = (byte)(255 - effectB.getpixel(x, layerHeight - 1 - y).RedByte); break;
                                        case 1: effectAmount = (byte)(255 - effectA.getpixel(x, layerHeight - 1 - y).RedByte); break;

                                        // Decals
                                        case 0:
                                        default:
                                            var dc = decal.getpixel(x, layerHeight - 1 - y);
                                            if (dc != new LingoColor(0, 0, 0) && dc != new LingoColor(255, 255, 255))
                                            {
                                                if (dc == decalRainbow)
                                                    rainbow = true;
                                                else
                                                {
                                                    int decalInd = decalColors.IndexOf(dc);
                                                    if (decalInd != -1)
                                                    {
                                                        effectAmount = (byte)(255 - decalInd);
                                                        decalEffect = true;
                                                    }
                                                }
                                            }
                                            break;
                                    }


                                    if (effectAmount != 0 && !anyEffects)
                                    {
                                        anyEffects = true;
                                        Array.Clear(effectData);
                                    }

                                    if (effectAmount != 0)
                                        effectData[voxelIndex] = effectAmount;

                                    voxel = (lit ? 0b10000000 : 0)
                                        | ((palette + 1) << 5)
                                        | (effectDark ? 0b00010000 : 0)
                                        | (decalEffect ? 0b00001000 : 0)
                                        | (rainbow ? 0b00000100 : 0)
                                        | effect;
                                }

                                lastVoxel = (byte)voxel;

                                chunkData[voxelIndex] = (byte)voxel;
                            }
                            else
                            {
                                // Voxel is obscured
                                chunkData[voxelIndex] = lastVoxel;
                            }

                            voxelIndex++;
                        }
                    }
                }

                if (voxelIndex != chunkData.Length)
                    Array.Clear(chunkData, voxelIndex, chunkData.Length - voxelIndex);

                // Performance optimization
                // Rays that cross an empty subchunk, indicated with value 255, are terminated
                FillEmptySubchunks(chunkData, 255);

                chunkOffsets[chunkIndex] = (int)bw.BaseStream.Position;
                int dataSize = LZ4Codec.Encode(chunkData, 0, chunkData.Length, lz4Data, 0, lz4Data.Length, LZ4Level.L10_OPT);
                bw.Write(lz4Data, 0, dataSize);


                if(anyEffects)
                {
                    effectOffsets[chunkIndex] = (int)bw.BaseStream.Position;
                    dataSize = LZ4Codec.Encode(effectData, 0, effectData.Length, lz4Data, 0, lz4Data.Length, LZ4Level.L10_OPT);
                    bw.Write(lz4Data, 0, dataSize);
                }
                else
                {
                    effectOffsets[chunkIndex] = 0;
                }

                chunkIndex++;
            }
        }

        // Fixup chunk and effect offsets
        bw.Seek(offsetsPosition, SeekOrigin.Begin);
        for (int i = 0; i < chunkOffsets.Length; i++)
            bw.Write(chunkOffsets[i]);
        for (int i = 0; i < effectOffsets.Length; i++)
            bw.Write(effectOffsets[i]);

        using var fileStream = new GZipStream(new FileStream(fileName, FileMode.Create, FileAccess.Write), CompressionLevel.SmallestSize);
        bw.Seek(0, SeekOrigin.Begin);
        bw.BaseStream.CopyTo(fileStream);
    }

    private static readonly Vector2i[] _floodFillNeighbors = new Vector2i[] { (1, 0), (0, 1), (-1, 0), (0, -1) };
    private int[] ComputeVisibility()
    {
        int xVoxels = _runtime.GetCastMember("layer0")!.image!.Width;
        int yVoxels = _runtime.GetCastMember("layer0")!.image!.Height;
        int zVoxels = 30;
        int overhangDist = _voxelSettings.MaxOverhangCullDist;
        if (overhangDist < 0)
            overhangDist = xVoxels + yVoxels;

        var vis = new int[xVoxels * yVoxels];

        // First layer is fully visible
        Array.Fill(vis, 1);

        var open = new List<Vector2i>();
        var nextOpen = new List<Vector2i>();

        var white = new LingoColor(255, 255, 255);

        for (int z = 1; z < zVoxels; z++)
        {
            LingoImage layer = _runtime.GetCastMember($"layer{z}")!.image!;
            LingoImage aboveLayer = _runtime.GetCastMember($"layer{z - 1}")!.image!;

            // Copy visibility from all visible air in the above layer
            for(int x = 0; x < xVoxels; x++)
            {
                for(int y = 0; y < yVoxels; y++)
                {
                    bool visibleAbove = (vis[x + y * xVoxels] & (1 << (z - 1))) != 0;
                    bool airAbove = aboveLayer.getpixel(x, yVoxels - 1 - y) == white;
                    if (visibleAbove && airAbove)
                        vis[x + y * xVoxels] |= 1 << z;
                }
            }

            // Populate open set with all edge pixels
            for (int x = 0; x < xVoxels; x++)
            {
                for (int y = 0; y < yVoxels; y++)
                {
                    bool visible = (vis[x + y * xVoxels] & (1 << z)) != 0;
                    bool air = layer.getpixel(x, yVoxels - 1 - y) == white;

                    if(visible && air)
                    {
                        // If any neighboring pixels are not visible, then this is on the edge
                        for(int i = 0; i < _floodFillNeighbors.Length; i++)
                        {
                            int tx = x + _floodFillNeighbors[i].X;
                            int ty = y + _floodFillNeighbors[i].Y;

                            if (tx >= 0 && tx < xVoxels && ty >= 0 && ty < yVoxels
                                && (vis[tx + ty * xVoxels] & (1 << z)) != 0)
                            {
                                open.Add((x, y));
                                break;
                            }
                        }
                    }
                }
            }

            // Flood fill visibility through air
            for (int iter = 0; iter < overhangDist && open.Count > 0; iter++)
            {
                // Expand visible area by one pixel in each direction
                foreach(var pxl in open)
                {
                    // Mark all neighbors as visible
                    for (int i = 0; i < _floodFillNeighbors.Length; i++)
                    {
                        var neighbor = pxl + _floodFillNeighbors[i];

                        if (neighbor.X >= 0 && neighbor.X < xVoxels && neighbor.Y >= 0 && neighbor.Y < yVoxels)
                        {
                            bool visible = (vis[neighbor.X + neighbor.Y * xVoxels] & (1 << z)) != 0;
                            bool air = layer.getpixel(neighbor.X, yVoxels - 1 - neighbor.Y) == white;

                            if (!visible)
                            {
                                vis[neighbor.X + neighbor.Y * xVoxels] |= 1 << z;

                                if (air) nextOpen.Add(neighbor);
                            }
                        }
                    }
                }

                (open, nextOpen) = (nextOpen, open);
                nextOpen.Clear();
            }
        }

        return vis;
    }

    private void FillEmptySubchunks(byte[] data, byte value)
    {
        var scSize = _voxelSettings.SubchunkSize;
        var width = _voxelSettings.ChunkWidth / scSize;
        var height = _voxelSettings.ChunkHeight / scSize;
        var depth = 32 / scSize;

        for (int z = 0; z < depth; z++)
        {
            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    if (IsSubchunkEmpty(data, x, y, z))
                        FillSubchunk(data, x, y, z, value);
                }
            }
        }
    }

    private bool IsSubchunkEmpty(byte[] data, int scX, int scY, int scZ)
    {
        var scSize = _voxelSettings.SubchunkSize;

        var chunkW = _voxelSettings.ChunkWidth;
        var chunkH = _voxelSettings.ChunkHeight;

        int startX = scX * scSize;
        int endX = (scX + 1) * scSize;
        int startY = scY * scSize;
        int endY = (scY + 1) * scSize;
        int startZ = scZ * scSize;
        int endZ = (scZ + 1) * scSize;

        for(int z = startZ; z < endZ; z++)
        {
            for(int y = startY; y < endY; y++)
            {
                for(int x = startX; x < endX; x++)
                {
                    if (data[x + (y + z * chunkH) * chunkW] > 0)
                        return false;
                }
            }
        }

        return true;
    }

    private void FillSubchunk(byte[] data, int scX, int scY, int scZ, byte value)
    {
        var scSize = _voxelSettings.SubchunkSize;

        var chunkW = _voxelSettings.ChunkWidth;
        var chunkH = _voxelSettings.ChunkHeight;

        int startX = scX * scSize;
        int endX = (scX + 1) * scSize;
        int startY = scY * scSize;
        int endY = (scY + 1) * scSize;
        int startZ = scZ * scSize;
        int endZ = (scZ + 1) * scSize;

        for (int z = startZ; z < endZ; z++)
        {
            for (int y = startY; y < endY; y++)
            {
                for (int x = startX; x < endX; x++)
                {
                    data[x + (y + z * chunkH) * chunkW] = value;
                }
            }
        }
    }
}
