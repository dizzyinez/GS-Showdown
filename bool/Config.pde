boolean debugBoxes = false;
boolean debugFrameRate = false;
String version;

JSONObject config;
JSONObject constants;
void loadConfig() {
  config = loadJSONObject("config.json");
  constants = loadJSONObject("constants.json");
  version = constants.getString("Release Stage") + " " + constants.getInt("Major") + "." + constants.getInt("Minor") + "." + constants.getInt("Patch");
  //println(config.getBoolean("HitboxDebug"));
}
