GameStateManager GSM = new GameStateManager();
InputManager Input = new InputManager();
GUIManager GUI = new GUIManager();

void setup() {
  frameRate(60);
  size(800, 600);
  //fullScreen();
  surface.setResizable(true);
  noSmooth();
  GUI.loadGUI();
  GSM.changeGameState("title");
}

void draw() {
  background(0);
  GSM.gameStateLoop();
  GUI.updateGUI();
}
