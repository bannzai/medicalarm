import json
import os
import openai

# Set your OpenAI API key
openai.organization = os.environ.get("OPENAI_ORGANIZATION")
openai.api_key = os.environ.get("OPENAI_API_KEY")

# Directory containing .arb files
arb_directory = os.environ.get("L10N_DIR")

# Target languages to translate to
# ref: https://api.flutter.dev/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html
langs = [
    "af",  # Afrikaans
    "am",  # Amharic
    "ar",  # Arabic
    "as",  # Assamese
    "az",  # Azerbaijani
    "be",  # Belarusian
    "bg",  # Bulgarian
    "bn",  # Bengali Bangla
    "bs",  # Bosnian
    "ca",  # Catalan Valencian
    "cs",  # Czech
    "cy",  # Welsh
    "da",  # Danish
    "de",  # German (plus one country variation)
    "el",  # Modern Greek
    "en",  # English (plus 8 country variations)
    "es",  # Spanish Castilian (plus 20 country variations)
    "et",  # Estonian
    "eu",  # Basque
    "fa",  # Persian
    "fi",  # Finnish
    "fil",  # Filipino Pilipino
    "fr",  # French (plus one country variation)
    "gl",  # Galician
    "gsw",  # Swiss German Alemannic Alsatian
    "gu",  # Gujarati
    "he",  # Hebrew
    "hi",  # Hindi
    "hr",  # Croatian
    "hu",  # Hungarian
    "hy",  # Armenian
    "id",  # Indonesian
    "is",  # Icelandic
    "it",  # Italian
    "ja",  # Japanese
    "ka",  # Georgian
    "kk",  # Kazakh
    "km",  # Khmer Central Khmer
    "kn",  # Kannada
    "ko",  # Korean
    "ky",  # Kirghiz Kyrgyz
    "lo",  # Lao
    "lt",  # Lithuanian
    "lv",  # Latvian
    "mk",  # Macedonian
    "ml",  # Malayalam
    "mn",  # Mongolian
    "mr",  # Marathi
    "ms",  # Malay
    "my",  # Burmese
    "nb",  # Norwegian Bokmål
    "ne",  # Nepali
    "nl",  # Dutch Flemish
    "no",  # Norwegian
    "or",  # Oriya
    "pa",  # Panjabi Punjabi
    "pl",  # Polish
    "ps",  # Pushto Pashto
    "pt",  # Portuguese (plus one country variation)
    "ro",  # Romanian Moldavian Moldovan
    "ru",  # Russian
    "si",  # Sinhala Sinhalese
    "sk",  # Slovak
    "sl",  # Slovenian
    "sq",  # Albanian
    "sr",  # Serbian (plus 2 scripts)
    "sv",  # Swedish
    "sw",  # Swahili
    "ta",  # Tamil
    "te",  # Telugu
    "th",  # Thai
    "tl",  # Tagalog
    "tr",  # Turkish
    "uk",  # Ukrainian
    "ur",  # Urdu
    "uz",  # Uzbek
    "vi",  # Vietnamese
    "zh",  # Chinese (plus 2 country variations and 2 scripts)
    "zu",  # Zulu
]

# Keys to skip during translation
skip_keys = ["", " - ", " / ", "- ", ",", ":"]


def translate_text(ja_value: str, comment: str, target_lang: str) -> str:
    """Translate text using OpenAI API."""
    prompt = (
        f"iOSアプリの翻訳をしてください。\n"
        "Flutterで作られています。フォーマットは l10n/*.arb の形式に従います {VAL} のようなプレースホルダーの正しいフォーマットを保ってください。\n"
        f"言語は {target_lang} に翻訳してください。{target_lang} はISO 639-1言語コードです。\n"
        f"アプリの説明です。飲み忘れの不安をなくす服薬管理モバイルアプリ・Medicalarmの開発をしています。\n"
        f"服薬の服用時刻にリマインド、服用履歴の管理・マナーモードでも届く通知機能を兼ね備えたアプリになっています。\n"
        f"翻訳のインプットは日本語の文章、補助情報を渡します。\n"
        f"日本語: この文章はすでにアプリ内で使われている翻訳済みの日本語です\n"
        f"補助情報: 日本語で渡します。こちらはアプリ内でどのように使われているのか、どのようなユースケースで使われているのかを記述したものです。翻訳の参考にしてください\n"
        f"インプット:\n"
        f"日本語: {ja_value}\n"
        f"補助情報: {comment}"
    )

    try:
        response = openai.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "user", "content": f"あなたは優秀なモバイルアプリの翻訳者です。{prompt}"},
            ],
            functions=[
                {
                    "name": "translate",
                    "description": "Provide a translation result.",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "translated_text": {
                                "type": "string",
                                "description": "The translation of the input text in the target language.",
                            }
                        },
                        "required": ["translated_text"],
                    },
                }
            ],
            function_call={"name": "translate"},
        )

        arguments = json.loads(response.choices[0].message.function_call.arguments)
        return arguments["translated_text"]
    except Exception as e:
        print(f"Error translating text: {e}")
        return ""


def load_arb_file(file_path: str) -> dict:
    """Load ARB file as a dictionary."""
    with open(file_path, "r", encoding="utf-8") as file:
        return json.load(file)


def save_arb_file(file_path: str, data: dict):
    """Save dictionary data to ARB file."""
    with open(file_path, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, ensure_ascii=False)


def main():
    # Load the base ARB file (e.g., app_en.arb)
    base_arb_path = os.path.join(arb_directory, "app_ja.arb")
    base_arb = load_arb_file(base_arb_path)

    for target_lang in langs:
        target_arb_path = os.path.join(arb_directory, f"app_{target_lang}.arb")

        # Load or initialize the target ARB file
        if os.path.exists(target_arb_path):
            target_arb = load_arb_file(target_arb_path)
        else:
            target_arb = {
                "@@locale": target_lang,
            }

        # Translate keys missing in the target ARB
        for key, value in base_arb.items():
            if key in skip_keys or key.startswith("@"):  # Skip metadata keys
                continue

            if key not in target_arb:
                print(f"Translating key: {key} to {target_lang}")
                comment = base_arb.get(f"@{key}", {}).get("description", "")
                translation = translate_text(value, comment, target_lang)

                if translation:
                    target_arb[key] = translation
                    target_arb[f"@{key}"] = base_arb.get(
                        f"@{key}",
                        {
                            "description": comment,
                        },
                    )

        # Save the updated ARB file
        save_arb_file(target_arb_path, target_arb)
        print(f"Updated {target_lang} ARB file: {target_arb_path}")


if __name__ == "__main__":
    main()
