class GameStateManager {
  String[] states = {"title", "menu", "game"};
  GameStateManager() {
    gameState = -1;
  };

  private int gameState;

  private void gameStateLoop() {
    if (gameState != -1) {
      method(states[gameState]);
    }
  }

  public void changeGameState(String state) {
    for (int i = 0; i < states.length; i++) {
      if (states[i] == state) {
        if (gameState != -1) {
          method(states[gameState] + "Cleanup");
        }

        gameState = i;
      }
    }
    method(states[gameState] + "Setup");
  }
}
