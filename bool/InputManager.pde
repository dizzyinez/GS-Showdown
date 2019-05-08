class InputManager {
  public char[] keysToTrack = {'w', 'a', 's', 'd','i','j','k','l'}; 
  public int[] codedKeysToTrack = {UP, DOWN, LEFT, RIGHT}; 
  public boolean[] keysDown          = new boolean[keysToTrack.length];
  public boolean[] keysCanPress      = new boolean[keysToTrack.length];
  public boolean[] keysPressed       = new boolean[keysToTrack.length];
  public boolean[] codedKeysDown     = new boolean[codedKeysToTrack.length];
  public boolean[] codedKeysCanPress = new boolean[codedKeysToTrack.length];
  public boolean[] codedKeysPressed  = new boolean[codedKeysToTrack.length];

  InputManager() {
    for (int i = 0; i < keysToTrack.length; i++) { 
      keysCanPress[i] = true;
    }
    for (int i = 0; i < codedKeysToTrack.length; i++) { 
      codedKeysCanPress[i] = true;
    }
  }
  
  boolean keyDown(char k) {
    for (int i = 0; i < keysToTrack.length; i++) {
      if (k == keysToTrack[i]) {
        return keysDown[i];
      }
    }
    return false;
  }
  boolean keyDown(int k) {
    for (int i = 0; i < codedKeysToTrack.length; i++) {
      if (k == codedKeysToTrack[i]) {
        return codedKeysDown[i];
      }
    }
    return false;
  }

  boolean keyPressed(char k) {
    for (int i = 0; i < keysToTrack.length; i++) {
      if (k == keysToTrack[i]) {
        return keysPressed[i];
      }
    }
    return false;
  }
  boolean keyPressed(int k) {
    for (int i = 0; i < codedKeysToTrack.length; i++) {
      if (k == codedKeysToTrack[i]) {
        return codedKeysPressed[i];
      }
    }
    return false;
  }


  void cleanupInput() {

    for (int i = 0; i < keysToTrack.length; i++) {
      keysPressed[i] = false;
    }
    for (int i = 0; i < codedKeysToTrack.length; i++) {
      codedKeysPressed[i] = false;
    }
  }
}

void keyPressed() {
  if (key != CODED) {
    for (int i = 0; i < Input.keysToTrack.length; i++) {
      if (key == Input.keysToTrack[i]) {
        Input.keysDown[i] = true;
        if (Input.keysCanPress[i] == true) {
          Input.keysPressed[i] = true;
          Input.keysCanPress[i] = false;
        }
      }
    }
  } else {
    for (int i = 0; i < Input.keysToTrack.length; i++) {
      if (keyCode == Input.codedKeysToTrack[i]) {
        Input.codedKeysDown[i] = true;
        if (Input.codedKeysCanPress[i] == true) {
          Input.codedKeysPressed[i] = true;
          Input.codedKeysCanPress[i] = false;
        }
      }
    }
  }
}
void keyReleased() {
  if (key != CODED) {
    for (int i = 0; i < Input.keysToTrack.length; i++) {
      if (key == Input.keysToTrack[i]) {
        Input.keysCanPress[i] = true;
        Input.keysDown[i] = false;
      }
    }
  } else {
    for (int i = 0; i < Input.keysToTrack.length; i++) {
      if (keyCode == Input.codedKeysToTrack[i]) {
        Input.codedKeysDown[i] = false;
      }
    }
  }
}

void mouseReleased() {
  GUI.mouseRelease(mouseButton);
}
