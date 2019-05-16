class Stage {
  PImage stageImage;
  PVector killbox;
  PVector platformSize;
  PVector platformPosition;
  Stage(String file, int killbox_x, int killbox_y, int platformSize_x, int platformSize_y, int platformPosition_x, int platformPosition_y) {
    //stageImage = loadImage(file);   
    killbox = new PVector(killbox_x,killbox_y);
    platformSize = new PVector(platformSize_x,platformSize_y);
    platformPosition = new PVector(platformPosition_x,platformPosition_y);
  }
}

Stage stage = new Stage("stage",1024,1024,450,130,512,512);


void drawStageDebug() {
  stroke(200);
  noFill();
  rectMode(CORNER);
  rect(0,0,stage.killbox.x,stage.killbox.y);
  fill(200);
  rectMode(CENTER);
  rect(stage.platformPosition.x,stage.platformPosition.y,stage.platformSize.x,stage.platformSize.y);
}
