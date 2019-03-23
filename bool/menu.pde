PImage menuImage;
void menuSetup() {
  menuImage = loadImage("menu.PNG");
  GUI.addButton("playButton", "PLAY", 0.3, 0.5, 300, 50);
  GUI.addButton("settingsButton", "SETTINGS", 0.3, 0.6, 300, 50);
}
void menu() {
  imageMode(CENTER);
  float scaleSize = ((float)width/titleImage.width > (float)height/titleImage.height) ? (float)width/titleImage.width : (float)height/titleImage.height;
  image(menuImage, width/2, height/2, titleImage.width * scaleSize, titleImage.height * scaleSize);
}

void menuCleanup() {
  GUI.removeButton("playButton");
}

void playButton() {
  //GSM.changeGameState("characterSelect");
}
