import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/utils/image/image.dart';
import 'package:medicalarm/utils/storage/firebase_cloud_storage.dart';

class MedicineMemoRow extends StatelessWidget {
  final ValueNotifier<String> memo;
  final ValueNotifier<String> memoImageURL;
  const MedicineMemoRow({
    super.key,
    required this.memo,
    required this.memoImageURL,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          ImagePickerButton(memoImageURL: memoImageURL),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: memo.value,
              onChanged: (value) {
                memo.value = value;
              },
              decoration: const InputDecoration(
                hintText: 'メモ',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePickerButton extends HookConsumerWidget {
  const ImagePickerButton({
    super.key,
    required this.memoImageURL,
  });

  final ValueNotifier<String> memoImageURL;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    return GestureDetector(
      onTap: () async {
        final imagePicker = ImagePicker();
        final XFile? photo = await imagePicker.pickImage(source: ImageSource.gallery);

        if (photo != null) {
          final croppedFile = await ImageCropper().cropImage(
            sourcePath: photo.path,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                aspectRatioPresets: [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  _CropAspectRatioPresetCustom(),
                ],
              ),
              IOSUiSettings(
                title: 'Cropper',
                aspectRatioPresets: [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  _CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
                ],
              ),
            ],
          );
          if (croppedFile != null) {
            try {
              final file = File(croppedFile.path);
              final url = await uploadImage(medicinesRef(userID: userID), file);
              memoImageURL.value = url;
            } catch (e) {
              if (context.mounted) {
                showErrorAlert(context, e.toString());
              }
            }
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 50,
          height: 50,
          color: Colors.grey,
          child: memoImageURL.value.isNotEmpty ? Image.network(memoImageURL.value) : const Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}

class _CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (1, 1);

  @override
  String get name => '1x1 (customized)';
}
