PImage menuImage;
void menuSetup() {
  menuImage = loadImage("menu.PNG");
  GUI.addButton("playButton", "Play", 0.3, 0.5, 300, 50);
  GUI.addButton("settingsButton", "Settings", 0.3, 0.6, 300, 50);
}
void menu() {
  imageMode(CENTER);
  float scaleSize = ((float)width/titleImage.width > (float)height/titleImage.height) ? (float)width/titleImage.width : (float)height/titleImage.height;
  image(menuImage, width/2, height/2, titleImage.width * scaleSize, titleImage.height * scaleSize);
}

void menuCleanup() {
  GUI.removeButton("playButton");
  GUI.removeButton("settingsButton");
}

void playButton() {
  //GSM.changeGameState("characterSelect");
  GSM.changeGameState("game");
}
