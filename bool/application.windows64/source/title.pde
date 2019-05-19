PImage titleImage;
PImage logo;
PVector logoPos = new PVector(0, 0, 7);
int hue = round(random(0, 100));
void titleSetup() {
  titleImage = loadImage("title.jpg");
  logo = loadImage("Logo.png");
  GUI.addButton("startButton", "Start", 0, 120, 200, 55);
}



void title() {
  hue +=1;
  hue = hue%1000;
  colorMode(HSB, 100);
  background(color(round(hue/10), 20, 90));
  colorMode(RGB, 255);
  fill(255);
  textAlign(CENTER, CENTER);
  text(version, width/2, height/2+250);



  imageMode(CENTER);
  //float scaleSize = ((float)width/titleImage.width > (float)height/titleImage.height) ? (float)width/titleImage.width : (float)height/titleImage.height;
  //image(titleImage, width/2, height/2, titleImage.width * scaleSize, titleImage.height * scaleSize);
  logoPos.x = width/2;
  logoPos.y = height/2-50;
  image(logo, logoPos.x, logoPos.y, logo.width*logoPos.z, logo.height*logoPos.z);
}

void titleCleanup() {
  GUI.removeButton("startButton");
}

void startButton() {
  GSM.changeGameState("menu");
}
