import os
import json
from openai import OpenAI
import subprocess
import datetime

# 設定値
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")
LANGS = [
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
INPUT_TEXT = {
    # 実際は違う。name,subtitle
    "name": "Medicalarm - 絶対飲み忘れない服薬管理アプリ",
    "subtitle": "飲み忘れの不安を解決します",
    "keywords": "ピル,薬,薬飲み忘れ,服薬,服薬管理,通知,アラーム,人気,ヘルスケア",
}
INPUT_TEXT_NOTE = {
    "name": "Medicalarm - を最初に入れてください。これを含めて30文字以内で翻訳してください。",
    "subtitle": "短くキャッチーに翻訳してください",
    "keywords": "`,`区切りでキーワードを羅列してください",
}
CHAR_LIMITS = {
    "name": 30,
    "subtitle": 30,
    "keywords": 100,
}
# 出力先ディレクトリを環境変数から取得
FASTLANE_METADATA_DIR = os.environ.get("FASTLANE_METADATA_DIR", "fastlane/metadata")
RETRY_LIMIT = 10

# OpenAIクライアントの初期化
client = OpenAI(api_key=OPENAI_API_KEY)

os.chdir(os.environ.get("PROJECT_DIR"))


# fastlane deliverのディレクトリ構造を作成する関数
def create_deliver_structure():
    os.makedirs(FASTLANE_METADATA_DIR, exist_ok=True)
    for lang in LANGS:
        os.makedirs(os.path.join(FASTLANE_METADATA_DIR, lang), exist_ok=True)


# 薬の飲み忘れの不安をなくす服薬管理モバイルアプリ・Medicalarmの開発をしています。
# 服薬の服用時刻にリマインド、服用履歴の管理、生理管理を行えるアプリになっています。
# このアプリでローカライズをしたいです。AppStoreで設定するASOのためのメタデータを翻訳したいです。
# {content_type}の翻訳をしてください。文字数は{char_limit}文字以内です。{lang}に翻訳してください。
# {content_type}の翻訳の注意点です: {content_type_note}
# 指定された言語が使われている文化圏に相応しいPilllのアプリ上で表示するための翻訳を返してください。
def translate_text(ja_text, lang, content_type, char_limit, content_type_note):
    translated_app_store_metadata = [
        {
            "name": "translated_app_store_metadata",
            "description": f"""
                薬の飲み忘れの不安をなくす服薬管理モバイルアプリ・Medicalarmの開発をしています。
                服薬の服用時刻にリマインド、服用履歴の管理、生理管理を行えるアプリになっています。
                このアプリでローカライズをしたいです。AppStoreで設定するASOのためのメタデータを翻訳したいです。
                {content_type}の翻訳をしてください。文字数は{char_limit}文字以内です。{lang}に翻訳してください。
                {content_type}の翻訳の注意点です: {content_type_note}
                指定された言語が使われている文化圏に相応しいPilllのアプリ上で表示するための翻訳を返してください。
            """,
            "parameters": {
                "type": "object",
                "properties": {
                    "text": {
                        "type": "string",
                        "description": "{lang}用のApp Store翻訳メタデータ",
                    },
                },
                "required": ["text"],
            },
        }
    ]
    previous_translation = None
    for _ in range(RETRY_LIMIT):
        try:
            prompt_content = f"""
                {lang} に翻訳してください。`{lang}` は BCP 47 の言語コードです

                日本語の文章です
                -------
                {ja_text}
                --------
            """
            if previous_translation:
                prompt_content += f"""
                前回の翻訳結果 {previous_translation}\n
                この翻訳結果をもっと短くしたいので単語を削ってください
                """

            response = client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[
                    {
                        "role": "user",
                        "content": prompt_content,
                    },
                ],
                max_tokens=10000,
                n=1,
                stop=None,
                functions=translated_app_store_metadata,
                function_call={"name": "translated_app_store_metadata"},
            )

            message = response.choices[0].message
            if message.function_call:
                arguments = json.loads(message.function_call.arguments)
                text = arguments["text"]
                print(f"Translated text: {text}")
                if len(text) <= char_limit:
                    return text
                else:
                    print(
                        f"Translation for {lang} {content_type} exceeds character limit. Retrying..."
                    )
                    previous_translation = text

        except Exception as e:
            print(f"Error during translation for {lang} {content_type}: {e}")
            return None
    return None


# ファイルに書き込む関数
def write_to_file(filepath, content):
    with open(filepath, "w") as f:
        f.write(content)


# Gitにコミットする関数
def commit_changes(message):
    subprocess.run(["git", "add", "."], check=True)
    subprocess.run(["git", "commit", "-m", message], check=True)


def main():
    create_deliver_structure()
    start_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"Translation started at: {start_date}")

    # 生成前に存在していないファイルの一覧を出力
    non_existent_files = [] 
    for lang in LANGS:
        lang_dir = os.path.join(FASTLANE_METADATA_DIR, lang)
        for content_type, text in INPUT_TEXT.items():
            filepath = os.path.join(lang_dir, f"{content_type}.txt")
            if not os.path.exists(filepath):
                non_existent_files.append(filepath)
    print("Files that did not exist before generation:")
    for file in non_existent_files:
        print(f"  {file}")

    for lang in LANGS:
        print(f"Translating for {lang}...")
        lang_dir = os.path.join(FASTLANE_METADATA_DIR, lang)

        for content_type, text in INPUT_TEXT.items():
            filepath = os.path.join(lang_dir, f"{content_type}.txt")
            if os.path.exists(filepath):
                print(f"  {content_type}.txt already exists for {lang}, skipping...")
                continue

            char_limit = CHAR_LIMITS[content_type]
            content_type_note = INPUT_TEXT_NOTE[content_type]
            translated_text = translate_text(
                text, lang, content_type, char_limit, content_type_note
            )

            if translated_text:
                write_to_file(filepath, translated_text)
                print(f"  {content_type}.txt created for {lang}")
            else:
                print(f"  Failed to translate {content_type} for {lang}")

    end_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"Translation ended at: {end_date}")
    commit_message = f"feat: add translations from {start_date} to {end_date}"
    commit_changes(commit_message)


if __name__ == "__main__":
    main()
