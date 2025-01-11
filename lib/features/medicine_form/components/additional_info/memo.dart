import 'package:flutter/material.dart';

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

class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton({
    super.key,
    required this.memoImageURL,
  });

  final ValueNotifier<String> memoImageURL;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
