enum Flavor { production, staging, development }

class AppConfig {
  static late Flavor _flavor;

  static void setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  static Flavor get flavor => _flavor;

  static String get baseUrl {
    switch (_flavor) {
      case Flavor.production:
        return 'https://api.portal.zed.business/';
      case Flavor.staging:
        return 'https://api.uat.zed.business/';
      case Flavor.development:
        return 'https://api.dev.zed.business/';
    }
  }

  static String get webUrl {
    switch (_flavor) {
      case Flavor.production:
        return 'https://portal.zed.business';
      case Flavor.staging:
        return 'https://uat.zed.business';
      case Flavor.development:
        return 'https://dev.zed.business';
    }
  }

  static String get domainName {
    switch (_flavor) {
      case Flavor.production:
        return 'api.portal.zed.business';
      case Flavor.staging:
        return 'api.uat.zed.business';
      case Flavor.development:
        return 'api.dev.zed.business';
    }
  }

  static String get appName {
    switch (_flavor) {
      case Flavor.production:
        return 'Zed Nano';
      case Flavor.staging:
        return 'Zed Nano UAT';
      case Flavor.development:
        return 'Zed Nano Dev';
    }
  }
}
