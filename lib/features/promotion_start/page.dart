import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/premium/premium_features.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/config/remote_config.dart';
import 'package:medicalarm/provider/remote_config_parameter.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:url_launcher/url_launcher.dart';

// アプリを開始時に、ストアレビューで星5つをつけたらアプリの有料機能を1週間試用できる機能をプレゼントするページ
// 実際に星5をつけたかは検知できないが、PromotionStartButton を押した時点でその気があると判断することにする。アプリに戻ってきたらscenePhaseの検知により startPromotion 関数を実行して、試用期間をプレゼントする
class PromotionStartPage extends HookConsumerWidget {
  final VoidCallback onStartPromotion;
  final VoidCallback onCancel;

  const PromotionStartPage({
    super.key,
    required this.onStartPromotion,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // アニメーションコントローラー
    final giftAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);

    final starAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);

    // 状態管理
    final canStartPromotion = useState(false);
    final showAppStoreAlert = useState(false);
    final error = useState<Exception?>(null);

    final primaryColor = Theme.of(context).colorScheme.primary;

    // ライフサイクル検知のためのエフェクト
    useEffect(() {
      final observer = _AppLifecycleObserver(
        onResumed: () {
          canStartPromotion.value = true;
        },
      );

      WidgetsBinding.instance.addObserver(observer);

      return () {
        WidgetsBinding.instance.removeObserver(observer);
      };
    }, []);

    // リモートコンフィグから値を取得
    int promotionDayCount = 7; // デフォルト値
    try {
      promotionDayCount = remoteConfig.getIntOrDefault('promotionDayCount', 7);
    } catch (_) {
      // エラー時はデフォルト値を使用
    }

    // プロモーション開始処理
    Future<void> startPromotion() async {
      try {
        // 実際のプロモーション適用ロジック
        await Future.delayed(const Duration(milliseconds: 500)); // ダミー処理
        onStartPromotion();
      } catch (e) {
        error.value = e as Exception;
      }
    }

    // App Store を開く
    Future<void> openAppStore() async {
      final url = Uri.parse('https://apps.apple.com/app/id6740401642?mt=8&action=write-review');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }

    // エラーアラートを構築
    Widget buildErrorAlert() {
      return AlertDialog(
        title: const Text('エラー'),
        content: Text(error.value.toString()),
        actions: [
          TextButton(
            onPressed: () {
              analytics.logEvent(name: 'promo_start_error_ok_pressed');
              error.value = null;
            },
            child: const Text('OK'),
          ),
        ],
      );
    }

    // App Store アラートを構築
    Widget buildAppStoreAlert() {
      return AlertDialog(
        title: Text(L.openAppStore),
        content: Text(L.confirmOpenAppStore),
        actions: [
          TextButton(
            onPressed: () {
              analytics.logEvent(name: 'promo_start_appstore_cancel');
              showAppStoreAlert.value = false;
            },
            child: Text(L.cancel),
          ),
          TextButton(
            onPressed: () {
              analytics.logEvent(name: 'promo_start_appstore_open');
              showAppStoreAlert.value = false;
              openAppStore();
            },
            child: Text(L.ok),
          ),
        ],
      );
    }

    return Material(
      child: Stack(
        children: [
          Container(
            color: primaryColor.withValues(alpha: 0.1),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        // 全体の横幅を制限
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),
                          // ギフトアイコン
                          Center(
                            child: AnimatedBuilder(
                              animation: giftAnimationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + 0.1 * giftAnimationController.value,
                                  child: Icon(
                                    Icons.card_giftcard,
                                    size: 70,
                                    color: primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Text(
                              L.specialGift,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              L.freePremiumTrialDays(promotionDayCount),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 25),
                          // 星アイコンとレビューの説明
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 星5つのアイコン行を追加
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 4,
                                  children: List.generate(5, (index) {
                                    return AnimatedBuilder(
                                      animation: starAnimationController,
                                      builder: (context, child) {
                                        // インデックスが高いほど大きくアニメーションさせて注目を集める
                                        final scale = 1.0 + (0.1 + index * 0.02) * starAnimationController.value;
                                        return Transform.scale(
                                          scale: scale,
                                          child: Icon(
                                            Icons.star,
                                            size: 30,
                                            color: Colors.amber,
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                                const SizedBox(height: 20),
                                AnimatedBuilder(
                                  animation: starAnimationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 1.0 + 0.15 * starAnimationController.value,
                                      child: Icon(
                                        Icons.star,
                                        size: 50,
                                        color: Colors.amber,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    L.welcomeToMedicalarm,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    L.writeReviewFor5StarPromotion(promotionDayCount),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    L.rating5StarsEncouragement,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(
                              L.noAutoCharge,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  L.premiumFeaturesList,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const PremiumFeatures(),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  // 下部のボタン部分
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PromotionStartButton(
                          canStartPromotion: canStartPromotion.value,
                          onShowAppStoreAlert: () {
                            showAppStoreAlert.value = true;
                          },
                          onStartPromotion: startPromotion,
                        ),
                        const SizedBox(height: 10),
                        PromotionStartCancelButton(onCancel: onCancel),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // エラーアラート
          if (error.value != null) buildErrorAlert(),

          // App Storeアラート
          if (showAppStoreAlert.value) buildAppStoreAlert(),
        ],
      ),
    );
  }
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResumed;

  _AppLifecycleObserver({required this.onResumed});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }

  @override
  bool operator ==(Object other) {
    return other is _AppLifecycleObserver;
  }

  @override
  int get hashCode => 0; // 単一のインスタンスとして扱う
}

class PromotionStartButton extends StatelessWidget {
  final bool canStartPromotion;
  final VoidCallback onShowAppStoreAlert;
  final VoidCallback onStartPromotion;

  const PromotionStartButton({
    super.key,
    required this.canStartPromotion,
    required this.onShowAppStoreAlert,
    required this.onStartPromotion,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ElevatedButton(
      onPressed: () {
        analytics.logEvent(name: 'pressed_promotion_start');
        if (!canStartPromotion) {
          analytics.logEvent(name: 'promotion_start_show_app_store_dialog');
          onShowAppStoreAlert();
        } else {
          analytics.logEvent(name: 'promotion_start_run_start_promotion');
          onStartPromotion();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              canStartPromotion ? Icons.card_giftcard : Icons.rate_review,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              canStartPromotion ? L.receiveReward : L.write5StarReview,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromotionStartCancelButton extends StatelessWidget {
  final VoidCallback onCancel;

  const PromotionStartCancelButton({
    super.key,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        analytics.logEvent(name: 'pressed_promotion_start_cancel');
        onCancel();
      },
      child: Text(
        L.notNow,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
