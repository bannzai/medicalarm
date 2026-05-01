import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/feature_request.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class FeatureRequestFormPage extends HookConsumerWidget {
  const FeatureRequestFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = useState('');
    final emailAddress = useState('');
    final isSubmitting = useState(false);
    final featureRequestSubmit = ref.watch(featureRequestSubmitProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final primaryColor = Theme.of(context).colorScheme.primary;

    final canSubmit = content.value.trim().isNotEmpty && !isSubmitting.value;

    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: FormTheme(
            child: Scaffold(
              appBar: AppBar(
                title: Text(L.featureRequestTitle, style: TextStyle(color: primaryColor)),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SafeArea(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(L.featureRequestContentLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          minLines: 6,
                          maxLines: 12,
                          maxLength: 5000,
                          decoration: InputDecoration(hintText: L.featureRequestContentHint),
                          onChanged: (v) => content.value = v,
                        ),
                        const SizedBox(height: 4),
                        Text(L.featureRequestContentFooter, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 24),
                        Text(L.featureRequestEmailLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(hintText: 'name@example.com'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v) ? null : L.featureRequestEmailInvalid;
                          },
                          onChanged: (v) => emailAddress.value = v,
                        ),
                        const SizedBox(height: 4),
                        Text(L.featureRequestEmailFooter, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: canSubmit
                                ? () async {
                                    if (!(formKey.currentState?.validate() ?? false)) return;
                                    isSubmitting.value = true;
                                    try {
                                      analytics.logEvent(name: 'feature_request_submitted', parameters: {
                                        'has_email': emailAddress.value.isNotEmpty ? 'true' : 'false',
                                        'content_length': content.value.length,
                                      });
                                      await featureRequestSubmit.call(
                                        content: content.value,
                                        emailAddress: emailAddress.value.isEmpty ? null : emailAddress.value,
                                      );
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(L.featureRequestThanks)),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) showErrorAlert(context, e.toString());
                                    } finally {
                                      isSubmitting.value = false;
                                    }
                                  }
                                : null,
                            child: Loading(isLoading: isSubmitting.value, child: Text(L.send)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 機能要望フォームを BottomSheet で開く。起動時ダイアログ・設定画面の双方から呼ぶ。
void showFeatureRequestForm(BuildContext context) {
  analytics.logEvent(name: 'feature_request_form_opened');
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const FeatureRequestFormPage(),
  );
}
