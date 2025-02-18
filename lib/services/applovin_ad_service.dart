import 'dart:math';

import 'package:applovin_max/applovin_max.dart';

class ApplovinAdService {
  static const String banner_ad_unit_ID = "c7b352f3d19a43d9";
  static const String rewarded_ad_unit_ID = "40b342303794ffa4";
  static const int _maxExponentialRetryCount = 6;
  var _rewardedAdRetryAttempt = 0;

  void initializeRewardedAd() {
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
          onAdLoadedCallback: (ad) {
            // Rewarded ad is ready to show. AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_ID) now returns 'true'.
            print('Rewarded ad loaded from ' + ad.networkName);

            // Reset retry attempt
            _rewardedAdRetryAttempt = 0;
          },
          onAdLoadFailedCallback: (adUnitId, error) {
            // Rewarded ad failed to load.
            // AppLovin recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds).
            _rewardedAdRetryAttempt = _rewardedAdRetryAttempt + 1;
            if (_rewardedAdRetryAttempt > _maxExponentialRetryCount) return;
            int retryDelay = pow(2, min(_maxExponentialRetryCount, _rewardedAdRetryAttempt)).toInt();
            print('Rewarded ad failed to load with code ' +
                error.code.toString() +
                ' - retrying in ' +
                retryDelay.toString() +
                's');

            Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
              AppLovinMAX.loadRewardedAd(rewarded_ad_unit_ID);
            });
          },
          onAdDisplayedCallback: (ad) {},
          onAdDisplayFailedCallback: (ad, error) {},
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (ad) {},
          onAdReceivedRewardCallback: (ad, reward) {}),
    );
  }

  void loadRewardedAd() {
    AppLovinMAX.loadRewardedAd(rewarded_ad_unit_ID);
  }

  Future<void> showRewardedAds() async {
    bool isReady = (await AppLovinMAX.isRewardedAdReady(rewarded_ad_unit_ID))!;
    if (isReady) {
      AppLovinMAX.showRewardedAd(rewarded_ad_unit_ID);
    }
  }
}
