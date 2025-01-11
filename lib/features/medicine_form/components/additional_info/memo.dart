import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicalarm/components/alert/image_picker.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/provider/app_user.dart';
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
    final userID = ref.watch(appUserIDProvider);

    return Loading(
      isLoading: isLoading.value,
      child: GestureDetector(
        onTap: () async {
          try {
            if (isLoading.value) {
              return;
            }
            final XFile? photo = await showImagePickerDialog(context);

            if (photo != null) {
              final url = await uploadImage(medicinesRef(userID: userID), File(photo.path));
              memoImageURL.value = url;
            }
          } catch (e) {
            if (context.mounted) {
              showErrorAlert(context, e.toString());
            }
          } finally {
            isLoading.value = false;
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
      ),
    );
  }
}
