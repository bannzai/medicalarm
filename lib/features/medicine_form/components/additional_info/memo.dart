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
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: memoImageURL.value.isNotEmpty ? Image.network(memoImageURL.value) : const Icon(Icons.add_a_photo),
          ),
          TextFormField(
            initialValue: memo.value,
            onChanged: (value) {
              memo.value = value;
            },
            decoration: const InputDecoration(
              hintText: 'メモ',
            ),
          ),
        ],
      ),
    );
  }
}
