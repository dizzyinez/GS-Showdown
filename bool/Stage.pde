
float[] stageP = {1024, 1024, 4, 6, 256, 256, 512, 512, 2.5, 512, 512, 6, 0.9, 1.5, 512, 512, 445, 140};
class Stage {
  float[] p; //properties
  /*
  0  killbox x
   1  killbox y
   2  image frames
   3  frame speed
   4  tile size x
   5  tile size y
   6  image position x
   7  image position y
   8  image scale
   9  background image position x
   10 background image position y
   11 background image speed x
   12 background image speed y
   13 background image scale
   14 platform position x
   15 platform position y
   16 platform size x
   17 platform size y
   */
  int framecounter = 0;
  String stageImageFile;
  String backgroundImageFile;
  PImage[] frames;
  PImage backgroundImage;
  PVector killbox;
  PVector platformSize;
  PVector platformPosition;
  PVector backgroundImagePosition = new PVector(0,0);
  /*Stage(
   int killbox_x, int killbox_y, int platformSize_x, int platformSize_y, int platformPosition_x, int platformPosition_y,
   String stageImageFile_, String backgroundImageFile_, int frames, int frameSpeed, int tilex, int tiley, int imagePosition_x, int imagePosition_y, int imageScale
   )*/
  Stage (
    String stageImageFile_, String backgroundImageFile_, float[] properties_
    ) {
    p = properties_;
    stageImageFile = stageImageFile_;
    backgroundImageFile = backgroundImageFile_;
    killbox = new PVector(p[0], p[1]);
    platformSize = new PVector(p[16], p[17]);
    platformPosition = new PVector(p[14], p[15]);
  }
  void drawStage() {
    framecounter += 1;
    framecounter %= p[2]*p[3]-1;
    backgroundImagePosition.x += p[11];
    backgroundImagePosition.x %= backgroundImage.width;
    backgroundImagePosition.y += p[12];
    backgroundImagePosition.y %= backgroundImage.height;
    imageMode(CENTER);
    pushMatrix();
    for (int i=0; i < 5; i++) {
      for (int j=0; j < 5; j++) {
        pushMatrix();
        translate(p[9], p[10]);
        scale(p[13]);
    translate(backgroundImagePosition.x,backgroundImagePosition.y);
        translate(backgroundImage.width*(i-2),backgroundImage.height*(j-2));
        image(backgroundImage, 0, 0);
        popMatrix();
      }
    }
popMatrix();


    pushMatrix();
    translate(p[6], p[7]);
    scale(p[8]);//p[8]/10
    image(frames[floor(framecounter/p[3])], 0, 0);
    popMatrix();
  }
  void load() {
    frames = new PImage[int(p[2])];
    PImage frameSheet = loadImage(stageImageFile);
    for (int i=0; i < p[2]; i++) {
      PImage frame = frameSheet.get(i*int(p[4]), 0, int(p[4]), int(p[5]));
      println(1*int(p[4]));
      println((1+1)*int(p[4]));
      //frame.resize(frame.width*p[8],frame.height*p[8], CLOSE);
      frames[i] = frame;
    }

    backgroundImage = loadImage(backgroundImageFile);
  }
}
void loadStages() {
  stage.load();
}
Stage stage = new Stage("Airbus_Bus_Ani.png", "Airbus_Background.png", stageP); 
//Stage stage = new Stage(1024, 1024, 450, 130, 512, 512, "Airbus_Bus_Ani.png", "Airbus_Background.png", 4, 10, 256, 256,512,512,2);

void drawStage() {
  stage.drawStage();
}
void drawStageDebug() {
  stroke(200, 100);
  noFill();
  rectMode(CORNER);
  rect(0, 0, stage.killbox.x, stage.killbox.y);
  noStroke();
  fill(200, 100);
  rectMode(CENTER);
  rect(stage.platformPosition.x, stage.platformPosition.y, stage.platformSize.x, stage.platformSize.y);
}
