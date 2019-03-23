class Player {
  int legend;
  PVector pos = new PVector(100, 100);
  boolean stunned = false;
  int move = -1;
  int frame = 0;
  int frameTimer = 0;
  Player(int legend_) {
    legend = legend_;
  }
  void move(int move_) {
    if (move == -1) {
      move = move_;
      frame = 0;
    }
  }

  void update() {
    println(frame);
    if (move != -1) {
      frameTimer += 1;
      if (legends[legend].moves[move].frames[frame].time <= frameTimer) {
        frame += 1;
        if (frame >= legends[legend].moves[move].frames.length) {
          move = -1;
          frame = 0;
          frameTimer = 0;
        }
      }
    }
  }
  void render() {
    imageMode(CENTER);
    image(getFrame(), pos.x, pos.y);
  }

  private PImage getFrame() {
    if (move != -1) {
      return legends[legend].moves[move].frames[frame].frameImage;
    }
    if (!stunned) {
      return legends[legend].idleFrames[frame].frameImage;
    }
    return legends[legend].idleFrames[frame].frameImage;
  }
}
