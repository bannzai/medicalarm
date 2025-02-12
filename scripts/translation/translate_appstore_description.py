import json
import os

import openai

openai.organization = os.environ.get("OPENAI_ORGANIZATION")
openai.api_key = os.environ.get("OPENAI_API_KEY")

langs = [
    "ar-SA",
    "ca",
    "cs",
    "da",
    "de-DE",
    "el",
    "en-AU",
    "en-CA",
    "en-GB",
    "en-US",
    "es-ES",
    "es-MX",
    "fi",
    "he",
    "hi",
    "hr",
    "hu",
    "id",
    "it",
    "ja",
    "ko",
    "ms",
    "nl-NL",
    "no",
    "pl",
    "pt-BR",
    "pt-PT",
    "ro",
    "sk",
    "sv",
    "th",
    "tr",
    "uk",
    "vi",
    "zh-Hans",
    "zh-Hant",
]


def translate_text(target_lang, ja_text):
    translated_app_store_description = [
        {
            "name": "translated_app_store_description",
            "description": f"""
                薬の飲み忘れの不安をなくす服薬管理モバイルアプリ・Medicalarmの開発をしています。
                服薬の服用時刻にリマインド、服用履歴の管理・マナーモードでも届く通知機能を兼ね備えたアプリになっています
                このアプリでローカライズをしたいです。AppStore上に表示するアプリ紹介のためのデスクリプションを翻訳したいです
                指定された言語が使われている文化圏に相応しいMedicalarmのアプリ上で表示するための翻訳を返してください。
    """
                "parameters": {
                    "type": "object",
                    "properties": {
                    "text": {
                        "type": "string",
                        "description": "Translated release note on the App Store for {target_lang}",
                    },
                },
                "required": ["text"],
            },
        }
    ]

    response = openai.chat.completions.create(
        model="o1-mini",
        messages=[
            {
                "role": "user",
                "content": f"""
             AppStoreに表示されるリリースノートを `{target_lang}` に翻訳してください。
             `{target_lang}` はBCP 47言語コードにマッチしています。

             日本語のストアデスクリプションです
             -------
             {ja_text}
             --------
             """,
            },
        ],
        max_tokens=10000,
        n=1,
        stop=None,
        functions=translated_app_store_description,
        function_call={"name": "translated_app_store_description"},
    )

    message = response.choices[0].message
    if message.function_call:
        arguments = json.loads(message.function_call.arguments)
        return arguments["text"]


def translate_with_retry(i, lang, ja_text):
    if i > 2:
        return None
    try:
        # 英語部分と日本語部分に分割
        print(f"Start translation lang:{lang}")
        app_description = translate_text(lang, ja_text)
        print(f"Translated lang:{lang}")

        return app_description
    except Exception as e:
        print(e)
        return translate_with_retry(i + 1, lang, ja_text)

FASTLANE_METADATA_DIR = os.environ.get("FASTLANE_METADATA_DIR", "fastlane/metadata")
def read_ja():
    with open(os.path.join(FASTLANE_METADATA_DIR, "ja", "description.txt"), "r") as file:
        return file.read()


def file_is_exists(lang):
    return os.path.isfile(os.path.join(FASTLANE_METADATA_DIR, lang, "description.txt"))


ja_text = read_ja()
for lang in langs:
    print(f"Start lang: {lang}")

    if file_is_exists(lang):
        print(f'File is exists lang: {lang}')
        continue
    if lang in ["ja"]:
        print(f"Skip {lang} because it is already localized")
        continue

    translated = translate_with_retry(0, lang, ja_text)
    filepath = os.path.join(FASTLANE_METADATA_DIR, lang, "description.txt")
    if not file_is_exists(lang):
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
    print(f"Start of writing {filepath}")

    with open(filepath, "w") as file:
        file.write(translated)
        print(f"End of writing {filepath}")

"Translate and put app store app description"
