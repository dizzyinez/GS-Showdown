final static String ICON  = "icon.png";
final static String TITLE = "GS Showdown";

void changeAppIcon(PImage img) {
  //final PGraphics pg = createGraphics(16, 16, JAVA2D);

  //pg.beginDraw();
  //pg.image(img, 0, 0, 16, 16);
  //pg.endDraw();

  surface.setIcon(img);
}

void changeAppTitle(String title) {
  surface.setTitle(title);
}
