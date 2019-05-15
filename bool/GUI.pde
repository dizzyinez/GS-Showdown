class GUIManager {
  color textColor = color(0);
  color buttonColor = color(50,150,150);
  PFont buttonFont;
  private ArrayList<Button> buttons = new ArrayList<Button>();
  
  GUIManager() {
  }
  
  void loadGUI() {
    buttonFont = createFont("SourceSansPro-Regular.ttf",35, true);
  }
  public void addButton(String name_, String text_, float cx_, float cy_, float w_, float h_) {
    buttons.add(new Button(name_, text_, cx_, cy_, w_, h_));
  }

  public void removeButton(String name_) {
    //buttons.remove(0);
    for (int i = 0; i < buttons.size(); i++) {
      if (buttons.get(i).name == name_) {
        buttons.remove(i);
      }
    }
  }
  public void mouseRelease(int mb) {
    if (mb==LEFT) {
      for (Button b : buttons) {
        b.click();
        return;
      }
    }
  }
  private void drawButtons() {
    for (Button b : buttons) {
      b.render();
    }
  }

  void updateGUI() {
    drawButtons();
  }
}

class Bar {

}

class Button {
  color col;
  String name;
  float cx, cy, w, h;
  String text;
  boolean hovering() {
    return (
      mouseX >= width * cx - w/2  &&
      mouseX <= width * cx + w/2  &&
      mouseY >= height * cy - h/2 &&
      mouseY < height * cy + h/2
      );
  }
  Button(String name_, String text_, float cx_, float cy_, float w_, float h_) {
    cx = cx_;
    cy = cy_;
    w = w_;
    h = h_;
    name = name_;
    text = text_;
    col = GUI.buttonColor;
  }
  void click() {
    if (hovering()) {
      method(name);
    }
  }
  void update() {
  } 
  void render() {
    if (hovering()) {
      fill(color(red(col) * 0.7, green(col) * 0.7, blue(col) * 0.7));
    } else {
      fill(col);
    }
    rectMode(CENTER);
    rect(width * cx, height * cy, w, h);
    fill(GUI.textColor);
    textAlign(CENTER,BOTTOM);
    textSize(h * 0.9);
    textFont(GUI.buttonFont);
    text(text, width * cx, height * cy + h/2);
  }
}
