
enum Flavor { RELEASE, BETA, ALPHA }

class FlavorValues {
  final String apiKey, name, colors, notificationmsg;

  FlavorValues({this.apiKey, this.name, this.colors, this.notificationmsg});
}

class FlavorConfig {
  Flavor flavor;
  FlavorValues flavorValues;
  static FlavorConfig _config;
  factory FlavorConfig({Flavor flavor, FlavorValues flavorValues}) {
    _config = (flavor != null && flavorValues != null)
        ? FlavorConfig._initialise(flavor, flavorValues)
        : FlavorConfig(
            flavor: Flavor.RELEASE,
            flavorValues: FlavorValues(
                apiKey: "API_KEY=i28J_h8e3G_827Hy_RELEASE",
                name: "Release Build",
                colors: "928023",
                notificationmsg: "This Notification is sent by Release Build"),
          );
    return _config;
  }
  FlavorConfig._initialise(this.flavor, this.flavorValues);
  static FlavorConfig get config => _config;
}
