// Screen
int screen_min_x, screen_max_x, screen_min_y, screen_max_y;

// Ball
int ball_x, ball_y, ball_w, ball_h, ball_r;
int ball_mv_hor, ball_mv_ver;

// Paddles
int paddle1_x, paddle1_y, paddle1_w, paddle1_h;
int paddle2_x, paddle2_y, paddle2_w, paddle2_h;

int paddle_mv_hor, paddle_mv_ver;
boolean wPressed, sPressed, upPressed, downPressed;

int paddle_min_x, paddle_max_x, paddle_min_y, paddle_max_y;

void setup() {
  size(1000, 1000);

  // SCREEN (Limits)
  screen_min_x = ball_r;
  screen_max_x = width-ball_r;      // width screen minus radius(keep the whole circle in the frame)

  screen_min_y = ball_r;
  screen_max_y = height-ball_r;

  // BALL : Dimensions
  ball_x = 500;      // start x, y
  ball_y = 500;
  ball_w = 30;       // dimensions
  ball_h = 30;
  ball_r = 15;       // Ball radius

  // BALL : move / speed
  ball_mv_hor = 17;  // move horizontal
  ball_mv_ver = 7;  // move vertical

  // PADDLES : Dimensions
  // Left :
  paddle1_x = 200;      // start x, y
  paddle1_w = 10;       // dimensions
  paddle1_h = 90;
  paddle1_y = (height/2)-(paddle1_h/2);

  // Right :
  paddle2_x = 800;      // start x, y
  paddle2_w = 10;       // dimensions
  paddle2_h = 90;
  paddle2_y = (height/2)-(paddle1_h/2);

  // PADDLES : Move
  paddle_mv_hor = 10;
  paddle_mv_ver = 25;
  wPressed = false;
  sPressed = false;
  upPressed = false;
  downPressed = false;

  // PADDLES : Limits
  paddle_min_x = 0;
  paddle_max_x = width;
  paddle_min_y = 0;
  paddle_max_y = height;
}

void draw() {
  background(0);

  // FIELD (Dashed line delimiter) ####################
  stroke(255);    // white
  float line_x = (width/2);
  float line_length = 10;

  for (float y = 50; y<(height-30); y+=line_length*3) {
    line(line_x, y, line_x, y+line_length);    // line(x1, y1, x2, y2)
  };


  // TO BE DELETED (Vertical Middle)
  line(0, height/2, width, height/2);

  // BALL ##################
  // Start Ball on Any Key
  //  Move
  ball_x = ball_x + ball_mv_hor;
  ball_y = ball_y + ball_mv_ver;

  // BOUNCE -------------
  //   bounce on borders
  if (ball_x > screen_max_x || ball_x < screen_min_x) {
    ball_mv_hor = -ball_mv_hor;   // reverse direction
  }
  if (ball_y > screen_max_y || ball_y < screen_min_y) {
    ball_mv_ver = -ball_mv_ver;   // reverse direction
  }

  // Bounce on paddles (check if ball in the paddle surface)
  // Left paddle
  if (ball_mv_hor < 0 && // ball coming from the right
    ball_x - ball_r <= paddle1_x + paddle1_w &&
    ball_x - ball_r >= paddle1_x &&
    ball_y >= paddle1_y &&
    ball_y <= paddle1_y + paddle1_h) {

    ball_mv_hor *= -1;
    ball_x = paddle1_x + paddle1_w + ball_r;    // set ball out of paddle
  };
  println("------------- Bounce Paddle -------------");
  println("Ball Left x :", ball_x - ball_r);
  println("Paddle Left inside x :", paddle1_x + paddle1_w);
  println("Ball Left y :", ball_y);
  println("Paddle Left lower y :", paddle1_y) ;
  println("Paddle Left upper y :", paddle1_y + paddle1_h) ;
  println("-----------------------------------------");
  
    // Right paddle
  if (ball_mv_hor > 0 &&
    ball_x + ball_r <= paddle2_x + paddle2_w &&
    ball_x + ball_r >= paddle2_x &&
    ball_y >= paddle2_y &&
    ball_y <= paddle2_y + paddle2_h) {

    ball_mv_hor *= -1;
    ball_x = paddle2_x - ball_r;
  };
  println("------------- Bounce Paddle -------------");
  println("Ball Right x :", ball_x + ball_r);
  println("Paddle Right inside x :", paddle2_x);
  println("Ball Right y :", ball_y);
  println("Paddle Right lower y :", paddle2_y) ;
  println("Paddle Right upper y :", paddle2_y + paddle2_h) ;
  println("-----------------------------------------");

  //
  //   form
  fill(255, 0, 0);    // red
  ellipse(ball_x, ball_y, ball_w, ball_h);


  // PADDLES ###############
  // Draw the paddles
  fill(0, 255, 0);  // green
  rect(paddle1_x, paddle1_y, paddle1_w, paddle1_h);        // rect(x1, y1,width, height)
  rect(paddle2_x, paddle2_y, paddle2_w, paddle2_h);

  // Move paddle (keys commands)
  // Left : "W" / "S"
  if (wPressed) {
    paddle1_y -= paddle_mv_ver;
  }
  if (sPressed) {
    paddle1_y += paddle_mv_ver;
  }

  // Right : "UP" / "DOWN"
  if (upPressed) {
    paddle2_y -= paddle_mv_ver;
  }
  if (downPressed) {
    paddle2_y += paddle_mv_ver;
  }

  // Limit Paddles
  //paddle1_x = constrain(paddle1_x, 0, width/2);    // constrain(amt, low, high)
  paddle1_y = constrain(paddle1_y, 0, (height-(paddle1_h)));
  //paddle2_x = constrain(paddle2_x, 0, width/2);
  paddle2_y = constrain(paddle2_y, 0, (height-(paddle2_h)));
}


// PADDLE : Move
void keyPressed() {
  if (key == 'w' || key == 'W') {
    wPressed = true;
  }
  if (key == 's' || key == 'S') {
    sPressed = true;
  }

  if (key == CODED) {
    if (keyCode == UP) {
      upPressed = true;
    }
    if (keyCode == DOWN) {
      downPressed = true;
    }
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    wPressed = false;
  }
  if (key == 's' || key == 'S') {
    sPressed = false;
  }

  if (key == CODED) {
    if (keyCode == UP) {
      upPressed = false;
    }
    if (keyCode == DOWN) {
      downPressed = false;
    }
  }
}


// Ball out of screenswsw
// Score
// Ball movement starts only on key press
