using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using Drizzle.Lingo.Runtime;
using System.IO.Compression;
using K4os.Compression.LZ4;

namespace Drizzle.Logic.Rendering
{
    public partial class LevelRenderer
    {
        private const int chunkSize = 128;

        private void SaveVoxels()
        {
            var fileName = Path.Combine(
                LingoRuntime.MovieBasePath,
                "Levels",
                $"{Movie.gLoadedName}_Voxels.vx1.gz");

            var layer0 = _runtime.GetCastMember("layer0")!.image!;
            var bw = new BinaryWriter(new GZipStream(File.Create(fileName), CompressionLevel.SmallestSize));

            // Encode the size
            bw.Write((ushort)layer0.Width);
            bw.Write((ushort)layer0.Height);
            bw.Write((ushort)30);

            // Encode display offset
            LingoList extraTiles = Movie.gLOprops.extratiles;
            bw.Write((short)-extraTiles[1]); // Left
            bw.Write((short)-extraTiles[4]); // Bottom

            // Write voxel data in chunks
            // Each chunk starts with a size header, then <= chunkSize*chunkSize*30 bytes compressed with LZ4
            int xChunks = ((int)layer0.width + chunkSize - 1) / chunkSize;
            int yChunks = ((int)layer0.height + chunkSize - 1) / chunkSize;

            byte[] chunkData = new byte[chunkSize * chunkSize * 30];
            byte[] lz4Data = new byte[LZ4Codec.MaximumOutputSize(chunkData.Length)];
            
            for (int y = 0; y < yChunks; y++)
            {
                for (int x = 0; x < xChunks; x++)
                {
                    int chunkDataLen = 0;
                    foreach (var voxel in GetVoxels(x, y))
                        chunkData[chunkDataLen++] = voxel.ToByte();

                    int lz4DataLen = LZ4Codec.Encode(chunkData, 0, chunkDataLen, lz4Data, 0, lz4Data.Length, LZ4Level.L10_OPT);
                    bw.Write7BitEncodedInt(lz4DataLen);
                    bw.Write(lz4Data, 0, lz4DataLen);
                }
            }

            // Append the light image with a size header
            var img = _runtime.GetCastMember("lightImage")?.image;
            if (img != null)
            {
                if((string)Movie.gLevel.lightType != "No Light" && (LingoNumber)Movie.gLOprops.light > 0)
                {
                    var imgData = new MemoryStream();
                    img.SaveAsPng(imgData);
                    imgData.Seek(0, SeekOrigin.Begin);

                    bw.Write7BitEncodedInt((int)imgData.Length);
                    bw.Write(imgData.GetBuffer(), 0, (int)imgData.Length);
                }
                else
                {
                    // Write -1 as length when sunlight is off
                    bw.Write7BitEncodedInt(-1);
                }
            }

            // Done!
            bw.Dispose();
        }

        private IEnumerable<Voxel> GetVoxels(int chunkX, int chunkY)
        {
            Voxel lastVoxel = default;

            for (int z = 0; z < 30; z++)
            {
                var image = _runtime.GetCastMember($"layer{z}")!.image!;
                var effectA = _runtime.GetCastMember($"gradientA{z}")!.image!;
                var effectB = _runtime.GetCastMember($"gradientB{z}")!.image!;

                var imageAbove = (z > 0) ? _runtime.GetCastMember($"layer{z - 1}")!.image : null;
                var imageBelow = (z < 29) ? _runtime.GetCastMember($"layer{z + 1}")!.image : null;

                var imageWidth = image.Width;
                var imageHeight = image.Height;

                for (int y = chunkY * chunkSize, yMax = Math.Min((chunkY + 1) * chunkSize, imageHeight); y < yMax; y++)
                {

                    for (int x = chunkX * chunkSize, xMax = Math.Min((chunkX + 1) * chunkSize, imageWidth); x < xMax; x++)
                    {

                        var color = image.getpixel(x, imageHeight - y);
                        var r = color.RedByte;
                        var g = color.GreenByte;
                        var b = color.BlueByte;

                        int paletteColor;
                        int effectColor = 0;
                        float effectAmount = 0f;

                        bool HasAdjacentAir(LingoImage? img)
                        {
                            if (img == null) return true;

                            for (int ox = -1; ox <= 1; ox++)
                            {
                                for (int oy = -1; oy <= 1; oy++)
                                {
                                    if (img.getpixel(x + ox, imageHeight - y - oy) == LingoColor.White)
                                        return true;
                                }
                            }
                            return false;
                        }

                        // Some voxels are offscreen or completely encased in other terrain, making them impossible to see.
                        // You may want to disable this later if you want destructable terrain.
                        if (
                           x >= imageWidth || y >= imageHeight
                           || (!HasAdjacentAir(imageBelow)
                               && !HasAdjacentAir(image)
                               && !HasAdjacentAir(imageAbove)))
                        {
                            yield return lastVoxel;
                            continue;
                        }
                        else if (color == LingoColor.White)
                        {
                            paletteColor = 0;
                        }
                        else if (r == 255 && b == 255)
                        {
                            paletteColor = 2;
                            effectColor = 1;
                        }
                        else if (g == 255 && b == 255)
                        {
                            paletteColor = 2;
                            effectColor = 2;
                        }
                        else if (g == 255 && b == 150)
                        {
                            paletteColor = 2;
                            effectColor = 3;
                        }
                        else if (r == 255)
                        {
                            paletteColor = 1;
                        }
                        else if (g == 255)
                        {
                            paletteColor = 2;
                        }
                        else if (b == 255)
                        {
                            paletteColor = 3;
                        }
                        else if (r == 150)
                        {
                            paletteColor = 1;
                            //dark = true;
                        }
                        else if (g == 150)
                        {
                            paletteColor = 2;
                            //dark = true;
                        }
                        else if (b == 150)
                        {
                            paletteColor = 3;
                            //dark = true;
                        }
                        else
                        {
                            paletteColor = 0;
                        }

                        if(effectColor > 0)
                        {
                            effectAmount = 1f - (effectColor == 1 ? effectA : effectB).getpixel(x, imageHeight - y).RedByte / 255f;
                        }

                        yield return lastVoxel = new Voxel(paletteColor, effectColor, effectAmount);
                    }
                }
            }
        }

        private struct Voxel
        {
            // Index into the room palette. 2 bits.
            public int paletteColor;

            // Index into the room's effect color list. 2 bits.
            public int effectColor;

            // Intensity of effect color. 4 bits.
            public int effectAmount;

            public Voxel(int paletteColor, int effectColor, float effectAmount)
            {
                if (paletteColor > 3 || paletteColor < 0) throw new ArgumentException("Palette color out of range!", nameof(paletteColor));
                if (effectColor > 2 || effectColor < 0) throw new ArgumentException("Effect color out of range!", nameof(paletteColor));
                if (effectAmount > 1f || effectColor < 0f) throw new ArgumentException("Effect amount out of range!", nameof(effectAmount));

                this.paletteColor = paletteColor;
                this.effectColor = effectColor;
                this.effectAmount = Math.Min((int)(effectAmount * (1 << 4)), (1 << 4) - 1);
            }

            public byte ToByte()
            {
                return (byte)(paletteColor | effectColor << 2 | effectAmount << 4);
            }

            public override bool Equals(object? obj)
            {
                return obj is Voxel voxel &&
                       paletteColor == voxel.paletteColor &&
                       effectColor == voxel.effectColor &&
                       effectAmount == voxel.effectAmount;
            }

            public override int GetHashCode()
            {
                return HashCode.Combine(paletteColor, effectColor, effectAmount);
            }

            public static bool operator ==(Voxel left, Voxel right)
            {
                return left.Equals(right);
            }

            public static bool operator !=(Voxel left, Voxel right)
            {
                return !(left == right);
            }
        }
    }
}
