int x, y, w, h, r, min_x, max_x, min_y, max_y;

int mv_hor, mv_ver;

void setup() {
  size(1000, 1000);
  // Setup form
  x = 500;
  y = 500;
  w = 50;
  h = 50;
  r = 25;       // circle radius

  // Limits Screen
  min_x = r;
  max_x = width-r;      // width screen minus radius(keep the whole circle in the frame)

  min_y = r;
  max_y = height-r;

  // move / speed
  mv_hor = 17;  // move horizontal
  mv_ver = 7;  // move vertical

}

void draw() {
  background(0);

  //  Move
  x = x + mv_hor;
  y = y + mv_ver;

  //   bounce on borders
  if (x > max_x || x < min_x) {
    mv_hor = -mv_hor;   // reverse direction
  }
  if (y > max_y || y < min_y) {
    mv_ver = -mv_ver;   // reverse direction
  }
  //   form
  fill(255, 0, 0);    // red
  ellipse(x, y, w, h);
}
