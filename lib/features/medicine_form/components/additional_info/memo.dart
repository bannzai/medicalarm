import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicalarm/components/alert/image_picker.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/image/image.dart';
import 'package:medicalarm/utils/storage/firebase_cloud_storage.dart';

class MedicineMemoRow extends StatelessWidget {
  final ValueNotifier<String> memo;
  final ValueNotifier<String> memoImageURL;
  final FocusNode focusNode;
  const MedicineMemoRow({
    super.key,
    required this.memo,
    required this.memoImageURL,
    required this.focusNode,
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
              focusNode: focusNode,
              maxLines: 5,
              maxLength: 300,
              initialValue: memo.value,
              onChanged: (value) {
                memo.value = value;
              },
              decoration: InputDecoration(
                hintText: L.memo,
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
    final memoImageURL = useState(this.memoImageURL.value);
    memoImageURL.addListener(() {
      this.memoImageURL.value = memoImageURL.value;
    });

    return Loading(
      isLoading: isLoading.value,
      child: GestureDetector(
        onTap: () async {
          analytics.logEvent(name: 'medicine_form_memo_image_tapped');
          try {
            if (isLoading.value) {
              return;
            }
            final XFile? photo = await showImagePickerDialog(context);

            if (photo != null) {
              final compressedFile = await convertToJPEGImage(File(photo.path));
              final url = await uploadImage(medicinesRef(userID: userID), compressedFile);
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
