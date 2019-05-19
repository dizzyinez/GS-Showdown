class GUIManager {
  color textColor = color(34, 32, 52);
  color buttonColor = color(123, 126, 135);
  PFont fontNormal;
  PFont fontLarge;
  PFont fontSmall;
  private ArrayList<Button> buttons = new ArrayList<Button>();
  private ArrayList<Textbox> textboxes = new ArrayList<Textbox>();

  GUIManager() {
  }

  void loadGUI() {
    fontNormal = createFont("DisposableDroidBB.ttf", 45, true);
    fontLarge = createFont("DisposableDroidBB.ttf", 65, true);
    fontSmall = createFont("DisposableDroidBB.ttf", 25, true);
  }
  public void addButton(String name_, String text_, float cx_, float cy_, float w_, float h_) {
    buttons.add(new Button(name_, text_, cx_, cy_, w_, h_));
  }
  public void addTextbox(String name_, String title_, String text_, float cx_, float cy_, float w_, float h_, float a_) {
    textboxes.add(new Textbox(name_, title_, text_, cx_, cy_, w_, h_, a_));
  }

  public void removeButton(String name_) {
    //buttons.remove(0);
    for (int i = 0; i < buttons.size(); i++) {
      if (buttons.get(i).name == name_) {
        buttons.remove(i);
      }
    }
  }
  public void removeTextbox(String name_) {
    //buttons.remove(0);
    for (int i = 0; i < textboxes.size(); i++) {
      if (textboxes.get(i).name == name_) {
        textboxes.remove(i);
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
  private void drawTextboxes() {
    for (Textbox t : textboxes) {
      t.render();
    }
  }

  void updateGUI() {
    drawButtons();
    drawTextboxes();
    if (config.getBoolean("ShowFrameRate")) {
      fill(255);
      textFont(GUI.fontSmall);
      textAlign(LEFT, TOP);
      text(round(frameRate), 20, 20);
    }
  }
}

class Textbox {
  float alpha = 1;
  color col;
  String name;
  String title;
  float cx, cy, w, h;
  String text;
  Textbox(String name_, String title_, String text_, float cx_, float cy_, float w_, float h_, float alpha_) {
    cx = cx_;
    cy = cy_;
    w = w_;
    h = h_;
    name = name_;
    title = title_;
    text = text_;
    col = color(red(GUI.buttonColor), green(GUI.buttonColor), blue(GUI.buttonColor), alpha_ * 255);
  }
  void update() {
  } 
  void setAlpha(float a) {
    alpha = a;
  }
  void render() {
    fill(col);
    stroke(0);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2 + cx, height/2 + cy, w, h);
    fill(GUI.textColor);
    textAlign(LEFT, TOP);
    textSize(h * 0.9);
    textFont(GUI.fontSmall);
    textLeading(30);
    text(text, width/2 + cx+5, height/2 + cy+65, w-5, h);
    fill(255);
    textFont(GUI.fontLarge);
    text(title, width/2 + cx+5, height/2 + cy, w-5, h);
    textAlign(LEFT, BOTTOM);
    textFont(GUI.fontSmall);
    text(version, width/2 + cx+5, height/2 + cy, w-5, h);
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
      mouseX >= width/2 + cx - w/2  &&
      mouseX <= width/2 + cx + w/2  &&
      mouseY >= height/2 + cy - h/2 &&
      mouseY < height/2 + cy + h/2
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
    stroke(0);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2 + cx, height/2 + cy, w, h);
    fill(GUI.textColor);
    textAlign(CENTER, CENTER);
    //textSize(h);//h * 0.9);
    textFont(GUI.fontNormal);
    text(text, width/2 + cx, height/2 + cy-5);
  }
}
