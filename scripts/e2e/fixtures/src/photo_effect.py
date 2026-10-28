#!/usr/bin/env python3
"""Chrome headless で撮った帳票のスクリーンショットを、スマホで撮影した写真らしい PNG に変換する。

使い方:
    python3 photo_effect.py <入力PNG> <出力PNG> [--angle 1.4] [--seed 7]
                            [--background 176,170,162] [--margin 60]

やること: 用紙のわずかな回転、テーブル面風の背景と用紙の影、緩い斜めの照明ムラ、
弱いノイズとコントラスト調整。generateMedicinesFromImage の抽出対象であるため、
文字が読めなくなるほどは劣化させない (長辺 1000px へ縮小しても薬品名と用法が読める必要がある)。

乱数はすべて --seed から導出する。同じ入力・同じ引数からは常に同じ出力になり、
fixture を再生成しても git の差分が出ない。
"""

import argparse
import random

from PIL import Image, ImageEnhance, ImageFilter

# ノイズタイルの一辺(px)。全面を乱数で埋めると PNG の圧縮が効かずファイルが数 MB になるため、
# 小さなタイルを敷き詰めて使う。128px は繰り返しの周期が目視で分からない下限として選んだ。
noiseTileSize = 128

# ノイズの合成比率。0.03 は 1000px へ縮小しても粒状感が残り、かつ本文の文字が潰れない値。
noiseAlpha = 0.03

# 影の最大濃度。実際の卓上撮影で紙の縁に落ちる影の濃さに合わせた。
shadowOpacity = 0.45

# 影のぼかし半径(px)と用紙からのずれ(px)。斜め上からの室内照明を想定する。
shadowBlurRadius = 14
shadowOffset = (8, 14)


def build_noise_image(size: tuple[int, int], seed: int) -> Image.Image:
    """`size` を覆うグレースケールのノイズ画像を、`seed` から決定的に生成する。

    Image.effect_noise は乱数種を指定できないため、seed 付き random で作ったタイルを敷き詰める。
    半分の解像度で作って拡大するのは、隣り合う画素に相関を持たせて PNG の圧縮を効かせるため
    (画素ごとに独立な乱数だと fixture が 2MB 近くまで膨らむ)。粒が 2px 相当になり、
    スマホ写真の粒状感としてもこちらの方が近い。
    """
    tile = Image.new('L', (noiseTileSize, noiseTileSize))
    rng = random.Random(seed)
    tile.putdata([rng.gauss(128, 26) for _ in range(noiseTileSize * noiseTileSize)])
    halfSize = (size[0] // 2 + 1, size[1] // 2 + 1)
    noise = Image.new('L', halfSize)
    for y in range(0, halfSize[1], noiseTileSize):
        for x in range(0, halfSize[0], noiseTileSize):
            noise.paste(tile, (x, y))
    return noise.resize(size, Image.BILINEAR)


def build_lighting_mask(size: tuple[int, int]) -> Image.Image:
    """斜め方向に暗くなる照明ムラのマスクを作る。左上が明るく右下が暗い室内照明を模す。"""
    # 4x4 の粗いグラデーションを作って拡大する。ピクセル単位で計算するより速く、
    # 拡大時の補間でそのまま滑らかなムラになる。
    corners = Image.new('L', (4, 4))
    corners.putdata([255 - int(6.5 * (x + y)) for y in range(4) for x in range(4)])
    return corners.resize(size, Image.BICUBIC)


def apply_photo_effect(
    paper: Image.Image,
    angle: float,
    seed: int,
    background: tuple[int, int, int],
    margin: int,
) -> Image.Image:
    """帳票画像 `paper` を、机の上に置いて撮った写真風の画像へ変換する。"""
    rotated = paper.convert('RGBA').rotate(angle, resample=Image.BICUBIC, expand=True)
    canvas = Image.new('RGB', (rotated.width + margin * 2, rotated.height + margin * 2), background)

    shadow = Image.new('L', canvas.size, 0)
    shadow.paste(
        Image.new('L', paper.size, 255).rotate(angle, resample=Image.BICUBIC, expand=True),
        (margin + shadowOffset[0], margin + shadowOffset[1]),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(shadowBlurRadius)).point(lambda v: int(v * shadowOpacity))
    canvas = Image.composite(Image.new('RGB', canvas.size, (54, 50, 46)), canvas, shadow)

    canvas.paste(rotated, (margin, margin), rotated)

    canvas = Image.composite(
        canvas,
        Image.new('RGB', canvas.size, (0, 0, 0)),
        build_lighting_mask(canvas.size),
    )
    canvas = Image.blend(canvas, build_noise_image(canvas.size, seed).convert('RGB'), noiseAlpha)
    # レンズのわずかな甘さを再現する。0.3px はスキャン特有のエッジの硬さが消え、
    # かつ長辺 1000px へ縮小したあとも本文が読める範囲。
    canvas = canvas.filter(ImageFilter.GaussianBlur(0.3))
    return ImageEnhance.Contrast(canvas).enhance(1.06)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input')
    parser.add_argument('output')
    parser.add_argument('--angle', type=float, default=1.4, help='用紙の回転角(度)')
    parser.add_argument('--seed', type=int, default=7, help='ノイズの乱数種')
    parser.add_argument('--background', default='176,170,162', help='用紙の外側の色 R,G,B')
    parser.add_argument('--margin', type=int, default=60, help='用紙の外側に見せる背景の幅(px)')
    args = parser.parse_args()

    with Image.open(args.input) as source:
        apply_photo_effect(
            paper=source.convert('RGB'),
            angle=args.angle,
            seed=args.seed,
            background=tuple(int(value) for value in args.background.split(',')),
            margin=args.margin,
        ).save(args.output, optimize=True)


if __name__ == '__main__':
    main()
