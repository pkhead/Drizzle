using System;

namespace Drizzle.Logic.Rendering;

internal class VoxelSettings
{
    /// <summary>
    /// Width of each chunk in voxels. Must be a power of 2.
    /// </summary>
    public int ChunkWidth { get; }
    /// <summary>
    /// Height of each chunk in voxels. Must be a power of 2.
    /// </summary>
    public int ChunkHeight { get; }
    /// <summary>
    /// Size of each cube on the output mesh in voxels.
    /// Must be a factor of <see cref="ChunkWidth"/>, <see cref="ChunkHeight"/>, and 32.
    /// </summary>
    public int SubchunkSize { get; }
    /// <summary>
    /// When set, voxels that are completely enclosed will not be saved.
    /// </summary>
    public bool DoCulling { get; }
    /// <summary>
    /// Voxels further than this Manhattan distance from any hole in the layer above
    /// will be culled if <see cref="DoCulling"/> is set.
    /// <para>
    /// Negative values disable overhang culling.
    /// </para>
    /// </summary>
    public int MaxOverhangCullDist { get; }

    public static VoxelSettings Default { get; } = new VoxelSettings(128, 128, 8);

    public VoxelSettings(int chunkWidth, int chunkHeight, int subchunkSize, bool doCulling = true, int maxOverhangCullDist = 3)
    {
        if (!IsPowerOf2(chunkWidth)) throw new ArgumentException("Width must be a power of 2!", nameof(chunkWidth));
        if (!IsPowerOf2(chunkHeight)) throw new ArgumentException("Height must be a power of 2!", nameof(chunkHeight));
        if (subchunkSize <= 0) throw new ArgumentException("Subchunk size must be positive!", nameof(subchunkSize));
        if (subchunkSize > chunkWidth || subchunkSize > chunkHeight || subchunkSize > 32) throw new ArgumentException("Subchunk size may not be greater than width, height, or depth!", nameof(subchunkSize));
        if (chunkWidth % subchunkSize != 0 || chunkHeight % subchunkSize != 0 || 32 % subchunkSize != 0) throw new ArgumentException("Width, height, and depth must be divisible by subchunk size!", nameof(subchunkSize));

        ChunkWidth = chunkWidth;
        ChunkHeight = chunkHeight;
        SubchunkSize = subchunkSize;
        DoCulling = doCulling;
        MaxOverhangCullDist = maxOverhangCullDist;
    }

    private static bool IsPowerOf2(int num)
    {
        return num > 0 && (num & (num - 1)) == 0;
    }
}
