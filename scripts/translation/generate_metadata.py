import json
import os
import shutil


os.chdir(os.environ.get("PROJECT_DIR"))


def file_is_exists(path):
    return os.path.isfile(f"{path}")


file_list = os.listdir("artifacts/screenshots")
screenshots = [file for file in file_list if file.lower().endswith(".png")]

# ここを変更する場合はui_test_env.sh, generate_screenshot.shも編集する
GENERATE_SCREENSHOT_TEST_FUNCTION_1 = "screenshot_medications"
GENERATE_SCREENSHOT_TEST_FUNCTION_2 = "screenshot_medication_histories"
GENERATE_SCREENSHOT_TEST_FUNCTION_3 = "screenshot_medicine_schedule_notification_form"


def map_directory_name(arg):
    if arg == "ar":
        return "ar-SA"
    elif arg == "de":
        return "de-DE"
    elif arg in ("en", "en-IN"):
        return "en-US"
    elif arg in ("es", "es-419"):
        return "es-ES"
    elif arg == "nb":
        return "no"
    elif arg == "nl":
        return "nl-NL"
    elif arg == "zh-HK":
        return "zh-Hant"
    else:
        return arg


for screenshot in screenshots:
    print(f"Start {screenshot}")
    screenshot_file_name = f"artifacts/screenshots/{screenshot}"

    # e.g) screenshot_chat_partners--ja.png
    parts = screenshot.split("--")
    test_function_name = parts[0]
    lang = parts[1].replace(".png", "")
    lang = map_directory_name(lang)

    print(f"test_function_name: {test_function_name}, lang: {lang}")

    screenshot_index = -1
    if test_function_name == GENERATE_SCREENSHOT_TEST_FUNCTION_1:
        screenshot_index = 0
    elif test_function_name == GENERATE_SCREENSHOT_TEST_FUNCTION_2:
        screenshot_index = 1
    elif test_function_name == GENERATE_SCREENSHOT_TEST_FUNCTION_3:
        screenshot_index = 2
    else:
        print(f"Invalid test function name: {test_function_name}")
        continue

    merged_image_return_code = os.system(
        f'./scripts/generate_merged_image.sh "{screenshot_file_name}" "{lang}" "{screenshot_index}"'
    )
    if merged_image_return_code == 0:
        print("generate_merged_imageスクリプトは正常に実行されました。")
    else:
        print("generate_merged_imageスクリプトはエラーで終了しました。")

    for inchi in [65]:
        artifact_dir = f"artifacts/merged_image/{lang}"
        destination_directory = f"fastlane/screenshots/{lang}"
        destination_file_name = (
            f"{screenshot_index}_APP_IPHONE_{inchi}_{screenshot_index}.png"
        )
        destination_file = os.path.join(destination_directory, destination_file_name)
        source_file_name = f"{artifact_dir}/{destination_file_name}"

        if file_is_exists(destination_file):
            print(f"Skip {destination_file} because it is already exist")
            continue

        os.makedirs(destination_directory, exist_ok=True)
        if os.path.exists(destination_file):
            try:
                os.remove(destination_file)
                print(f"既存のファイル {destination_file} を削除しました。")
            except Exception as e:
                print(f"既存のファイルの削除中にエラーが発生しました: {str(e)}")

        try:
            shutil.move(source_file_name, destination_file)
            print("ファイルの移動とリネームが成功しました。")
        except FileNotFoundError:
            print(
                f"ファイルが見つかりません。 source_file_name: {source_file_name}, destination_file: {destination_file}"
            )
        except Exception as e:
            print(f"エラーが発生しました: {str(e)}")

"Finish generate_metadata.py"
