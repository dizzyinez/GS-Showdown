class CameraManager {
  float smoothing =  0.1;
float zoomSmoothing = 0.1;
  PVector pos = new PVector(stage.platformPosition.x, stage.platformPosition.y - stage.platformSize.y/2);
  float scale;
  CameraManager() {
  }
  void CameraUpdate() {
    float to_x = 0;
    float to_y = 0;
    for (Player p : players) {
      to_x += p.pos.x;
      to_y += p.pos.y;
    }
    to_x /= players.size();
    to_y /= players.size();
    println(pos);
    //pos = new PVector(to_x,to_y);
    pos.lerp(new PVector(to_x,to_y), smoothing);
  //pos.add((pos.x-to_x)*smoothing,(pos.y-to_y)*smoothing);
  }
}
