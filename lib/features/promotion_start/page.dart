import 'package:flutter/material.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/config/remote_config.dart';
import 'package:medicalarm/provider/remote_config_parameter.dart';
import 'package:url_launcher/url_launcher.dart';

// アプリを開始時に、ストアレビューで星5つをつけたらアプリの有料機能を1週間試用できる機能をプレゼントするページ
// 実際に星5をつけたかは検知できないが、PromotionStartButton を押した時点でその気があると判断することにする。アプリに戻ってきたらscenePhaseの検知により startPromotion 関数を実行して、試用期間をプレゼントする
class PromotionStartPage extends StatefulWidget {
  final VoidCallback onStartPromotion;
  final VoidCallback onCancel;

  const PromotionStartPage({
    Key? key,
    required this.onStartPromotion,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<PromotionStartPage> createState() => _PromotionStartPageState();
}

class _PromotionStartPageState extends State<PromotionStartPage> with SingleTickerProviderStateMixin {
  late AnimationController _giftAnimationController;
  late AnimationController _starAnimationController;
  bool canStartPromotion = false;
  bool showAppStoreAlert = false;
  Exception? error;

  @override
  void initState() {
    super.initState();
    _giftAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);

    _starAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);

    // アプリがバックグラウンドから戻ってきたことを検知
    WidgetsBinding.instance.addObserver(
      _AppLifecycleObserver(
        onResumed: () {
          setState(() {
            canStartPromotion = true;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _giftAnimationController.dispose();
    _starAnimationController.dispose();
    WidgetsBinding.instance.removeObserver(
      _AppLifecycleObserver(onResumed: () {}),
    );
    super.dispose();
  }

  int get promotionDayCount {
    // リモートコンフィグから値を取得（デフォルトは7日）
    try {
      return remoteConfig.getIntOrDefault('promotionDayCount', 7);
    } catch (_) {
      return 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            color: Colors.blue.withOpacity(0.1),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // ギフトアイコン
                  AnimatedBuilder(
                    animation: _giftAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + 0.1 * _giftAnimationController.value,
                        child: Icon(
                          Icons.card_giftcard,
                          size: 70,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "🎉 Special Gift 🎉",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "試用期間が$promotionDayCount日間無料でプレゼントされます！",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  // 星アイコンとレビューの説明
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _starAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + 0.15 * _starAnimationController.value,
                              child: Icon(
                                Icons.star,
                                size: 50,
                                color: Colors.yellow,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Focusへようこそ！",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "App Storeでレビューを書いて\n$promotionDayCount日間プレミアム機能を無料でお試しください！",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "自動課金はされません。試用期間終了後は自動的に無料プランに戻ります。",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: PromotionStartButton(
                      canStartPromotion: canStartPromotion,
                      onShowAppStoreAlert: () {
                        setState(() {
                          showAppStoreAlert = true;
                        });
                      },
                      onStartPromotion: () async {
                        try {
                          // 実際のプロモーション開始処理
                          await _startPromotion();
                          widget.onStartPromotion();
                        } catch (e) {
                          setState(() {
                            error = e as Exception;
                          });
                        }
                      },
                    ),
                  ),
                  PromotionStartCancelButton(onCancel: widget.onCancel),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // エラーアラート
          if (error != null) _buildErrorAlert(),

          // App Storeアラート
          if (showAppStoreAlert) _buildAppStoreAlert(),
        ],
      ),
    );
  }

  Widget _buildErrorAlert() {
    return AlertDialog(
      title: Text("エラー"),
      content: Text(error.toString()),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              error = null;
            });
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  Widget _buildAppStoreAlert() {
    return AlertDialog(
      title: Text("App Storeを開く"),
      content: Text("レビューを書くためにApp Storeを開きますか？"),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              showAppStoreAlert = false;
            });
          },
          child: Text("キャンセル"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              showAppStoreAlert = false;
            });
            _openAppStore();
          },
          child: Text("開く"),
        ),
      ],
    );
  }

  Future<void> _openAppStore() async {
    final url = Uri.parse("https://apps.apple.com/app/id1663997320?mt=8&action=write-review");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _startPromotion() async {
    // 実際のプロモーション適用ロジック
    // 例: 有料機能を7日間試用できるようにする
    await Future.delayed(const Duration(milliseconds: 500)); // ダミー処理
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
    Key? key,
    required this.canStartPromotion,
    required this.onShowAppStoreAlert,
    required this.onStartPromotion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        analytics.logEvent(name: "pressed_promotion_start");
        if (!canStartPromotion) {
          analytics.logEvent(name: "promotion_start_show_app_store_dialog");
          onShowAppStoreAlert();
        } else {
          analytics.logEvent(name: "promotion_start_run_start_promotion");
          onStartPromotion();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            canStartPromotion ? "報酬を受け取る" : "App Storeでレビューを書く",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class PromotionStartCancelButton extends StatelessWidget {
  final VoidCallback onCancel;

  const PromotionStartCancelButton({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        analytics.logEvent(name: "pressed_promotion_start_cancel");
        onCancel();
      },
      child: Text(
        "今はしない",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
