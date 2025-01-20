import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextEditSheet extends HookWidget {
  final String text;
  final FormFieldValidator<String>? validator;

  const TextEditSheet({super.key, required this.text, this.validator});

  @override
  Widget build(BuildContext context) {
    final text = useState(this.text);
    return DraggableScrollableSheet(
      maxChildSize: 0.7,
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 24, left: 16, right: 16),
              child: TextFormField(
                initialValue: text.value,
                validator: validator,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  text.value = value;
                },
                onFieldSubmitted: (value) {
                  Navigator.of(context).pop(value);
                },
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}

Future<String?> showTextEditSheet(BuildContext context, {required String text, FormFieldValidator<String>? validator}) async {
  return await showModalBottomSheet<String?>(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) => TextEditSheet(text: text, validator: validator),
  );
}
