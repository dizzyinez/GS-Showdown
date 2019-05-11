class Player {
  int id;
  char[] keys = {'a', 'd', 'w', 's', ' ', 'j', 'k'};
  int legend;
  PVector pos = new PVector(random(400, 800), 400);//random(900, 900), 500);
  PVector vel = new PVector(0, 0);
  boolean stunned = false;
  boolean grounded = false;
  int jumps = 3;
  int move = -1;
  int frame = 0;
  int frameTimer = 0;
  int hitStun = 0;
  int direction = 0;
  int moveDirection = 1;
  float x_horizontal = 0;
  float x_vel = 0;
  ArrayList<Hitbox> hitboxes = new ArrayList<Hitbox>(0);
  Player(int legend_, int keymap, int id_) {
    id = id_;
    legend = legend_;
    if (keymap == 1 ) {
      keys[0] = LEFT; 
      keys[1] = RIGHT; 
      keys[2] = UP;
      keys[3] = DOWN;
      keys[4] = '.';
      keys[5] = 'm';
    }
  }
  void move(int move_) {
    if (move_ == -1) {
    move = -1;
    frame = 0;
    }
    if (move == -1) {
      move = move_;
      frame = 0;
    }
  }


  void update() {
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
  void render() {
    PImage frame = getFrame();
    //frame.resize(moveDirection,64);
    imageMode(CENTER);
    //pushMatrix();
    //scale(0.5,1);
    image(frame, pos.x, pos.y);
    //popMatrix();
    if (debugBoxes) {
      drawHitboxDebug();
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
    if (!stunned) {
      if (moveDirection == -1) {
        return legends[legend].idleFrames[frame].frameImageFlipped;
      } else {
        return legends[legend].idleFrames[frame].frameImage;
      }
    }
    if (moveDirection == -1) {
      return legends[legend].idleFrames[frame].frameImageFlipped;
    } else {
      return legends[legend].idleFrames[frame].frameImage;
    }
  }

  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean jumpPressed = false;



  void checkMoveInput() {
    if (grounded && Input.keyPressed(keys[5])) {//light attacks
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
    }
  }

  void updatePosition() {
    if (hitStun > 0) {
      hitStun -=1;
    } else {
      if (move == -1) {
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
        if (Input.keyDown(keys[3])) {
          vel.y += 0.4;
        }
        if (jumps > 0 && Input.keyPressed(keys[4])) {
          jumps -=1;
          vel.y = -6;
        }
        checkMoveInput();
      }
      checkHitboxes();
    }


    if (grounded) {
      vel.x = 0;
      vel.x += direction * 6;
    } else {
      vel.x += direction * 0.6;
      vel.x *= 0.9;
    }
    vel.y += 0.2;
    if (move != -1) {
      vel.x*=0.2;
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

  void checkHitboxes() {
    for (Player p : players) {
      if (p.id != id) {
        if (p.move >=0) {
          for (Hitbox h : legends[p.legend].moves[p.move].frames[p.frame].hitboxes) {
            //vel.y-=10;
            if (checkCollision(p.pos.x+p.moveDirection*h.x1, p.pos.y+h.y1, p.pos.x+p.moveDirection*h.x2, p.pos.y+h.y2) ) {
              //vel.y-=10;
              hitStun = legends[p.legend].moves[p.move].frames[p.frame].time - p.frameTimer;
              vel.y+=h.knocky;
              vel.x+=p.moveDirection*h.knockx;
              hit.trigger();
              cm.screenShake(1);
              move(-1);
              //delay(33);
            }
          }
        }
      }
    }
  }





  void die() {
    cm.screenShake(12);
    pos = new PVector(stage.platformPosition.x, stage.platformPosition.y - stage.platformSize.y/2 - 200);
    vel = new PVector(0, 0);
  }

  void drawHitboxDebug() {
    noFill();
    stroke(10, 200, 10, 50);
    if (move !=-1) {
      rectMode(CORNERS);
      for (Hitbox h : legends[legend].moves[move].frames[frame].hitboxes) {
        rect(pos.x+moveDirection*h.x1, pos.y+h.y1, pos.x+moveDirection*h.x2, pos.y+h.y2);
      }
    }
    rectMode(CENTER);
    rect(pos.x, pos.y, legends[legend].radiusx*2, legends[legend].radiusy*2);
  }

  boolean checkCollision(float x1, float y1, float x2, float y2) {//top left and bottom right corners
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
  void handleCollision(float x1, float y1, float x2, float y2) {//top left and bottom right corners
    float rx = legends[legend].radiusx;
    float ry = legends[legend].radiusy;
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
    }

    if (py2>=y1 && py1<=y2) {
      if (px2<=x1 && pvx2>=x1) {
        pos.x=x1-rx;
        vel.x=0;
        vel.y *= 0.9;
        jumps = 3;
      }
      if (px1>=x2 && pvx1<=x2) {
        pos.x=x2+rx;
        vel.x=0;
        vel.y *= 0.9;
        jumps = 3;
      }
    }
  }
}
