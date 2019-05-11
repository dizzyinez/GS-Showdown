class CameraManager {
  float screenShake = 0;
  float screenShakeMultiplier = 2;
  float smoothing =  0.1;
  float zoomSmoothing = 0.1;
  PVector pos = new PVector(stage.platformPosition.x, stage.platformPosition.y - stage.platformSize.y/2);
  float scale = 1;
  CameraManager() {
  }
  void CameraUpdate() {
    screenShake *=0.9;
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
    maxDist = map(maxDist,0,stage.killbox.x,2.2,1);
    scale = maxDist;
    //pos.add((pos.x-to_x)*smoothing,(pos.y-to_y)*smoothing);
  }
  
  void screenShake(float amount) {
  screenShake += amount;
  }
}
