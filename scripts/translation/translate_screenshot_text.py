import json
import os
from openai import OpenAI

client = OpenAI()
client.organization = os.environ.get("OPENAI_ORGANIZATION")
client.api_key = os.environ.get("OPENAI_API_KEY")

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
    # "ja",
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

textJSONs = [
    {
        "index": 0,
        "title": "Manage Multiple Meds",
        "subtitle": "Assign Medication Takers",
    },
    {
        "index": 1,
        "title": "Track Your History",
        "subtitle": "No More Missed Doses",
    },
    {
        "index": 2,
        "title": "Never Miss Alerts",
        "subtitle": "Repeat Notifications Even on Silent Mode",
    },
]

os.chdir(os.environ.get("TRANSLATION_SCRIPT_DIR"))


def create_lang_directory(lang):
    path = f"resources/{lang}"
    os.makedirs(path, exist_ok=True)
    return path


def translate_text(target_lang, text):
    schema = {
        "type": "object",
        "properties": {
            "text": {
                "type": "string",
                "description": f"Translated App Store screenshot slogan for {target_lang}",
            }
        },
        "required": ["text"],
        "additionalProperties": False,
    }

    try:
        response = client.responses.create(
            model="gpt-4o-2024-08-06",
            input=[
                {
                    "role": "system",
                    "content": f"""
                    We are developing Medicalarm, a medication management mobile app that eliminates the anxiety of forgetting to take your meds. The app features medication time reminders, medication history tracking, and notifications that work even in silent mode.
                    We aim to localize this app.
                    Please provide translations for display on the Medicalarm app that are appropriate for the cultural context of the specified language. These phrases will be used as short, catchy copy on AppStore screenshots.
                    Please translation to `{target_lang}`. `{target_lang}` matches the BCP 47 language code.
                    """,
                },
                {
                    "role": "user",
                    "content": f"Please translate {text} to {target_lang}. {target_lang} matches the BCP 47 language code.",
                },
            ],
            text={
                "format": {
                    "type": "json_schema",
                    "name": "translated_localization_strings",
                    "schema": schema,
                    "strict": True,
                }
            },
        )

        if response.status == "completed":
            result = json.loads(response.output_text)
            return result

    except Exception as e:
        print(f"Error during translation: {e}")
        return None


def translate_with_retry(i, lang, title, subtitle, index):
    if i > 0:
        return None
    try:
        # 英語部分と日本語部分に分割
        print(
            f"Start translation lang:{lang} title:{title} subtitle:{subtitle} index:{index}"
        )
        translatedTitle = translate_text(lang, title).get("text")
        print(f"Translated lang:{lang} title:{title} to {translatedTitle}")

        translatedSubtitle = translate_text(lang, subtitle).get("text")
        print(f"Translated lang:{lang} subtitle:{subtitle} to {translatedSubtitle}")

        return {
            "title": translatedTitle,
            "subtitle": translatedSubtitle,
            "index": index,
        }
    except Exception as e:
        print(e)
        return translate_with_retry(i + 1, lang, title, subtitle, index)


def load():
    with open("resources/text_to_image.json", "r") as file:
        return json.load(file)


def file_is_exists():
    return os.path.isfile(f"resources/text_to_image.json")


jsonObject = {}
if file_is_exists():
    jsonObject = load()

for lang in langs:
    print(f"Start lang: {lang}")
    # print(f'Warn 現在はtitle,subtitleが空で作成される')
    if lang in jsonObject:
        # すでに該当するlangがtext_to_image.jsonにある場合はスキップ
        # 作り直したかったらlangのkeyごと削除する
        continue

    arr = []
    # 空のjsonを作りたい場合は、このfor文をコメントアウトを解除
    # for i in range(0, 10):
    #     arr.append({"title": "", "subtitle": "", "index": i})

    # 空のjsonを作りたい場合は、このfor文をコメントアウト
    for textJSON in textJSONs:
        title = textJSON["title"]
        subtitle = textJSON["subtitle"]
        index = textJSON["index"]
        translated = translate_with_retry(0, lang, title, subtitle, index)
        arr.append(translated)
    jsonObject[lang] = arr

if not file_is_exists():
    os.makedirs("resources", exist_ok=True)
with open("resources/text_to_image.json", "w") as file:
    file.write(json.dumps(jsonObject, indent=4, ensure_ascii=False))
"Translate and generate app store screenshot title and subtitle"
