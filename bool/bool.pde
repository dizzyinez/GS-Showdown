GameStateManager GSM = new GameStateManager();
InputManager Input = new InputManager();
GUIManager GUI = new GUIManager();

void setup() {
  frameRate(60);
  //size(1366, 768);
  size(1280,1440);
  //fullScreen();
  surface.setResizable(true);
  noSmooth();
  GUI.loadGUI();
  loadLegends();
  GSM.changeGameState("game");
}

void draw() {
  //background(0);
  GSM.gameStateLoop();
  GUI.updateGUI();
}
