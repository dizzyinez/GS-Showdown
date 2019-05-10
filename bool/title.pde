PImage titleImage;
void titleSetup() {
  titleImage = loadImage("title.jpg");
  GUI.addButton("startButton", "Start", 0.5, 0.7, 200, 50);
}
void title() {
  imageMode(CENTER);
  float scaleSize = ((float)width/titleImage.width > (float)height/titleImage.height) ? (float)width/titleImage.width : (float)height/titleImage.height;
  image(titleImage, width/2, height/2, titleImage.width * scaleSize, titleImage.height * scaleSize);
}

void titleCleanup() {
  GUI.removeButton("startButton");
}

void startButton() {
  GSM.changeGameState("menu");
}
