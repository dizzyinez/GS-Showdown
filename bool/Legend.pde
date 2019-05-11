Legend[] legends; 

JSONObject json;
void loadLegends() {
  json = loadJSONObject("Legends.json");
  JSONArray legendData = json.getJSONArray("legends");
  legends = new Legend[legendData.size()];
  for (int l = 0; l < legendData.size(); l++) {
    JSONObject legend = legendData.getJSONObject(l); 

    JSONArray idleFrameData = legend.getJSONArray("idleFrames");
    Frame[] idleFrames = new Frame[idleFrameData.size()]; 
    for (int ifd = 0; ifd < idleFrameData.size(); ifd++) {
      JSONObject idleFrame = idleFrameData.getJSONObject(ifd);

      JSONArray hitboxData = idleFrame.getJSONArray("hitboxes");
      Hitbox[] hitboxes = new Hitbox[hitboxData.size()];
      for (int h = 0; h < hitboxData.size(); h++) {
        JSONObject hitbox = hitboxData.getJSONObject(h);
        hitboxes[h] = new Hitbox(hitbox.getInt("x1"), hitbox.getInt("y1"), hitbox.getInt("x2"), hitbox.getInt("y2"), hitbox.getInt("damage"), hitbox.getFloat("knockx"), hitbox.getFloat("knocky"));
      }
      idleFrames[ifd] = new Frame(idleFrame.getInt("x1"), idleFrame.getInt("y1"), idleFrame.getInt("x2"), idleFrame.getInt("y2"), idleFrame.getInt("time"), hitboxes);
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

void loadLegendImages() {
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

String[] getProperty(String data, String tag) {
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
  Frame[] idleFrames;
  Legend(String spriteSheetName_, Move[] moves_, Frame[] idleFrames_, float radiusx_, float radiusy_) {
    spriteSheetName = spriteSheetName_;
    moves = moves_;
    spriteSheet = loadImage(spriteSheetName);
    idleFrames = idleFrames_;
    radiusx = radiusx_;
    radiusy = radiusy_;
  }
  void load() {
  }
  void update() {
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
  void loadFrameImage(int legend) {
    frameImage = legends[legend].spriteSheet.get(x1, y1, x2, y2);
    frameImageFlipped = flipimage(frameImage);
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



PImage flipimage(PImage toflip) {
  PImage output = new PImage(toflip.width, toflip.height);
  PImage mask = new PImage(toflip.width, toflip.height);
  for (int i=0; i < width; i++) {
    for (int j=0; j < toflip.height; j++) {
      //output.set(i, j, toflip.get(toflip.width-i-1, j));
      output.set(i, j, toflip.get(toflip.width-i, j));
      mask.set(i, j, int(alpha(toflip.get(toflip.width-i, j))));
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
