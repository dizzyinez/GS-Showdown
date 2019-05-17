boolean debugBoxes = false;
boolean debugFrameRate = false;
String version;// = "Alpha 0.0.1";

JSONObject config;
JSONObject constants;
void loadConfig() {
  config = loadJSONObject("config.json");
  constants = loadJSONObject("constants.json"); 
  //println(config.getBoolean("HitboxDebug"));
}
