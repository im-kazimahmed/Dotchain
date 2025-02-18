import 'package:clever_ads_solutions/public/InitConfig.dart';
import 'package:clever_ads_solutions/public/MediationManager.dart';
import 'package:clever_ads_solutions/public/AdTypes.dart';
import 'package:clever_ads_solutions/public/InitializationListener.dart';
import 'package:clever_ads_solutions/CAS.dart';

class CleverAdsSolutionsService {
  MediationManager? manager;

  void initialize() {
    // Set your Flutter version
    CAS.setFlutterVersion("3.13.0");

    manager = CAS
        .buildManager()
        // Set initialization listener
        .withInitializationListener(InitializationListenerWrapper())
        // Set your CAS ID
        .withCasId("com.dotchain.network")
        // List Ad formats used in app
        .withAdTypes(AdTypeFlags.Banner | AdTypeFlags.Rewarded)
        .initialize();
  }
}

class InitializationListenerWrapper extends InitializationListener {
  @override
  void onCASInitialized(InitConfig initialConfig) {
    String error = initialConfig.error;
    String countryCode = initialConfig.countryCode;
    bool isTestMode = initialConfig.isTestMode;
    bool isConsentRequired = initialConfig.isConsentRequired;
  }
}
