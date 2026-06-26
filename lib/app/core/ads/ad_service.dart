import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Singleton service that manages Google Mobile Ads lifecycle.
/// Uses TEST ad unit IDs â€” replace with real IDs before going live.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // â”€â”€â”€ TEST AD UNIT IDs (replace these with your real AdMob IDs for production) â”€â”€â”€
  static const String _androidBannerTestId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _androidInterstitialTestId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _androidRewardedTestId =
      'ca-app-pub-3940256099942544/5224354917';

  static const String _iosBannerTestId =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _iosInterstitialTestId =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _iosRewardedTestId =
      'ca-app-pub-3940256099942544/1712485313';

  String get bannerAdUnitId =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? _iosBannerTestId
          : _androidBannerTestId;

  String get interstitialAdUnitId =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? _iosInterstitialTestId
          : _androidInterstitialTestId;

  String get rewardedAdUnitId =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? _iosRewardedTestId
          : _androidRewardedTestId;

  // â”€â”€â”€ INTERSTITIAL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          debugPrint('[AdService] Interstitial loaded.');
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
          debugPrint('[AdService] Interstitial failed: ${error.message}');
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onDismissed}) {
    if (!_isInterstitialReady || _interstitialAd == null) {
      debugPrint('[AdService] Interstitial not ready yet.');
      onDismissed?.call();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialReady = false;
        loadInterstitialAd(); // preload next
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialReady = false;
        onDismissed?.call();
      },
    );
    _interstitialAd!.show();
  }

  // â”€â”€â”€ REWARDED â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  RewardedAd? _rewardedAd;
  bool _isRewardedReady = false;

  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedReady = true;
          debugPrint('[AdService] Rewarded loaded.');
        },
        onAdFailedToLoad: (error) {
          _isRewardedReady = false;
          debugPrint('[AdService] Rewarded failed: ${error.message}');
        },
      ),
    );
  }

  void showRewardedAd({
    required void Function(AdWithoutView ad, RewardItem reward) onUserEarnedReward,
    VoidCallback? onDismissed,
  }) {
    if (!_isRewardedReady || _rewardedAd == null) {
      debugPrint('[AdService] Rewarded not ready yet.');
      onDismissed?.call();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _isRewardedReady = false;
        loadRewardedAd(); // preload next
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _isRewardedReady = false;
        onDismissed?.call();
      },
    );
    _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
  }

  // â”€â”€â”€ INIT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    // Preload ads on start
    await loadInterstitialAd();
    await loadRewardedAd();
    debugPrint('[AdService] Initialized.');
  }
}
