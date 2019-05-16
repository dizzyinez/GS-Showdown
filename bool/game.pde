ArrayList<Player> players = new ArrayList<Player>(0);
CameraManager cm = new CameraManager();





//SoundFile hit;
//SoundFile music;

Minim minim;
AudioSample hit;
AudioPlayer music;
void gameSetup() {
  hit = minim.loadSample("hit.wav", 512);
  music = minim.loadFile("music.mp3");
  //music.loop();
  //GUI.addButton("moveButton", "Move", 0.8, 0.3, 300, 50);
  players.add(new Player(1, 0, 0,color(255,255,255)));
  players.add(new Player(1, 1, 1,color(245,177,220)));
  //players.add(new Player(0));
  loadLegendImages();
}
void game() {
  pushMatrix();
  cm.CameraUpdate();
  translate(width/2, height/2);
  //scale(cm.scale*100);
  //scale(0.025*100);
  //scale(0.01*100);
  scale(cm.scale);
  //translate(-cm.pos.x+width/2,-cm.pos.y+height/2);
  translate(-cm.pos.x, -cm.pos.y);
  float shake = cm.screenShakeMultiplier*cm.screenShake;
  translate(random(-shake, shake), random(-shake, shake));
  background(100);
  drawStageDebug();
  for (Player p : players) {
    p.update();
    p.render();
  }
  popMatrix();
  //image(legends[0].moves[0].frames[0].frameImage, 100,100);
  if (debugFrameRate) {
    text(round(frameRate), 10, 10);
  }
}
void gameCleanup() {
  //GUI.removeButton("moveButton");
}

void moveButton() {
  players.get(0).move(0);
}
