class InputManager {
  public char[] keysToTrack = {'w', 'a', 's', 'd'}; 
  public int[] codedKeysToTrack = {UP, DOWN, LEFT, RIGHT}; 
  public boolean[] keysDown = new boolean[keysToTrack.length];
  public boolean[] codedKeysDown = new boolean[keysToTrack.length];

  boolean keyDown(char k) {
    for (int i = 0; i < keysToTrack.length; i++) {
      if (k == keysToTrack[i]) {
        return keysDown[i];
      }
    }
    return false;
  }
  boolean keyDown(int k) {
    for (int i = 0; i < keysToTrack.length; i++) {
      if (k == codedKeysToTrack[i]) {
        return codedKeysDown[i];
      }
    }
    return false;
  }
}

void keyPressed() {
  if (key != CODED) {
    for (int i = 0; i < Input.keysToTrack.length; i++) {
      if (key == Input.keysToTrack[i]) {
        Input.keysDown[i] = true;
      }
    }
  } else {
    for (int i = 0; i < Input.keysToTrack.length; i++) {
      if (keyCode == Input.codedKeysToTrack[i]) {
        Input.codedKeysDown[i] = true;
      }
    }
  }
}
void keyReleased() {
  if (key != CODED) {
    for (int i = 0; i < Input.keysToTrack.length; i++) {
      if (key == Input.keysToTrack[i]) {
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
