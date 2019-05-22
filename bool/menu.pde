PImage menuImage;
void menuSetup() {
  GUI.addTextbox("newsTextbox", "News", constants.getString("news"), -215, 100, 400, 500,0.5);
  GUI.addButton("playButton", "Play", 285, -125, 300, 50);
  //GUI.addButton("settingsButton", "Settings", 285, -50, 300, 50);
}
void menu() {
  hue +=0.1;
  hue = hue%100;
  colorMode(HSB, 100);
  background(color(hue, 20, 90));
  colorMode(RGB, 255);

  imageMode(CENTER);
  //float scaleSize = ((float)width/menuImage.width > (float)height/menuImage.height) ? (float)width/menuImage.width : (float)height/menuImage.height;
  //image(menuImage, width/2, height/2, menuImage.width * scaleSize, menuImage.height * scaleSize);
  logoPos.x = width/2;
  logoPos.y =lerp(logoPos.y, height/2-200, 0.17);
  logoPos.z =lerp(logoPos.z, 5, 0.17);
  //noTint();
  image(logo, logoPos.x, logoPos.y, logo.width*logoPos.z, logo.height*logoPos.z);
}

void menuCleanup() {
  GUI.removeButton("playButton");
  GUI.removeTextbox("newsTextbox");
  //GUI.removeButton("settingsButton");
}

void playButton() {
  //GSM.changeGameState("characterSelect");
  GSM.changeGameState("game");
}
