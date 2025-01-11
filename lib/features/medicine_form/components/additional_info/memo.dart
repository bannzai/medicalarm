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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 50,
              color: Colors.grey,
              child: memoImageURL.value.isNotEmpty ? Image.network(memoImageURL.value) : const Icon(Icons.add_a_photo),
            ),
          ),
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
