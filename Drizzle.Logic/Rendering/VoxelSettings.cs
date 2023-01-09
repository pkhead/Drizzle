using System;

namespace Drizzle.Logic.Rendering;

internal class VoxelSettings
{
    public int ChunkWidth { get; }
    public int ChunkHeight { get; }
    public int SubchunkSize { get; }
    public static VoxelSettings Default { get; } = new VoxelSettings(128, 128, 8);

    public VoxelSettings(int chunkWidth, int chunkHeight, int subchunkSize)
    {
        if (!IsPowerOf2(chunkWidth)) throw new ArgumentException("Width must be a power of 2!", nameof(chunkWidth));
        if (!IsPowerOf2(chunkHeight)) throw new ArgumentException("Height must be a power of 2!", nameof(chunkHeight));
        if (subchunkSize <= 0) throw new ArgumentException("Subchunk size must be positive!", nameof(subchunkSize));
        if (subchunkSize > chunkWidth || subchunkSize > chunkHeight || subchunkSize > 32) throw new ArgumentException("Subchunk size may not be greater than width, height, or depth!", nameof(subchunkSize));
        if (chunkWidth % subchunkSize != 0 || chunkHeight % subchunkSize != 0 || 32 % subchunkSize != 0) throw new ArgumentException("Width, height, and depth must be divisible by subchunk size!", nameof(subchunkSize));

        ChunkWidth = chunkWidth;
        ChunkHeight = chunkHeight;
        SubchunkSize = subchunkSize;
    }

    private static bool IsPowerOf2(int num)
    {
        return num > 0 && (num & (num - 1)) == 0;
    }
}
