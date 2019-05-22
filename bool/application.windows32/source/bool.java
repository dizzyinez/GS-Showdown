import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class bool extends PApplet {

//import ddf.minim.*;
////import ddf.minim.analysis.*;
////import ddf.minim.effects.*;
////import ddf.minim.signals.*;
////import ddf.minim.spi.*;
////import ddf.minim.ugens.*;

//import processing.sound.*;



//Minim minim;
//AudioSample kick;
//AudioSample snare;



GameStateManager GSM = new GameStateManager();
InputManager Input = new InputManager();
GUIManager GUI = new GUIManager();



public void setup() {
  loadConfig();
  minim = new Minim(this);
  frameRate(60);
  //size(1366, 768);
  
  //fullScreen();
  surface.setResizable(true);
  
  changeAppIcon( loadImage(ICON) );
  changeAppTitle(TITLE);
  GUI.loadGUI();
  loadLegends();
  loadStages();
  GSM.changeGameState("title");
}

public void draw() {
  //background(0);
  GSM.gameStateLoop();
  GUI.updateGUI();
  Input.cleanupInput();
}
class CameraManager {
  float screenShake = 0;
  float screenShakeMultiplier = 2;
  float smoothing =  0.1f;
  float zoomSmoothing = 0.1f;
  PVector pos = new PVector(stage.platformPosition.x, stage.platformPosition.y - stage.platformSize.y/2);
  float scale = 1;
  CameraManager() {
    zoomSmoothing = constants.getFloat("camSmoothing");
  }
  public void CameraUpdate() {
    screenShake *=0.9f;
    float to_x = 0;
    float to_y = 0;
    for (Player p : players) {
      to_x += p.pos.x;
      to_y += p.pos.y;
    }
    to_x /= players.size();
    to_y /= players.size();
    //println(pos);
    //pos = new PVector(to_x,to_y);
    pos.lerp(new PVector(to_x, to_y), smoothing);
    float maxDist = 0;
    for (Player p : players) {
      float dist = dist(pos.x,pos.x, p.pos.x,p.pos.y);
      if (dist > maxDist) {
        maxDist = dist;
      }
    }
    maxDist = map(maxDist,0,stage.killbox.x,2.2f,1);
    scale = maxDist;
    //pos.add((pos.x-to_x)*smoothing,(pos.y-to_y)*smoothing);
  }
  
  public void screenShake(float amount) {
  screenShake += amount;
  }
}
boolean debugBoxes = false;
boolean debugFrameRate = false;
String version;

JSONObject config;
JSONObject constants;
public void loadConfig() {
  config = loadJSONObject("config.json");
  constants = loadJSONObject("constants.json");
  version = constants.getString("Release Stage") + " " + constants.getInt("Major") + "." + constants.getInt("Minor") + "." + constants.getInt("Patch");
  //println(config.getBoolean("HitboxDebug"));
}
class GUIManager {
  int textColor = color(34, 32, 52);
  int buttonColor = color(123, 126, 135);
  PFont fontNormal;
  PFont fontLarge;
  PFont fontSmall;
  private ArrayList<Button> buttons = new ArrayList<Button>();
  private ArrayList<Textbox> textboxes = new ArrayList<Textbox>();

  GUIManager() {
  }

  public void loadGUI() {
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

  public void updateGUI() {
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
  int col;
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
  public void update() {
  } 
  public void setAlpha(float a) {
    alpha = a;
  }
  public void render() {
    fill(col);
    stroke(0);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2 + cx, height/2 + cy, w, h);
    fill(GUI.textColor);
    textAlign(LEFT, TOP);
    textSize(h * 0.9f);
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
  int col;
  String name;
  float cx, cy, w, h;
  String text;
  public boolean hovering() {
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
  public void click() {
    if (hovering()) {
      method(name);
    }
  }
  public void update() {
  } 
  public void render() {
    if (hovering()) {
      fill(color(red(col) * 0.7f, green(col) * 0.7f, blue(col) * 0.7f));
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
class InputManager {
  //public char[] keysToTrack = {'w', 'a', 's', 'd','i','j','k','l',' '}; 
  public char[] keysToTrack = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', ' ', '-', '=', 
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '.'}; 
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

  public boolean keyDown(char k) {
    for (int i = 0; i < keysToTrack.length; i++) {
      if (k == keysToTrack[i]) {
        return keysDown[i];
      }
    }
    for (int i = 0; i < codedKeysToTrack.length; i++) {
      if (PApplet.parseInt(k) == codedKeysToTrack[i]) {
        return codedKeysDown[i];
      }
    }
    return false;
  }
  public boolean keyDown(int k) {
    for (int i = 0; i < codedKeysToTrack.length; i++) {
      if (k == codedKeysToTrack[i]) {
        return codedKeysDown[i];
      }
    }
    return false;
  }

  public boolean keyPressed(char k) {
    for (int i = 0; i < keysToTrack.length; i++) {
      if (k == keysToTrack[i]) {
        return keysPressed[i];
      }
    }
    for (int i = 0; i < codedKeysToTrack.length; i++) {
      if (PApplet.parseInt(k) == codedKeysToTrack[i]) {
        return codedKeysPressed[i];
      }
    }
    return false;
  }
  public boolean keyPressed(int k) {
    for (int i = 0; i < codedKeysToTrack.length; i++) {
      if (k == codedKeysToTrack[i]) {
        return codedKeysPressed[i];
      }
    }
    return false;
  }


  public void cleanupInput() {

    for (int i = 0; i < keysToTrack.length; i++) {
      keysPressed[i] = false;
    }
    for (int i = 0; i < codedKeysToTrack.length; i++) {
      codedKeysPressed[i] = false;
    }
  }
}

public void keyPressed() {
  //println("pressed: " + key);
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
    for (int i = 0; i < Input.codedKeysToTrack.length; i++) {
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
public void keyReleased() {
  if (key != CODED) {
    for (int i = 0; i < Input.keysToTrack.length; i++) {
      if (key == Input.keysToTrack[i]) {
        Input.keysCanPress[i] = true;
        Input.keysDown[i] = false;
      }
    }
  } else {
    for (int i = 0; i < Input.codedKeysToTrack.length; i++) {
      if (keyCode == Input.codedKeysToTrack[i]) {
        Input.codedKeysCanPress[i] = true;
        Input.codedKeysDown[i] = false;
      }
    }
  }
}

public void mouseReleased() {
  GUI.mouseRelease(mouseButton);
}
Legend[] legends; 

JSONObject json;
public void loadLegends() {
  json = loadJSONObject("Legends.json");
  JSONArray legendData = json.getJSONArray("legends");
  legends = new Legend[legendData.size()];
  for (int l = 0; l < legendData.size(); l++) {
    JSONObject legend = legendData.getJSONObject(l); 

    JSONArray idleFrameData = legend.getJSONArray("idleFrames");
    IdleFrame[] idleFrames = new IdleFrame[idleFrameData.size()]; 
    for (int ifd = 0; ifd < idleFrameData.size(); ifd++) {
      JSONObject idleFrame = idleFrameData.getJSONObject(ifd);

      JSONArray hitboxData = idleFrame.getJSONArray("hitboxes");
      Hitbox[] hitboxes = new Hitbox[hitboxData.size()];
      for (int h = 0; h < hitboxData.size(); h++) {
        JSONObject hitbox = hitboxData.getJSONObject(h);
        hitboxes[h] = new Hitbox(hitbox.getInt("x1"), hitbox.getInt("y1"), hitbox.getInt("x2"), hitbox.getInt("y2"), hitbox.getInt("damage"), hitbox.getFloat("knockx"), hitbox.getFloat("knocky"));
      }
      idleFrames[ifd] = new IdleFrame(idleFrame.getInt("x1"), idleFrame.getInt("y1"), idleFrame.getInt("x2"), idleFrame.getInt("y2"), idleFrame.getInt("time"), hitboxes);
    }
    //println(idleFrames[0].x2);
    JSONArray moveData = legend.getJSONArray("moves");
    Move[] moves = new Move[moveData.size()]; 
    for (int m = 0; m < moveData.size(); m++) {
      JSONObject move = moveData.getJSONObject(m);

      JSONArray frameData = move.getJSONArray("frames");
      Frame[] frames = new Frame[frameData.size()];
      for (int f = 0; f < frameData.size(); f++) {
        JSONObject frame = frameData.getJSONObject(f);

        JSONArray hitboxData = frame.getJSONArray("hitboxes");
        Hitbox[] hitboxes = new Hitbox[hitboxData.size()];
        for (int h = 0; h < hitboxData.size(); h++) {
          JSONObject hitbox = hitboxData.getJSONObject(h);
          hitboxes[h] = new Hitbox(hitbox.getInt("x1"), hitbox.getInt("y1"), hitbox.getInt("x2"), hitbox.getInt("y2"), hitbox.getInt("damage"), hitbox.getFloat("knockx"), hitbox.getFloat("knocky"));
        }
        frames[f] = new Frame(frame.getInt("x1"), frame.getInt("y1"), frame.getInt("x2"), frame.getInt("y2"), frame.getInt("time"), hitboxes);
      }
      moves[m] = new Move(frames);
    }
    legends[l] = new Legend(legend.getString("spriteSheetName"), moves, idleFrames, legend.getInt("radiusx"), legend.getInt("radiusy"));
  }
}

public void loadLegendImages() {
  for (int l = 0; l < legends.length; l++) {
    for (int f = 0; f < legends[l].idleFrames.length; f++) {
      legends[l].idleFrames[f].loadFrameImage(l);
    }
    for (int m = 0; m < legends[l].moves.length; m++) {
      for (int f = 0; f < legends[l].moves[m].frames.length; f++) {
        legends[l].moves[m].frames[f].loadFrameImage(l);
      }
    }
  }
}

public String[] getProperty(String data, String tag) {
  String temp[][] = matchAll(data, "<" + tag + ">(.*?)</" + tag + ">");
  String ret[] = new String[temp.length];
  for (int i = 0; i < temp.length; i++) {
    ret[i] = temp[i][1];
  }
  return ret;
}

class Legend {
  String spriteSheetName;
  PImage spriteSheet;
  float radiusx;
  float radiusy;
  Move[] moves = new Move[12];
  IdleFrame[] idleFrames;
  Legend(String spriteSheetName_, Move[] moves_, IdleFrame[] idleFrames_, float radiusx_, float radiusy_) {
    spriteSheetName = spriteSheetName_;
    moves = moves_;
    spriteSheet = loadImage(spriteSheetName);
    idleFrames = idleFrames_;
    radiusx = radiusx_;
    radiusy = radiusy_;
  }
  public void load() {
  }
  public void update() {
  }
}

class Move {
  Frame[] frames;
  Move(Frame[] frames_) {
    frames = frames_;
  }
}

class Frame {
  int x1, y1, x2, y2, time;
  Hitbox[] hitboxes;
  PImage frameImage;
  PImage frameImageFlipped;
  Frame(int x1_, int y1_, int x2_, int y2_, int time_, Hitbox[] hitboxes_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    time = time_;
    hitboxes = hitboxes_;
  }
  public void loadFrameImage(int legend) {
    frameImage = legends[legend].spriteSheet.get(x1, y1, x2, y2);
    frameImageFlipped = flipimage(frameImage);
  }
}

class IdleFrame extends Frame {
  PImage hitImage;
  PImage hitImageFlipped;
  IdleFrame(int x1_, int y1_, int x2_, int y2_, int time_, Hitbox[] hitboxes_) {
    super( x1_, y1_, x2_, y2_, time_, hitboxes_);
  }
  public void loadFrameImage(int legend) {
    frameImage = legends[legend].spriteSheet.get(x1, y1, x2, y2);
    hitImage = frameImage.get(0,0,frameImage.width,frameImage.height);
    hitImage.filter(GRAY);
    frameImageFlipped = flipimage(frameImage);
    hitImageFlipped = flipimage(hitImage);
  }
}





class Hitbox {
  int x1, y1, x2, y2, damage; 
  float knockx, knocky;
  Hitbox(int x1_, int y1_, int x2_, int y2_, int damage_, float knockx_, float knocky_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    damage = damage_;
    knockx = knockx_;
    knocky = knocky_;
  }
}



public PImage flipimage(PImage toflip) {
  PImage output = new PImage(toflip.width, toflip.height);
  PImage mask = new PImage(toflip.width, toflip.height);
  for (int i=0; i < width; i++) {
    for (int j=0; j < toflip.height; j++) {
      //output.set(i, j, toflip.get(toflip.width-i-1, j));
      output.set(i, j, toflip.get(toflip.width-i, j));
      mask.set(i, j, PApplet.parseInt(alpha(toflip.get(toflip.width-i, j))));
    }
  }
  //PImage mask = output;
  //mask.filter(GRAY);
  //mask.filter(THRESHOLD, 0.1);
  //mask.filter(INVERT);
  output.mask(mask);
  //output = mask;
  //output.filter(INVERT);
  return output;
}
class Player {
  int tint = 0;
  int damage = 0;
  int id;
  char[] keys = {'a', 'd', 'w', 's', ' ', 'j', 'k'};
  int legend;
  PVector pos = new PVector(random(stage.platformPosition.x-stage.platformSize.x/2, stage.platformPosition.x+stage.platformSize.x/2), 400);//random(900, 900), 500);
  PVector vel = new PVector(0, 0);
  boolean stunned = false;
  boolean grounded = false;
  int jumps = 3;
  int move = -1;
  int frame = 0;
  int frameTimer = 0;
  int hitStun = 0;
  int stun = 0;
  int direction = 0;
  int moveDirection = 1;
  float x_horizontal = 0;
  float x_vel = 0;
  ArrayList<Hitbox> hitboxes = new ArrayList<Hitbox>(0);
  Player(int legend_, int keymap, int id_, int tint_) {
    id = id_;
    legend = legend_;
    tint = tint_;
    if (keymap == 1 ) {
      keys[0] = '4'; 
      keys[1] = '6'; 
      keys[2] = '8';
      keys[3] = '5';
      keys[4] = '.';
      keys[5] = '+';
    }
  }
  public void move(int move_) {
    if (move_ == -1) {
      move = -1;
      frame = 0;
    }
    if (move == -1) {
      move = move_;
      frame = 0;
    }
  }


  public void update() {
    updatePosition();
    if (move != -1) {
      frameTimer += 1;
      if (legends[legend].moves[move].frames[frame].time <= frameTimer) {
        frameTimer = 0;
        frame += 1;
        if (frame >= legends[legend].moves[move].frames.length) {
          move = -1;
          frame = 0;
          frameTimer = 0;
        }
      }
    }
  }
  public void render() {
    tint(tint);
    PImage frame = getFrame();
    //frame.resize(moveDirection,64);
    imageMode(CENTER);
    //pushMatrix();
    //scale(0.5,1);
    image(frame, pos.x, pos.y);
    //popMatrix();
    if (config.getBoolean("HitboxDebug")) {
      drawHitboxDebug();
    }
  }

  public void updatePosition() {
    if (hitStun > 0) {
      hitStun -=1;
    } else {
      if (stun > 0) {
        stun -= 1;
      } else {
        if (move == -1) {

          handleHorizontalInput();
          if (Input.keyDown(keys[3])) {
            vel.y += 0.4f;
          }
          if (jumps > 0 && Input.keyPressed(keys[4])) {
            jumps -=1;
            vel.y = -6;
          }
          checkMoveInput();
        }
      }
      checkHitboxes();
    }

    if (grounded) {
      vel.x = 0;
      vel.x += direction * 4.2f;
    } else {
      vel.x += direction * 0.42f;
      vel.x *= 0.9f;
    }
    vel.y += 0.2f;
    if (move != -1 && grounded) {
      vel.x*=0.2f;
    }

    grounded = false;
    handleCollision(stage.platformPosition.x - stage.platformSize.x/2, stage.platformPosition.y - stage.platformSize.y/2, 
      stage.platformPosition.x + stage.platformSize.x/2, stage.platformPosition.y + stage.platformSize.y/2
      );
    pos.x += vel.x;
    pos.y += vel.y;
    if (!checkCollision(0, 0, stage.killbox.x, stage.killbox.y)) {
      die();
    }
  }

  public void checkMoveInput() {

    if (Input.keyPressed(keys[5])) {//light attacks
      if (grounded) {//grounded
        if (Input.keyDown(keys[3])) {//down
          move(1);
          return;
        }
        if (Input.keyDown(keys[2])) {//up
          move(3);
          return;
        }
        if (Input.keyDown(keys[0]) || Input.keyDown(keys[1]) ) {//sides
          move(2);
          return;
        }
        move(0);
        return;
      } else {
        if (Input.keyDown(keys[3])) {//down
          move(5);
          return;
        }
        if (Input.keyDown(keys[2])) {//up
          move(7);
          return;
        }
        if (Input.keyDown(keys[0]) || Input.keyDown(keys[1]) ) {//sides
          move(6);
          return;
        }
        move(4);
        return;
      }
    }
  }

  private PImage getFrame() {

    if (move != -1) {

      if (moveDirection == -1) {
        return legends[legend].moves[move].frames[frame].frameImageFlipped;
      } else {
        return legends[legend].moves[move].frames[frame].frameImage;
      }
    }
    if (stun > 0 || hitStun > 0) {
      if (moveDirection == -1) {
        return legends[legend].idleFrames[frame].hitImageFlipped;
      } else {
        return legends[legend].idleFrames[frame].hitImage;
      }
    }
    if (!grounded) {
      if (moveDirection == -1) {
        return legends[legend].idleFrames[1].frameImageFlipped;
      } else {
        return legends[legend].idleFrames[1].frameImage;
      }
    }
    if (moveDirection == -1) {
      return legends[legend].idleFrames[0].frameImageFlipped;
    } else {
      return legends[legend].idleFrames[0].frameImage;
    }
  }
  public void checkHitboxes() {
    for (Player p : players) {
      if (p.id != id) {
        if (p.move >=0) {
          for (Hitbox h : legends[p.legend].moves[p.move].frames[p.frame].hitboxes) {
            //vel.y-=10;
            if (checkCollision(p.pos.x+p.moveDirection*h.x1, p.pos.y+h.y1, p.pos.x+p.moveDirection*h.x2, p.pos.y+h.y2) ) {
              //vel.y-=10;
              hitStun = legends[p.legend].moves[p.move].frames[p.frame].time - p.frameTimer;
              stun = 15;
              vel.y+=h.knocky * (1 + damage/500);
              vel.x+=p.moveDirection*h.knockx * (1 + damage/500);
              hit.trigger();
              cm.screenShake(1);
              move(-1);
              direction =0;
              damage += h.damage;
              //delay(33);
            }
          }
        }
      }
    }
  }

  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean jumpPressed = false;

  public void handleHorizontalInput() {

    if (Input.keyDown(keys[0])) {
      if (!leftPressed || direction == 0 || !rightPressed) {
        direction = -1;
        moveDirection = -1;
      }
      leftPressed = true;
    } else {
      leftPressed = false;
    }
    if (Input.keyDown(keys[1])) {
      if (!rightPressed || direction == 0 || !leftPressed) {

        direction = 1;
        moveDirection = 1;
      }
      rightPressed = true;
    } else {
      rightPressed = false;
    }
    if (!Input.keyDown(keys[0]) && !Input.keyDown(keys[1])) {
      direction =0;
    }
  }



  public void die() {
    damage = 0;
    cm.screenShake(12);
    pos = new PVector(stage.platformPosition.x, stage.platformPosition.y - stage.platformSize.y/2 - 200);
    vel = new PVector(0, 0);
  }

  public void drawHitboxDebug() {
    noStroke();
    fill(200, 20, 10, 80);
    if (move !=-1) {
      rectMode(CORNERS);
      for (Hitbox h : legends[legend].moves[move].frames[frame].hitboxes) {
        rect(pos.x+moveDirection*h.x1, pos.y+h.y1, pos.x+moveDirection*h.x2, pos.y+h.y2);
      }
    }
    rectMode(CENTER);
    fill(10, 200, 10, 30);
    rect(pos.x, pos.y, legends[legend].radiusx*2, legends[legend].radiusy*2);
  }

  public boolean checkCollision(float x1, float y1, float x2, float y2) {//top left and bottom right corners
    float rx = legends[legend].radiusx;
    float ry = legends[legend].radiusy;
    float px1 = pos.x-rx;
    float px2 = pos.x+rx;
    float py1 = pos.y-ry;
    float py2 = pos.y+ry;


    boolean inx = false;
    boolean iny = false;
    if (x1< x2) {

      if (px2>=x1 && px1<=x2) {
        inx = true;
      }
    } else {
      if (px2>=x2 && px1<=x1) {
        inx = true;
      }
    }

    if (y1< y2) {

      if (py2>=y1 && py1<=y2) {
        iny = true;
      }
    } else {
      if (py2>=y2 && py1<=y1) {
        iny = true;
      }
    }


    if (inx && iny) {
      return true;
    }
    return false;
  }
  public void handleCollision(float x1, float y1, float x2, float y2) {//top left and bottom right corners
    float rx = legends[legend].radiusx+1;
    float ry = legends[legend].radiusy+1;
    float px1 = pos.x-rx;
    float px2 = pos.x+rx;
    float py1 = pos.y-ry;
    float py2 = pos.y+ry;
    float pvx1 = pos.x-rx+vel.x;
    float pvx2 = pos.x+rx+vel.x;
    float pvy1 = pos.y-ry+vel.y;
    float pvy2 = pos.y+ry+vel.y;
    if (px2>x1 && px1<x2) {
      if (py2<=y1 && pvy2>=y1) {
        pos.y=y1-ry;
        vel.y=0;
        grounded = true;
        jumps = 3;
      }
      if (py1>=y2 && pvy1<=y2) {
        pos.y=y2+ry;
        vel.y=0;
      }
    } else {

      if (py2>=y1 && py1<=y2) {
        if (px2<=x1 && pvx2>=x1) {
          pos.x=x1-rx;
          vel.x=0;
          vel.y *= 0.9f;
          jumps = 3;
        }
        if (px1>=x2 && pvx1<=x2) {
          pos.x=x2+rx;
          vel.x=0;
          vel.y *= 0.9f;
          jumps = 3;
        }
      }
    }
  }
}

float[] stageP = {1024, 1024, 4, 6, 256, 256, 512, 512, 2.5f, 512, 512, 6, 0.9f, 1.5f, 512, 512, 445, 140};
class Stage {
  float[] p; //properties
  /*
  0  killbox x
   1  killbox y
   2  image frames
   3  frame speed
   4  tile size x
   5  tile size y
   6  image position x
   7  image position y
   8  image scale
   9  background image position x
   10 background image position y
   11 background image speed x
   12 background image speed y
   13 background image scale
   14 platform position x
   15 platform position y
   16 platform size x
   17 platform size y
   */
  int framecounter = 0;
  String stageImageFile;
  String backgroundImageFile;
  PImage[] frames;
  PImage backgroundImage;
  PVector killbox;
  PVector platformSize;
  PVector platformPosition;
  PVector backgroundImagePosition = new PVector(0,0);
  /*Stage(
   int killbox_x, int killbox_y, int platformSize_x, int platformSize_y, int platformPosition_x, int platformPosition_y,
   String stageImageFile_, String backgroundImageFile_, int frames, int frameSpeed, int tilex, int tiley, int imagePosition_x, int imagePosition_y, int imageScale
   )*/
  Stage (
    String stageImageFile_, String backgroundImageFile_, float[] properties_
    ) {
    p = properties_;
    stageImageFile = stageImageFile_;
    backgroundImageFile = backgroundImageFile_;
    killbox = new PVector(p[0], p[1]);
    platformSize = new PVector(p[16], p[17]);
    platformPosition = new PVector(p[14], p[15]);
  }
  public void drawStage() {
    framecounter += 1;
    framecounter %= p[2]*p[3]-1;
    backgroundImagePosition.x += p[11];
    backgroundImagePosition.x %= backgroundImage.width;
    backgroundImagePosition.y += p[12];
    backgroundImagePosition.y %= backgroundImage.height;
    imageMode(CENTER);
    pushMatrix();
    for (int i=0; i < 5; i++) {
      for (int j=0; j < 5; j++) {
        pushMatrix();
        translate(p[9], p[10]);
        scale(p[13]);
    translate(backgroundImagePosition.x,backgroundImagePosition.y);
        translate(backgroundImage.width*(i-2),backgroundImage.height*(j-2));
        image(backgroundImage, 0, 0);
        popMatrix();
      }
    }
popMatrix();


    pushMatrix();
    translate(p[6], p[7]);
    scale(p[8]);//p[8]/10
    image(frames[floor(framecounter/p[3])], 0, 0);
    popMatrix();
  }
  public void load() {
    frames = new PImage[PApplet.parseInt(p[2])];
    PImage frameSheet = loadImage(stageImageFile);
    for (int i=0; i < p[2]; i++) {
      PImage frame = frameSheet.get(i*PApplet.parseInt(p[4]), 0, PApplet.parseInt(p[4]), PApplet.parseInt(p[5]));
      println(1*PApplet.parseInt(p[4]));
      println((1+1)*PApplet.parseInt(p[4]));
      //frame.resize(frame.width*p[8],frame.height*p[8], CLOSE);
      frames[i] = frame;
    }

    backgroundImage = loadImage(backgroundImageFile);
  }
}
public void loadStages() {
  stage.load();
}
Stage stage = new Stage("Airbus_Bus_Ani.png", "Airbus_Background.png", stageP); 
//Stage stage = new Stage(1024, 1024, 450, 130, 512, 512, "Airbus_Bus_Ani.png", "Airbus_Background.png", 4, 10, 256, 256,512,512,2);

public void drawStage() {
  stage.drawStage();
}
public void drawStageDebug() {
  stroke(200, 100);
  noFill();
  rectMode(CORNER);
  rect(0, 0, stage.killbox.x, stage.killbox.y);
  noStroke();
  fill(200, 100);
  rectMode(CENTER);
  rect(stage.platformPosition.x, stage.platformPosition.y, stage.platformSize.x, stage.platformSize.y);
}
final static String ICON  = "icon.png";
final static String TITLE = "GS Showdown";

public void changeAppIcon(PImage img) {
  //final PGraphics pg = createGraphics(16, 16, JAVA2D);

  //pg.beginDraw();
  //pg.image(img, 0, 0, 16, 16);
  //pg.endDraw();

  surface.setIcon(img);
}

public void changeAppTitle(String title) {
  surface.setTitle(title);
}
ArrayList<Player> players = new ArrayList<Player>(0);
CameraManager cm;





//SoundFile hit;
//SoundFile music;

Minim minim;
AudioSample hit;
AudioPlayer music;
public void gameSetup() {
  cm = new CameraManager();
  hit = minim.loadSample("hit.wav", 512);
  music = minim.loadFile("music.mp3");
  //music.loop();
  //GUI.addButton("moveButton", "Move", 0.8, 0.3, 300, 50);
  players.add(new Player(1, 0, 0,color(255,255,255)));
  players.add(new Player(1, 1, 1,color(255,255,255)));
  //players.add(new Player(0));
  loadLegendImages();
}
public void game() {
  pushMatrix();
  cm.CameraUpdate();
  translate(width/2, height/2);
  //scale(cm.scale*100);
  //scale(0.025*100);
  //scale(0.01*100);
  scale(cm.scale);
  //translate(-cm.pos.x+width/2,-cm.pos.y+height/2);
  translate(-cm.pos.x, -cm.pos.y);
  float shake = cm.screenShakeMultiplier*cm.screenShake*config.getFloat("ScreenShakeMultiplier");
  translate(random(-shake, shake), random(-shake, shake));
  background(150);
  drawStage();
  if (config.getBoolean("StageDebug")) {
  drawStageDebug(); 
  }
  for (Player p : players) {
    p.update();
    p.render();
  }
  popMatrix();
  //image(legends[0].moves[0].frames[0].frameImage, 100,100);
}
public void gameCleanup() {
  //GUI.removeButton("moveButton");
}

public void moveButton() {
  players.get(0).move(0);
}
PImage menuImage;
public void menuSetup() {
  GUI.addTextbox("newsTextbox", "News", constants.getString("news"), -215, 100, 400, 500,0.5f);
  GUI.addButton("playButton", "Play", 285, -125, 300, 50);
  //GUI.addButton("settingsButton", "Settings", 285, -50, 300, 50);
}
public void menu() {
  hue +=0.1f;
  hue = hue%100;
  colorMode(HSB, 100);
  background(color(hue, 20, 90));
  colorMode(RGB, 255);

  imageMode(CENTER);
  //float scaleSize = ((float)width/menuImage.width > (float)height/menuImage.height) ? (float)width/menuImage.width : (float)height/menuImage.height;
  //image(menuImage, width/2, height/2, menuImage.width * scaleSize, menuImage.height * scaleSize);
  logoPos.x = width/2;
  logoPos.y =lerp(logoPos.y, height/2-200, 0.17f);
  logoPos.z =lerp(logoPos.z, 5, 0.17f);
  //noTint();
  image(logo, logoPos.x, logoPos.y, logo.width*logoPos.z, logo.height*logoPos.z);
}

public void menuCleanup() {
  GUI.removeButton("playButton");
  GUI.removeTextbox("newsTextbox");
  //GUI.removeButton("settingsButton");
}

public void playButton() {
  //GSM.changeGameState("characterSelect");
  GSM.changeGameState("game");
}
PImage titleImage;
PImage logo;
PVector logoPos = new PVector(0, 0, 7);
int hue = round(random(0, 100));
public void titleSetup() {
  titleImage = loadImage("title.jpg");
  logo = loadImage("Logo.png");
  GUI.addButton("startButton", "Start", 0, 120, 200, 55);
}



public void title() {
  hue +=1;
  hue = hue%1000;
  colorMode(HSB, 100);
  background(color(round(hue/10), 20, 90));
  colorMode(RGB, 255);
  fill(255);
  textAlign(CENTER, CENTER);
  text(version, width/2, height/2+250);



  imageMode(CENTER);
  //float scaleSize = ((float)width/titleImage.width > (float)height/titleImage.height) ? (float)width/titleImage.width : (float)height/titleImage.height;
  //image(titleImage, width/2, height/2, titleImage.width * scaleSize, titleImage.height * scaleSize);
  logoPos.x = width/2;
  logoPos.y = height/2-50;
  image(logo, logoPos.x, logoPos.y, logo.width*logoPos.z, logo.height*logoPos.z);
}

public void titleCleanup() {
  GUI.removeButton("startButton");
}

public void startButton() {
  GSM.changeGameState("menu");
}
  public void settings() {  size(1920, 1080);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "bool" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
