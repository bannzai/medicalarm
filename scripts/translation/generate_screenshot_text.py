import json
import os

import openai

openai.organization = os.environ.get("OPENAI_ORGANIZATION")
openai.api_key = os.environ.get("OPENAI_API_KEY")

os.chdir(os.environ.get("PROJECT_DIR"))


def load():
    with open("resources/text_to_image.json", "r") as file:
        return json.load(file)


text_to_image_json = load()


def insert_newline(text, boundary_length):
    if boundary_length <= 0 or len(text) < boundary_length:
        # 境界値が不正な場合、またはテキストが境界値未満の場合は何もしない
        return text

    # 15文字目以降の空白を検索
    space_after_boundary = text[boundary_length - 1 :].find(" ")

    # 境界値の前の空白を検索
    space_before_boundary = text[:boundary_length].rfind(" ")

    print(
        f"space_after_boundary: {space_after_boundary}, space_before_boundary: {space_before_boundary}"
    )
    # どちらの空白も見つからない場合
    if space_after_boundary == -1 and space_before_boundary == -1:
        return text[: boundary_length - 1] + "\n" + text[boundary_length - 1 :]
    # 境界値以降のみ空白
    elif space_before_boundary == -1:
        return (
            text[: boundary_length - 1 + space_after_boundary]
            + "\n"
            + text[boundary_length - 1 + space_after_boundary + 1 :]
        )
    # 境界値以前のみ空白
    elif space_after_boundary == -1:
        return text[:space_before_boundary] + "\n" + text[space_before_boundary + 1 :]
    # 境界値の前後どちらにも空白がある場合は、空白が近い方に改行を入れる
    else:
        if space_after_boundary < space_before_boundary:
            return (
                text[: boundary_length - 1 + space_after_boundary]
                + "\n"
                + text[boundary_length - 1 + space_after_boundary + 1 :]
            )
        else:
            return (
                text[:space_before_boundary] + "\n" + text[space_before_boundary + 1 :]
            )


for lang in text_to_image_json:
    print(f"Start {lang}")

    list = text_to_image_json[lang]
    for translated in list:
        title = translated.get("title", "")
        title = insert_newline(title, 15)
        subtitle = translated.get("subtitle", "")
        subtitle = insert_newline(subtitle, 30)
        index = translated["index"]
        print(
            f"Generate lang: {lang} title: {title}, subtitle: {subtitle}, index: {index}"
        )
        return_code = os.system(
            f'./text_to_image.sh "{title}" "{subtitle}" "{lang}" "{index}"'
        )
        if return_code == 0:
            print("text_to_imageスクリプトは正常に実行されました。")
        else:
            print("text_to_imageスクリプトはエラーで終了しました。")

"Finish generate_screenshot_text.py"
