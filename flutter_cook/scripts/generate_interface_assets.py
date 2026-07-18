import argparse
import shutil
from pathlib import Path
from typing import Callable, Iterable, Optional, Tuple, Union

from PIL import Image, ImageDraw


DEFAULT_OUTPUT_DIR = Path(__file__).resolve().parents[1] / "assets" / "images"
STALE_DENSITY_DIRECTORIES = ("2.0x", "3.0x")

MINT = "#13C89A"
MINT_DEEP = "#087C63"
MINT_SOFT = "#DDF8EE"
TOMATO = "#F05249"
PUMPKIN = "#FF8A3D"
PLUM = "#6B5BF5"
LIME = "#8BC34A"
MUTED = "#6F7A75"
WEAK = "#A3ADA8"
INK = "#24312C"
WHITE = "#FFFFFF"


Canvas = Tuple[Image.Image, ImageDraw.ImageDraw, int]
PixelSize = Tuple[int, int]


def color(hex_value: str) -> Tuple[int, int, int, int]:
    hex_value = hex_value.lstrip("#")
    return (
        int(hex_value[0:2], 16),
        int(hex_value[2:4], 16),
        int(hex_value[4:6], 16),
        255,
    )


def rgba(hex_value: str, alpha: int) -> Tuple[int, int, int, int]:
    red, green, blue, _ = color(hex_value)
    return red, green, blue, alpha


def canvas(size: int, scale: int = 4) -> Canvas:
    image = Image.new("RGBA", (size * scale, size * scale), (0, 0, 0, 0))
    return image, ImageDraw.Draw(image), scale


def save(image: Image.Image, path: Path, size: PixelSize) -> None:
    resized = image.resize(size, Image.Resampling.LANCZOS)
    if resized.mode != "RGBA":
        resized = resized.convert("RGBA")
    resized.save(path)


def line(draw: ImageDraw.ImageDraw, points: Iterable[Tuple[float, float]], fill: str, scale: int, width: float = 2.2) -> None:
    scaled = [(x * scale, y * scale) for x, y in points]
    stroke_width = round(width * scale)
    draw.line(scaled, fill=color(fill), width=stroke_width, joint="curve")

    # Pillow 的 line 默认是平头端点，会让小尺寸图标显得生硬且光学重量不足。
    radius = stroke_width / 2
    for x, y in (scaled[0], scaled[-1]):
        draw.ellipse(
            (x - radius, y - radius, x + radius, y + radius),
            fill=color(fill),
        )


def circle(draw: ImageDraw.ImageDraw, box: Tuple[float, float, float, float], fill: Optional[str], outline: Optional[str], scale: int, width: float = 2.0) -> None:
    scaled = tuple(v * scale for v in box)
    draw.ellipse(
        scaled,
        fill=color(fill) if fill else None,
        outline=color(outline) if outline else None,
        width=round(width * scale),
    )


def rounded_rect(draw: ImageDraw.ImageDraw, box: Tuple[float, float, float, float], radius: float, fill: Union[str, Tuple[int, int, int, int]], scale: int, outline: Optional[str] = None, width: float = 1.0) -> None:
    scaled = tuple(v * scale for v in box)
    draw.rounded_rectangle(
        scaled,
        radius=round(radius * scale),
        fill=color(fill) if isinstance(fill, str) else fill,
        outline=color(outline) if outline else None,
        width=round(width * scale),
    )


def gradient(size: int, stops: Tuple[str, str, str], scale: int = 4) -> Image.Image:
    width = height = size * scale
    image = Image.new("RGBA", (width, height))
    pixels = image.load()
    c0 = color(stops[0])
    c1 = color(stops[1])
    c2 = color(stops[2])
    for y in range(height):
        for x in range(width):
            t = (x + y) / (width + height - 2)
            if t < 0.58:
                local = t / 0.58
                base_a, base_b = c0, c1
            else:
                local = (t - 0.58) / 0.42
                base_a, base_b = c1, c2
            pixels[x, y] = tuple(
                round(base_a[i] + (base_b[i] - base_a[i]) * local)
                for i in range(4)
            )
    return image


def icon_home(stroke: str) -> Image.Image:
    image, draw, scale = canvas(32)
    line(draw, [(4.5, 16.2), (16, 6.5), (27.5, 16.2)], stroke, scale, 2.4)
    line(draw, [(7.5, 15.2), (7.5, 27), (24.5, 27), (24.5, 15.2)], stroke, scale, 2.4)
    line(draw, [(13.2, 27), (13.2, 20.2), (18.8, 20.2), (18.8, 27)], stroke, scale, 2.2)
    return image


def icon_cook(stroke: str) -> Image.Image:
    image, draw, scale = canvas(32)
    line(draw, [(5.5, 5), (5.5, 17)], stroke, scale, 2.4)
    line(draw, [(11.5, 5), (11.5, 17)], stroke, scale, 2.4)
    line(draw, [(5.5, 11), (11.5, 11)], stroke, scale, 2.2)
    line(draw, [(8.5, 17), (8.5, 28)], stroke, scale, 2.4)
    line(draw, [(23.5, 5), (23.5, 28)], stroke, scale, 2.4)
    line(draw, [(23.5, 5), (28, 11), (27.5, 17), (23.5, 20.5)], stroke, scale, 2.4)
    return image


def icon_recipe(stroke: str) -> Image.Image:
    image, draw, scale = canvas(32)
    rounded_rect(draw, (5, 4, 27, 28), 3.2, (0, 0, 0, 0), scale, stroke, 2.4)
    line(draw, [(9.5, 10.5), (22.5, 10.5)], stroke, scale, 2.3)
    line(draw, [(9.5, 16), (22.5, 16)], stroke, scale, 2.3)
    line(draw, [(9.5, 21.5), (20, 21.5)], stroke, scale, 2.3)
    return image


def icon_mine(stroke: str) -> Image.Image:
    image, draw, scale = canvas(32)
    circle(draw, (10, 4.5, 22, 16.5), None, stroke, scale, 2.4)
    line(draw, [(4.5, 28), (7.2, 21.8), (16, 19), (24.8, 21.8), (27.5, 28)], stroke, scale, 2.4)
    return image


def search_icon() -> Image.Image:
    image, draw, scale = canvas(32)
    circle(draw, (5.5, 5.5, 21.5, 21.5), None, INK, scale, 2.4)
    line(draw, [(19.5, 19.5), (27, 27)], INK, scale, 2.4)
    return image


def delete_icon() -> Image.Image:
    image, draw, scale = canvas(32)
    line(draw, [(6.8, 9.6), (25.2, 9.6)], INK, scale, 2.2)
    line(
        draw,
        [(12.2, 9.6), (12.9, 6.2), (19.1, 6.2), (19.8, 9.6)],
        INK,
        scale,
        2.1,
    )
    line(
        draw,
        [(9.5, 12), (10.4, 26.2), (21.6, 26.2), (22.5, 12)],
        INK,
        scale,
        2.2,
    )
    line(draw, [(14.2, 14), (14.6, 22.8)], INK, scale, 1.9)
    line(draw, [(17.8, 14), (17.4, 22.8)], INK, scale, 1.9)
    return image


def arrow_right_icon() -> Image.Image:
    image, draw, scale = canvas(32)
    line(draw, [(12.5, 9), (19.5, 16), (12.5, 23)], INK, scale, 2.2)
    return image


def check_icon() -> Image.Image:
    image, draw, scale = canvas(28)
    circle(draw, (3.2, 3.2, 24.8, 24.8), MINT, None, scale)
    line(draw, [(8.8, 14.3), (12.2, 17.4), (19.4, 9.9)], WHITE, scale, 2.6)
    return image


def uncheck_icon() -> Image.Image:
    image, draw, scale = canvas(28)
    circle(draw, (4, 4, 24, 24), WHITE, WEAK, scale, 1.6)
    return image


def favorite_icon(active: bool) -> Image.Image:
    image, draw, scale = canvas(36)
    points = [(18, 28), (9, 19), (8.5, 13.7), (11.8, 10.5), (16, 12.2), (18, 14.8), (20, 12.2), (24.2, 10.5), (27.5, 13.7), (27, 19)]
    scaled = [(x * scale, y * scale) for x, y in points]
    draw.line(scaled + [scaled[0]], fill=color(TOMATO), width=round(2.2 * scale), joint="curve")
    if active:
        draw.polygon(scaled, fill=color(TOMATO))
    return image


def video_play_icon() -> Image.Image:
    image, draw, scale = canvas(120)
    circle(draw, (14, 14, 106, 106), WHITE, MINT_SOFT, scale, 2)
    draw.polygon([(51 * scale, 42 * scale), (80 * scale, 60 * scale), (51 * scale, 78 * scale)], fill=color(MINT_DEEP))
    return image


def refresh_icon() -> Image.Image:
    image, draw, scale = canvas(32)
    line(draw, [(23.5, 11.5), (25.4, 8.5), (25.4, 14.2)], INK, scale, 2.2)
    draw.arc((8 * scale, 8 * scale, 24 * scale, 24 * scale), 25, 330, fill=color(INK), width=round(2.2 * scale))
    return image


def settings_icon() -> Image.Image:
    image, draw, scale = canvas(32)
    circle(draw, (13, 13, 19, 19), None, INK, scale, 2.2)
    for a, b in [((16, 6.5), (16, 9.5)), ((16, 22.5), (16, 25.5)), ((6.5, 16), (9.5, 16)), ((22.5, 16), (25.5, 16)), ((9.4, 9.4), (11.5, 11.5)), ((20.5, 20.5), (22.6, 22.6)), ((22.6, 9.4), (20.5, 11.5)), ((11.5, 20.5), (9.4, 22.6))]:
        line(draw, [a, b], INK, scale, 2.2)
    return image


def share_icon() -> Image.Image:
    image, draw, scale = canvas(32)
    line(draw, [(18, 8.5), (24, 8.5), (24, 14.5)], INK, scale, 2.2)
    line(draw, [(14, 18), (24, 8.5)], INK, scale, 2.2)
    line(draw, [(20.5, 18.5), (20.5, 24), (8.5, 24), (8.5, 11.5), (14, 11.5)], INK, scale, 2.2)
    return image


def close_icon() -> Image.Image:
    image, draw, scale = canvas(32)
    line(draw, [(10.5, 10.5), (21.5, 21.5)], INK, scale, 2.2)
    line(draw, [(21.5, 10.5), (10.5, 21.5)], INK, scale, 2.2)
    return image


def smart_icon() -> Image.Image:
    image, draw, scale = canvas(32)
    circle(draw, (5, 5, 27, 27), PUMPKIN, None, scale)
    points = [(16, 8.5), (18.2, 13.8), (23.5, 16), (18.2, 18.2), (16, 23.5), (13.8, 18.2), (8.5, 16), (13.8, 13.8)]
    draw.polygon([(x * scale, y * scale) for x, y in points], fill=color(WHITE))
    return image


def banner_placeholder() -> Image.Image:
    size = (393, 268)
    scale = 3
    image = Image.new("RGBA", (size[0] * scale, size[1] * scale), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    rounded_rect(draw, (12, 12, 381, 256), 34, rgba(MINT, 230), scale)
    base = gradient(268, (MINT, LIME, PUMPKIN), scale).resize(image.size)
    mask = Image.new("L", image.size, 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle((12 * scale, 12 * scale, 381 * scale, 256 * scale), radius=34 * scale, fill=230)
    image.alpha_composite(Image.composite(base, Image.new("RGBA", image.size, (0, 0, 0, 0)), mask))
    draw = ImageDraw.Draw(image)
    draw.ellipse((286 * scale, 26 * scale, 372 * scale, 112 * scale), fill=(255, 255, 255, 48))
    draw.ellipse((24 * scale, 170 * scale, 136 * scale, 282 * scale), fill=(255, 255, 255, 34))
    draw.line([(82 * scale, 150 * scale), (128 * scale, 112 * scale), (188 * scale, 128 * scale), (250 * scale, 160 * scale), (338 * scale, 142 * scale)], fill=(255, 255, 255, 105), width=7 * scale, joint="curve")
    draw.line([(96 * scale, 104 * scale), (168 * scale, 104 * scale)], fill=(255, 255, 255, 148), width=8 * scale)
    draw.line([(96 * scale, 128 * scale), (216 * scale, 128 * scale)], fill=(255, 255, 255, 148), width=8 * scale)
    return image


def image_placeholder() -> Image.Image:
    image, draw, scale = canvas(98)
    rounded_rect(draw, (7, 7, 91, 91), 26, MINT_SOFT, scale)
    line(draw, [(28, 64), (43, 48), (55, 59), (63, 51), (73, 64)], MINT_DEEP, scale, 4)
    circle(draw, (58, 27, 70, 39), PUMPKIN, None, scale)
    return image


ASSETS: dict[str, Tuple[PixelSize, Callable[[], Image.Image]]] = {
    "tab_home.png": ((32, 32), lambda: icon_home(MUTED)),
    "tab_home_active.png": ((32, 32), lambda: icon_home(MINT_DEEP)),
    "tab_cook.png": ((32, 32), lambda: icon_cook(MUTED)),
    "tab_cook_active.png": ((32, 32), lambda: icon_cook(MINT_DEEP)),
    "tab_recipe.png": ((32, 32), lambda: icon_recipe(MUTED)),
    "tab_recipe_active.png": ((32, 32), lambda: icon_recipe(MINT_DEEP)),
    "tab_mine.png": ((32, 32), lambda: icon_mine(MUTED)),
    "tab_mine_active.png": ((32, 32), lambda: icon_mine(MINT_DEEP)),
    "icon_search.png": ((32, 32), search_icon),
    "icon_delete.png": ((32, 32), delete_icon),
    "icon_arrow_right.png": ((32, 32), arrow_right_icon),
    "icon_check.png": ((28, 28), check_icon),
    "icon_uncheck.png": ((28, 28), uncheck_icon),
    "icon_favorite.png": ((36, 36), lambda: favorite_icon(False)),
    "icon_favorite_active.png": ((36, 36), lambda: favorite_icon(True)),
    "icon_video_play.png": ((120, 120), video_play_icon),
    "icon_refresh.png": ((32, 32), refresh_icon),
    "icon_settings.png": ((32, 32), settings_icon),
    "icon_share.png": ((32, 32), share_icon),
    "icon_close.png": ((32, 32), close_icon),
    "icon_smart.png": ((32, 32), smart_icon),
    "bg_banner_placeholder.png": ((393, 268), banner_placeholder),
    "bg_image_placeholder.png": ((98, 98), image_placeholder),
}


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="生成 CookFun 界面 PNG 资源")
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="资源输出目录，默认写入项目 assets/images",
    )
    return parser.parse_args()


def main() -> None:
    arguments = parse_arguments()
    output_dir = arguments.output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    for directory_name in STALE_DENSITY_DIRECTORIES:
        stale_directory = output_dir / directory_name
        if stale_directory.exists():
            shutil.rmtree(stale_directory)

    for filename, (logical_size, factory) in ASSETS.items():
        source = factory()
        target_size = (logical_size[0] * 3, logical_size[1] * 3)
        save(source, output_dir / filename, target_size)

    logo_path = output_dir / "app_logo.png"
    if not logo_path.exists():
        raise RuntimeError("必须保留原有 app_logo.png")

    for path in sorted(output_dir.glob("*.png")):
        with Image.open(path) as saved:
            if saved.mode != "RGBA":
                raise RuntimeError(f"{path.name} 缺少透明通道")
        print(path)


if __name__ == "__main__":
    main()
