PImage menuImage;
void menuSetup() {
  menuImage = loadImage("menu.PNG");
  menuImage.filter(BLUR, 9);
  GUI.addButton("playButton", "Play", 0.3, 0.5, 300, 50);
  //GUI.addButton("settingsButton", "Settings", 0.3, 0.6, 300, 50);
}
void menu() {
  hue +=0.1;
  hue = hue%100;
  colorMode(HSB, 100);
  tint(color(hue, 10, 90));
  colorMode(RGB, 255);
  
  imageMode(CENTER);
  float scaleSize = ((float)width/menuImage.width > (float)height/menuImage.height) ? (float)width/menuImage.width : (float)height/menuImage.height;
  image(menuImage, width/2, height/2, menuImage.width * scaleSize, menuImage.height * scaleSize);
  logoPos.x = width/2;
  logoPos.y =lerp(logoPos.y, height/4, 0.1);
  logoPos.z =lerp(logoPos.z, 5, 0.1);
  noTint();
  image(logo, logoPos.x, logoPos.y, logo.width*logoPos.z, logo.height*logoPos.z);
}

void menuCleanup() {
  GUI.removeButton("playButton");
  //GUI.removeButton("settingsButton");
}

void playButton() {
  //GSM.changeGameState("characterSelect");
  GSM.changeGameState("game");
}