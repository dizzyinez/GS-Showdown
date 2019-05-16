//import ddf.minim.*;
////import ddf.minim.analysis.*;
////import ddf.minim.effects.*;
////import ddf.minim.signals.*;
////import ddf.minim.spi.*;
////import ddf.minim.ugens.*;

//import processing.sound.*;

import ddf.minim.*;

//Minim minim;
//AudioSample kick;
//AudioSample snare;



GameStateManager GSM = new GameStateManager();
InputManager Input = new InputManager();
GUIManager GUI = new GUIManager();



void setup() {
  minim = new Minim(this);
  frameRate(60);
  //size(1366, 768);
  size(1440, 1280);
  //fullScreen();
  surface.setResizable(true);
  noSmooth();
  changeAppIcon( loadImage(ICON) );
  changeAppTitle(TITLE);
  GUI.loadGUI();
  loadConfig();
  loadLegends();
  GSM.changeGameState("title");
}

void draw() {
  //background(0);
  GSM.gameStateLoop();
  GUI.updateGUI();
  Input.cleanupInput();
}
