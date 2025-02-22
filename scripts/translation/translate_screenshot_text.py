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

os.chdir(os.environ.get("PROJECT_DIR"))


def create_lang_directory(lang):
    path = f"resources/{lang}"
    os.makedirs(path, exist_ok=True)
    os.makedirs(f"{path}/6.5inchi", exist_ok=True)
    return path


def translate_text(target_lang, text):
    translated_localization_strings = [
        {
            "name": "translated_localization_strings",
            # あなたはApp Store上の「ReplAI(リプるAI)」というチャットアシスタントをしてくれるモバイルアプリを開発しています。OpenAIのAPIを通じてチャットの返信を考えてくれるアプリです。
            # 今回翻訳してほしいアプリの概要は以下のとおりです
            #
            # 概要:
            # ReplAI(リプるAI)というチャットアシスタントをしてくれるモバイルアプリを開発しています。OpenAIのAPIを通じてチャットの返信を考えてくれるアプリです。
            # このアプリがあれば友人や気になるあの人との会話の返信に困らない。マッチングアプリでも大活躍間違い無し。ReplAI(リプるAI)はいつも返信に迷ってしまう口下手・チャット下手な人のためのアプリです
            # このアプリでローカライズをしたいです。
            # 指定された言語が使われている文化圏に相応しいReplAIのアプリ上で表示するための翻訳を返してください。
            # この文言はAppStore上に出るスクリーンショットで短いキャッチコピーとして使われます
            "description": f"""
            You are developing a mobile app called "ReplAI," a chat assistant app that helps users craft replies. The app leverages OpenAI's API to generate chat responses. 

            Overview: 
            ReplAI is a mobile chat assistant app that helps users respond to messages. With this app, you'll never struggle with how to reply to a friend or someone you're interested in. It's also perfect for conversations on dating apps. ReplAI is designed for people who often find themselves at a loss for words or who feel less confident in chatting. 

            Please localize this text appropriately for the cultural context of the specified language. The translations will be used as short, catchy captions on screenshots displayed in the App Store.
            """,
            "parameters": {
                "type": "object",
                "properties": {
                    "text": {
                        "type": "string",
                        "description": "Translated App Store screenshot slogan for {target_lang}",
                    },
                },
                "required": ["text"],
            },
        }
    ]

    response = openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "user",
                "content": f"""
             Please translate {text} to {target_lang}.
             {target_lang} matches the BCP 47 language code.
             """,
            },
        ],
        max_tokens=100,
        n=1,
        stop=None,
        functions=translated_localization_strings,
        function_call={"name": "translated_localization_strings"},
    )

    message = response.choices[0].message
    if message.function_call:
        arguments = json.loads(message.function_call.arguments)
        return arguments


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
