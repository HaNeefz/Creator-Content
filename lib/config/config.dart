import 'package:flutter/material.dart';

enum Environment { DEV, PROD }

class AppConfig {
  static Map<String, dynamic>? _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.DEV:
        _config = _Config.devConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;

        /// Hide All Log.
        debugPrint = (String? message, {int? wrapWidth}) {};
        break;
    }
  }

  // static get baseUrl => _config[_Config.YDCMEMBER_URL];
  // static get geoApiKey => _config[_Config.GMS_API_KEY];
  // static get apiKey => _config[_Config.API_KEY];
  // static get gmsKey => _config[_Config.GMS_API_KEY];
  // static get adAppIDiOS => _config[_Config.AD_APP_ID_IOS];
  // static get adAppIDAndoid => _config[_Config.AD_APP_ID_ANDROID];
  // static get adUintIDiOS => _config[_Config.AD_UNIT_ID_IOS];
  // static get adUintIDAndoid => _config[_Config.AD_UNIT_ID_ANDROID];
}

class _Config {
  static const Env = "Environment";

  static Map<String, dynamic> devConstants = {
    Env: Environment.DEV,
  };

  static Map<String, dynamic> prodConstants = {
    Env: Environment.PROD,
  };
}
