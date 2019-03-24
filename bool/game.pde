ArrayList<Player> players = new ArrayList<Player>(0);
void gameSetup() {
  GUI.addButton("moveButton", "Move", 0.9, 0.5, 300, 50);
  players.add(new Player(0));
  //players.add(new Player(0));
  loadLegendImages();
}
void game() {
  pushMatrix();
  
  background(100);
  drawStageDebug();
  for (Player p : players) {
    p.update();
  p.render();
  }
  popMatrix();
  //image(legends[0].moves[0].frames[0].frameImage, 100,100);
}
void gameCleanup() {
  GUI.removeButton("moveButton");
}

void moveButton() {
  players.get(0).move(0);
}
