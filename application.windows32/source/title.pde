PImage titleImage;
PImage logo;
PVector logoPos = new PVector(0, 0, 7);
float hue;
void titleSetup() {
  titleImage = loadImage("title.jpg");
  logo = loadImage("Logo.png");
  GUI.addButton("startButton", "Start", 0.5, 0.7, 200, 50);
}



void title() {
  hue +=0.1;
  hue = hue%100;
  colorMode(HSB, 100);
  background(color(hue, 10, 90));
  colorMode(RGB, 255);
text(version,width/2,height*4/5);



  imageMode(CENTER);
  //float scaleSize = ((float)width/titleImage.width > (float)height/titleImage.height) ? (float)width/titleImage.width : (float)height/titleImage.height;
  //image(titleImage, width/2, height/2, titleImage.width * scaleSize, titleImage.height * scaleSize);
  logoPos.x = width/2;
  logoPos.y = height/2;
  image(logo, logoPos.x, logoPos.y, logo.width*logoPos.z, logo.height*logoPos.z);
}

void titleCleanup() {
  GUI.removeButton("startButton");
}

void startButton() {
  GSM.changeGameState("menu");
}
