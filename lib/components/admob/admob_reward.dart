import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobReward {
  final String _rewardedAdUnitID = () {
    if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/1712485313';
      } else {
        return 'ca-app-pub-9127772965271297/9460375472';
      }
    }
    throw UnimplementedError();
  }();

  RewardedAd? _rewardedAd;
  Future<void> showRewardedAd({required VoidCallback onEarnedReward}) async {
    if (_rewardedAd == null) {
      return;
    }
    await _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      debugPrint('Rewarded ad rewarded.');
      onEarnedReward();
    });
  }

  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitID,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {
              debugPrint('Rewarded ad showed.');
            },
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {
              debugPrint('Rewarded ad impression.');
            },
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
              debugPrint('Rewarded ad failed to show.');
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              ad.dispose();
              debugPrint('Rewarded ad dismissed.');
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {
              debugPrint('Rewarded ad clicked.');
            },
          );

          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }
}
