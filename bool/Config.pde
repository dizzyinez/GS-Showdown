boolean debugBoxes = false;
boolean debugFrameRate = false;
String version = "Alpha 0.0.1";

JSONObject config;
void loadConfig() {
  config = loadJSONObject("config.json"); 
  //println(config.getBoolean("HitboxDebug"));
}
