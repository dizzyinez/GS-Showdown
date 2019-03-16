
void loadLegends() {
  String[] data = loadStrings("Legends.txt");
  String dataline = join(data, "");s
  for (int i = 0; i < data.length; i++) {
   if  
  }
}
class Legend {
  PImage spriteSheet;
  Move[] moves = new Move[12];
  Legend() {
  }
  void load() {
  }
  void update() {
  }
  //PImage getFrame() {}
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
  Frame(int x1_, int y1_, int x2_, int y2_, int time_, Hitbox[] hitboxes_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    time = time_;
    hitboxes = hitboxes_;
  }
}

class Hitbox {
  int x1, y1, x2, y2, damage;
  Hitbox(int x1_, int y1_, int x2_, int y2_, int damage_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    damage = damage_;
  }
}
