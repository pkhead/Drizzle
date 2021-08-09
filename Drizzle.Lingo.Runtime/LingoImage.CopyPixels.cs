﻿using System;
using System.Diagnostics;
using System.Numerics;
using System.Runtime.CompilerServices;
using Serilog;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;

namespace Drizzle.Lingo.Runtime
{
    public sealed partial class LingoImage
    {
        /*
             private static int CopiesPixelFast;
   private static int CopiesEqualNonStretch;
        private static int CopiesNonStretch;
        private static int CopiesEqual;
        private static int CopiesEqualTall;
        private static int CopiesOther;

        private static Dictionary<(int w, int h), int> Sizes = new();
        */

        public void copypixels(LingoImage source, LingoList destQuad, LingoRect sourceRect, LingoPropertyList paramList)
        {
            Log.Warning("copyPixels() destquad: not implemented");
        }

        public void copypixels(LingoImage source, LingoRect destRect, LingoRect sourceRect)
        {
            var parameters = new CopyPixelsParameters
            {
                Blend = 1,
                Ink = CopyPixelsInk.Copy
            };

            CopyPixelsImpl(source, this, destRect, sourceRect, parameters);
        }

        public void copypixels(LingoImage source, LingoRect destRect, LingoRect sourceRect, LingoPropertyList paramList)
        {
            var parameters = new CopyPixelsParameters();
            if (paramList.Dict.TryGetValue(new LingoSymbol("blend"), out var blendValObj))
            {
                var dec = (LingoDecimal)blendValObj!;
                parameters.Blend = (float)(dec.Value / 100f);
            }
            else
            {
                parameters.Blend = 1;
            }

            if (paramList.Dict.TryGetValue(new LingoSymbol("color"), out var colorObj))
                parameters.ForeColor = (LingoColor)colorObj!;

            if (paramList.Dict.TryGetValue(new LingoSymbol("ink"), out var inkVal))
                parameters.Ink = (CopyPixelsInk)(int)inkVal!;

            if (paramList.Dict.ContainsKey(new LingoSymbol("mask")))
                Log.Warning("copypixels(): Mask rendering not implemented");

            CopyPixelsImpl(source, this, destRect, sourceRect, parameters);
        }

        private static void CopyPixelsImpl(
            LingoImage source,
            LingoImage dest,
            LingoRect destRect,
            LingoRect sourceRect,
            in CopyPixelsParameters parameters)
        {
            Debug.Assert(!dest.IsPxl);

            /*
            if (destRect.width == sourceRect.width && destRect.height == sourceRect.height)
            {
                if (source.Depth == dest.Depth)
                    CopiesEqualNonStretch += 1;
                else
                    CopiesNonStretch += 1;
            }
            else
            {
                if (source.Depth == dest.Depth)
                {
                    CopiesEqual += 1;
                }
                else
                    CopiesOther += 1;
            }

            if (source.width == 1 && source.height == 1 && parameters.Ink != CopyPixelsInk.Copy)
            {
                var tup = ((int)destRect.width, (int)destRect.height);
                if (!Sizes.ContainsKey(tup))
                    Sizes[tup] = 0;

                CollectionsMarshal.GetValueRefOrNullRef(Sizes, tup) += 1;
            }
            */

            // Integer coordinates for the purpose of rasterization.
            var dstL = destRect.left.integer;
            var dstT = destRect.top.integer;
            var dstR = destRect.right.integer;
            var dstB = destRect.bottom.integer;

            // ReSharper disable once CompareOfFloatsByEqualityOperator
            // todo: make sure to not apply this when mask is set.
            if (source.IsPxl && parameters.Blend == 1 && parameters.Ink == CopyPixelsInk.Copy)
            {
                // CopiesPixelFast += 1;
                CopyPixelsPxlRectGenWriter(dest, (dstL, dstT, dstR, dstB), parameters);
                return;
            }

            if (parameters.Ink == CopyPixelsInk.Darkest)
                Log.Warning("copypixels(): Darkest ink not implemented");

            // Float coordinates for the purposes of sampling.
            var srcL = (float)(sourceRect.left / source.width);
            var srcT = (float)(sourceRect.top / source.height);
            var srcR = (float)(sourceRect.right / source.width);
            var srcB = (float)(sourceRect.bottom / source.height);

            // Half-texel offset so we sample the *center* of the pixels, not the edges.
            var offsetH = (0.5f / source.width);
            var offsetV = (0.5f / source.height);

            srcL += offsetH;
            srcT += offsetV;
            srcR += offsetH;
            srcB += offsetV;

            // LTRB
            var srcBox = new Vector4(srcL, srcT, srcR, srcB);

            CopyPixelsRectGenWriter(source, dest, srcBox, (dstL, dstT, dstR, dstB), parameters);

            /*var srcImg = source.Image;

            var srcCropped = srcImg.Clone(ctx => ctx.Crop(srcRect));

            if (sourceRect.right > srcImg.Width
                || sourceRect.bottom > srcImg.Height
                || sourceRect.left < 0
                || sourceRect.top < 0)
            {
                Log.Debug("copyPixels() doing out-of bounds read");

                var padImage = NewImgForDepth(Depth, (int)sourceRect.width, (int)sourceRect.height);

                padImage.Mutate(
                    ctx =>
                    {
                        var point = new Point(Math.Max(0, (int)-sourceRect.left), Math.Max(0, (int)-sourceRect.top));
                        ctx.DrawImage(srcCropped, point, opacity: 1f);
                    });

                srcCropped = padImage;
            }

            Image.Mutate(c =>
            {
                var srcScaled = srcCropped.Clone(s =>
                    s.Resize((int)destRect.width, (int)destRect.height, new NearestNeighborResampler()));

                c.DrawImage(srcScaled, new Point((int)destRect.left, (int)destRect.top), PixelColorBlendingMode.Overlay,
                    1);
            });*/
        }

        private static void CopyPixelsRectGenWriter(
            LingoImage src, LingoImage dst,
            Vector4 srcBox,
            (int l, int t, int r, int b) dstBox,
            in CopyPixelsParameters parameters)
        {
            switch (dst.Depth)
            {
                case 32:
                    CopyPixelsRectGenSampler<Bgra32, PixelWriterRgb<Bgra32>>(
                        src,
                        (Image<Bgra32>)dst.Image,
                        srcBox,
                        dstBox,
                        parameters);
                    break;
                case 16:
                    CopyPixelsRectGenSampler<Bgra5551, PixelWriterRgb<Bgra5551>>(
                        src,
                        (Image<Bgra5551>)dst.Image,
                        srcBox,
                        dstBox,
                        parameters);
                    break;
                case 8:
                    CopyPixelsRectGenSampler<L8, PixelWriterPalette8>(
                        src,
                        (Image<L8>)dst.Image,
                        srcBox,
                        dstBox,
                        parameters);
                    break;
                case 1:
                    CopyPixelsRectGenSampler<L8, PixelWriterBit>(
                        src,
                        (Image<L8>)dst.Image,
                        srcBox,
                        dstBox,
                        parameters);
                    break;
                default:
                    // Not implemented.
                    break;
            }
        }

        private static void CopyPixelsRectGenSampler<TDstData, TWriter>(
            LingoImage src, Image<TDstData> dstImg,
            Vector4 srcBox,
            (int l, int t, int r, int b) dstBox,
            in CopyPixelsParameters parameters)
            where TWriter : struct, IPixelWriter<TDstData>
            where TDstData : unmanaged, IPixel<TDstData>
        {
            switch (src.Depth)
            {
                case 32:
                    CopyPixelsRectCoreCopy<Bgra32, PixelSamplerRgb<Bgra32>, TDstData, TWriter>(
                        (Image<Bgra32>)src.Image,
                        dstImg,
                        srcBox,
                        dstBox,
                        parameters);
                    break;
                case 16:
                    CopyPixelsRectCoreCopy<Bgra5551, PixelSamplerRgb<Bgra5551>, TDstData, TWriter>(
                        (Image<Bgra5551>)src.Image,
                        dstImg,
                        srcBox,
                        dstBox,
                        parameters);
                    break;
                case 8:
                    CopyPixelsRectCoreCopy<L8, PixelSamplerPalette8, TDstData, TWriter>(
                        (Image<L8>)src.Image,
                        dstImg,
                        srcBox,
                        dstBox,
                        parameters);
                    break;
                case 1:
                    CopyPixelsRectCoreCopy<L8, PixelSamplerBit, TDstData, TWriter>(
                        (Image<L8>)src.Image,
                        dstImg,
                        srcBox,
                        dstBox,
                        parameters);
                    break;
                default:
                    // Not implemented.
                    break;
            }
        }

        // Struct generics for static dispatch.
        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        private static void CopyPixelsRectCoreCopy<TSrcData, TSampler, TDstData, TWriter>(
            Image<TSrcData> srcImg, Image<TDstData> dstImg,
            Vector4 srcBox,
            (int l, int t, int r, int b) dstBox,
            in CopyPixelsParameters parameters)
            where TSampler : struct, IPixelSampler<TSrcData>
            where TSrcData : unmanaged, IPixel<TSrcData>
            where TWriter : struct, IPixelWriter<TDstData>
            where TDstData : unmanaged, IPixel<TDstData>
        {
            var (dstL, dstT, dstR, dstB) = dstBox;

            // Horizontal increment for sampling coordinates when the rasterizer iterates.
            var incSrcH = (srcBox.Z - srcBox.X) / (dstR - dstL);
            var incSrcV = (srcBox.W - srcBox.Y) / (dstB - dstT);

            var sampler = new TSampler();
            var writer = new TWriter();

            if (!srcImg.TryGetSinglePixelSpan(out var srcSpan))
                throw new InvalidOperationException("TryGetSinglePixelSpan failed");

            if (!dstImg.TryGetSinglePixelSpan(out var dstSpan))
                throw new InvalidOperationException("TryGetSinglePixelSpan failed");

            var srcImgW = srcImg.Width;
            var srcImgH = srcImg.Height;
            var dstImgW = dstImg.Width;
            var dstImgH = dstImg.Height;

            var doBackgroundTransparent = parameters.Ink == CopyPixelsInk.BackgroundTransparent;
            var fgc = parameters.ForeColor;
            var fg = new Vector4(fgc.red / 255f, fgc.green / 255f, fgc.blue / 255f, 0f);

            var t = srcBox.Y;
            for (var y = dstT; y < dstB; y++)
            {
                if (y >= 0 && y < dstImgH)
                {
                    var s = srcBox.X;

                    for (var x = dstL; x < dstR; x++)
                    {
                        if (x >= 0 && x < dstImgW)
                        {
                            Vector4 color;
                            if (s < 0 || s >= 1 || t < 0 || t >= 1)
                                color = Vector4.One;
                            else
                                color = sampler.Sample(srcSpan, srcImgW, srcImgH, new Vector2(s, t));

                            if (!doBackgroundTransparent || color != Vector4.One)
                            {
                                color += fg;
                                writer.Write(dstSpan, dstImgW * y + x, color);
                            }
                        }

                        s += incSrcH;
                    }
                }

                t += incSrcV;
            }
        }

        private static void CopyPixelsPxlRectGenWriter(
            LingoImage dst,
            (int l, int t, int r, int b) dstBox,
            in CopyPixelsParameters parameters)
        {
            switch (dst.Depth)
            {
                case 32:
                    CopyPixelsPxlRectCore<Bgra32, PixelWriterRgb<Bgra32>>(
                        (Image<Bgra32>)dst.Image,
                        dstBox,
                        parameters);
                    break;
                case 16:
                    CopyPixelsPxlRectCore<Bgra5551, PixelWriterRgb<Bgra5551>>(
                        (Image<Bgra5551>)dst.Image,
                        dstBox,
                        parameters);
                    break;
                case 1:
                    CopyPixelsPxlRectCore<L8, PixelWriterBit>(
                        (Image<L8>)dst.Image,
                        dstBox,
                        parameters);
                    break;
                default:
                    // Not implemented.
                    break;
            }
        }

        private static void CopyPixelsPxlRectCore<TDstData, TWriter>(
            Image<TDstData> dstImg,
            (int l, int t, int r, int b) dstBox,
            in CopyPixelsParameters parameters)
            where TWriter : struct, IPixelWriter<TDstData>
            where TDstData : unmanaged, IPixel<TDstData>
        {
            var (dstL, dstT, dstR, dstB) = dstBox;

            dstL = Math.Clamp(dstL, 0, dstImg.Width);
            dstT = Math.Clamp(dstT, 0, dstImg.Height);
            dstR = Math.Clamp(dstR, 0, dstImg.Width);
            dstB = Math.Clamp(dstB, 0, dstImg.Height);

            if (!dstImg.TryGetSinglePixelSpan(out var dstSpan))
                throw new InvalidOperationException("TryGetSinglePixelSpan failed");

            var dstWidth = dstImg.Width;
            var w = new TWriter();

            // todo: remove round trip to Vector4 here please.
            var fgc = parameters.ForeColor;
            var fg = new Vector4(fgc.red / 255f, fgc.green / 255f, fgc.blue / 255f, 1f);

            for (var y = dstT; y < dstB; y++)
            {
                for (var x = dstL; x < dstR; x++)
                {
                    w.Write(dstSpan, y * dstWidth + x, fg);
                }
            }
        }

        private struct CopyPixelsParameters
        {
            public CopyPixelsInk Ink;
            public float Blend;

            public LingoColor ForeColor;
            // todo: mask
        }

        private enum CopyPixelsInk
        {
            Copy = 0,
            BackgroundTransparent = 36,
            Darkest = 39
        }

        private interface IPixelSampler<TPixel>
        {
            Vector4 Sample(ReadOnlySpan<TPixel> srcDat, int srcWidth, int srcHeight, Vector2 pos);
        }

        private interface IPixelWriter<TPixel>
        {
            void Write(Span<TPixel> dstDat, int rowMajorPos, Vector4 value);
        }

        // Bgra32 and Bgra5551 image sampler/writer.
        // Can use common generic code thanks to ImageSharp pixel helpers.
        private struct PixelSamplerRgb<TPixel> : IPixelSampler<TPixel>
            where TPixel : unmanaged, IPixel<TPixel>
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining | MethodImplOptions.AggressiveOptimization)]
            public Vector4 Sample(ReadOnlySpan<TPixel> srcDat, int srcWidth, int srcHeight, Vector2 pos)
            {
                var x = (int)(pos.X * srcWidth);
                var y = (int)(pos.Y * srcHeight);

                var rowMajor = x + y * srcWidth;
                var px = srcDat[rowMajor];
                return px.ToVector4();
            }
        }

        private struct PixelWriterRgb<TPixel> : IPixelWriter<TPixel>
            where TPixel : unmanaged, IPixel<TPixel>
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining | MethodImplOptions.AggressiveOptimization)]
            public void Write(Span<TPixel> dstDat, int rowMajorPos, Vector4 value)
            {
                dstDat[rowMajorPos].FromVector4(value);
            }
        }

        private struct PixelSamplerPalette8 : IPixelSampler<L8>
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining | MethodImplOptions.AggressiveOptimization)]
            public Vector4 Sample(ReadOnlySpan<L8> srcDat, int srcWidth, int srcHeight, Vector2 pos)
            {
                var x = (int)(pos.X * srcWidth);
                var y = (int)(pos.Y * srcHeight);

                var rowMajor = x + y * srcWidth;
                var px = srcDat[rowMajor].PackedValue;
                var lingoColor = (LingoColor)px;
                return new Vector4(lingoColor.red / 255f, lingoColor.green / 255f, lingoColor.blue / 255f, 1);
            }
        }

        private struct PixelWriterPalette8 : IPixelWriter<L8>
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining | MethodImplOptions.AggressiveOptimization)]
            public void Write(Span<L8> dstDat, int rowMajorPos, Vector4 value)
            {
                var r = (int)(value.X * 255);
                var g = (int)(value.Y * 255);
                var b = (int)(value.Z * 255);

                if (r == 255 && g == 0 && b == 0)
                {
                    // Palette index of red.
                    dstDat[rowMajorPos] = new L8(6);
                }
                else if (r == 0 && g == 0 && b == 0)
                {
                    // Black.
                    dstDat[rowMajorPos] = new L8(255);
                }
                else
                {
                    // White.
                    dstDat[rowMajorPos] = new L8(0);
                }
            }
        }

        private struct PixelSamplerBit : IPixelSampler<L8>
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining | MethodImplOptions.AggressiveOptimization)]
            public Vector4 Sample(ReadOnlySpan<L8> srcDat, int srcWidth, int srcHeight, Vector2 pos)
            {
                var x = Math.Clamp((int)(pos.X * srcWidth), 0, srcWidth - 1);
                var y = Math.Clamp((int)(pos.Y * srcHeight), 0, srcHeight - 1);

                var rowMajor = x + y * srcWidth;
                var px = srcDat[rowMajor];
                return px.PackedValue == 255 ? Vector4.One : new Vector4(0, 0, 0, 1);
            }
        }

        private struct PixelWriterBit : IPixelWriter<L8>
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining | MethodImplOptions.AggressiveOptimization)]
            public void Write(Span<L8> dstDat, int rowMajorPos, Vector4 value)
            {
                dstDat[rowMajorPos] = value.X != 0 ? new L8(255) : new L8(0);
            }
        }
    }
}
