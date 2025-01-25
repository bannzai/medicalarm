import 'package:flutter/material.dart';

class PremiumCompleteDialog extends StatelessWidget {
  final VoidCallback onClose;

  const PremiumCompleteDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "ReplAIプレミアム登録完了",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            "ご登録ありがとうございます。\nすべての機能が使えるようになりました！",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                onClose();
              },
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}
