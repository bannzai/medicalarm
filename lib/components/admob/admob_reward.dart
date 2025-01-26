import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
void showRewardedAd({required VoidCallback onEarnedReward}) {
  _rewardedAd?.show(onUserEarnedReward: (ad, reward) {
    debugPrint('Rewarded ad rewarded.');
    onEarnedReward();
  });
}

void loadRewardedAd() {
  RewardedAd.load(
    adUnitId: _rewardedAdUnitID,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (ad) {
        ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {},
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {});

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
