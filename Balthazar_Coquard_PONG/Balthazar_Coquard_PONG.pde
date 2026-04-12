


// Welcome/Gaming Screen
int GAME_STATE_WELCOME = 0;
int GAME_STATE_PLAYING = 1;

int gameState = GAME_STATE_WELCOME;
String leftKeyboardLayout = "";

// Instances
Paddle leftPaddle;
Paddle rightPaddle;
Ball ball;

// Scores
int scoreLeft = 0;
int scoreRight = 0;

// Features : shrinking paddles && increase ball speed
int rallyHits = 0;

// Constant variables
float BALL_BASE_SPEED = 8.0;
float BALL_SPEED_STEP = 0.35;
float BALL_MAX_SPEED = 18.0;
float PADDLE_BASE_HEIGHT = 120.0;
float PADDLE_MIN_HEIGHT = 55.0;
float PADDLE_SHRINK_STEP = 3.0;



void setup() {
  size(1000, 1000);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);

  // DISPLAY  - Line && Game Instructions ############
  drawCenterLine();

  if (gameState == GAME_STATE_WELCOME) {
    drawWelcomeScreen();
    return;
  }

  // DISPLAY - Scores #########################
  displayScore();

  // POSITION - Ball && Paddles ####################
  leftPaddle.updatePosition();
  rightPaddle.updatePosition();
  ball.updatePosition();
  
  // BOUNCE && COLLISIONS ###############
  ball.checkWallCollision();  // Up/Down
  checkPaddleCollisions();  // Left/Right
  updateScore();

  // DISPLAY -  Ball && Paddles ###############
  leftPaddle.display();
  rightPaddle.display();
  ball.display();
  
  // DISPLAY -  Serve logic ###############
  drawServeMessage();
}

void initializeMatch() {
  //Paddle(float x, float y, float w, float h, float mv_hor, float mv_ver)
  leftPaddle = new Paddle(width * 0.1, height * 0.5 - PADDLE_BASE_HEIGHT * 0.5, 12, PADDLE_BASE_HEIGHT, 8, 8);
  rightPaddle = new Paddle(width * 0.9 - 12, height * 0.5 - PADDLE_BASE_HEIGHT * 0.5, 12, PADDLE_BASE_HEIGHT, 8, 8);

  // Left paddle stays in left half, right paddle in right half.
  leftPaddle.setBounds(0, width * 0.5 - leftPaddle.w, 0, height - leftPaddle.h);
  rightPaddle.setBounds(width * 0.5, width - rightPaddle.w, 0, height - rightPaddle.h);

  // Feature : Keyborad layout
  configureLeftKeyboard(leftKeyboardLayout);    // Left keys
  rightPaddle.setCodedKeys(UP, DOWN, LEFT, RIGHT);  // Right keys

  ball = new Ball(width * 0.5, height / 3.0, 30, BALL_BASE_SPEED);
  ball.resetBall();
}


void configureLeftKeyboard(String layout) {
  if (layout.equals("AZERTY")) {
    leftPaddle.setCharKeys('z', 's', 'q', 'd');
  } else {
    leftPaddle.setCharKeys('w', 's', 'a', 'd');
  }
}

void keyPressed() {
  if (gameState == GAME_STATE_WELCOME) {
    if (key == 'q' || key == 'Q') {
      leftKeyboardLayout = "QWERTY";
      gameState = GAME_STATE_PLAYING;
      initializeMatch();
    } else if (key == 'a' || key == 'A') {
      leftKeyboardLayout = "AZERTY";
      gameState = GAME_STATE_PLAYING;
      initializeMatch();
    }
    return;
  }

  if (ball.waitingForServe && key == ' ') {
    ball.startServe();
  }

  leftPaddle.handleKey(keyCode, key == CODED, key, true);
  rightPaddle.handleKey(keyCode, key == CODED, key, true);
}

void keyReleased() {
  if (gameState != GAME_STATE_PLAYING) {
    return;
  }
  // .handleKey(int keyCodeValue = keyCode, boolean isCoded = yes/no, char keyValue = key, boolean pressed = false)
  // Left Paddle control
  leftPaddle.handleKey(keyCode, key == CODED, key, false);

  // Right Paddle control
  rightPaddle.handleKey(keyCode, key == CODED, key, false);
}


void checkPaddleCollisions() {
  // Ball coming from right (mv_hor == -)-> left paddle
  if (ball.mv_hor < 0 && isBallOverlappingPaddle(ball, leftPaddle)) {
    resolvePaddleBounce(leftPaddle, true);
  }
  // Ball coming from left (mv_hor ==+) -> right paddle
  if (ball.mv_hor > 0 && isBallOverlappingPaddle(ball, rightPaddle)) {
    resolvePaddleBounce(rightPaddle, false);
  }
}

boolean isBallOverlappingPaddle(Ball b, Paddle p) {
  // Check is ball inside the paddle
  return b.x + b.r >= p.x &&
    b.x - b.r <= p.x + p.w &&
    b.y + b.r >= p.y &&
    b.y - b.r <= p.y + p.h;
}


void resolvePaddleBounce(Paddle paddle, boolean isLeftPaddle) {
  // Offset = distance from paddle center(normalised)
  // above center → negative
  // below center → positive
  float offset = (ball.y - (paddle.y + paddle.h * 0.5)) / (paddle.h * 0.5);
  offset = constrain(offset, -1, 1);  // avoid weird cases
  if (isLeftPaddle) {
    println("Left paddle collision, offset = " + offset);
  } else {
    println("Right paddle collision, offset = " + offset);
  }

  // Ball : reposition ball out of paddle (avoid getting stuck)
  if (isLeftPaddle) {
    ball.x = paddle.x + paddle.w + ball.r;
  } else {
    ball.x = paddle.x - ball.r;
  }

  // Feature : Speed increase (x-axis)
  float newSpeed = ball.increaseSpeed(BALL_SPEED_STEP, BALL_MAX_SPEED);    // update BaseSpeed

  // Bouncing angle (y-axis)
  float newVelocityY = offset * (newSpeed * 0.9);    // offset controls the angle

  // Minimum vertical speed -> Improved gameplay
  if (abs(newVelocityY) < 5) {
    newVelocityY = (newVelocityY < 0 ? -3 : 3);
  }

  // Ball : set new values

  ball.mv_hor = (isLeftPaddle ? 1 : -1) * abs(newSpeed);// Horizontal
  ball.mv_ver = newVelocityY;

  // Increment rally && ShrinkPaddle
  rallyHits++;
  applyRallyDifficulty();
}

void applyRallyDifficulty() {
  // Feature : Shrink Paddle Size
  float targetHeight = max(PADDLE_MIN_HEIGHT, PADDLE_BASE_HEIGHT - rallyHits * PADDLE_SHRINK_STEP);
  leftPaddle.setHeight(targetHeight);
  rightPaddle.setHeight(targetHeight);

  // Feature : Ball Speed
}


void updateScore() {
  // SCORE - Exit ball(update) -------------
  if (ball.x + ball.r< 0) {
    // Exit ball Left
    scoreRight++;
    resetAfterPoint();
  } else if (ball.x + ball.r > width) {
    // Exit ball Right
    scoreLeft++;
    resetAfterPoint();
  }
}

void resetAfterPoint() {
  // Feature
  rallyHits = 0;

  // reset paddles
  leftPaddle.setHeight(PADDLE_BASE_HEIGHT);
  rightPaddle.setHeight(PADDLE_BASE_HEIGHT);

  // reset ball : baseSpeed, centered and waitintForServe
  ball.baseSpeed = BALL_BASE_SPEED;
  ball.resetBall();
}

void drawCenterLine() {
  // FIELD(Dashed line delimiter) ####################
  stroke(255);    // white
  float line_x =(width*0.5);
  float line_length = 10;

  for (float y = 50; y<(height-30); y+=line_length*3) {
    line(line_x, y, line_x, y+line_length);    // line(x1, y1, x2, y2)
  }
  noStroke();
}

void drawWelcomeScreen() {
  fill(255);
  textSize(56);
  // Text positioning from up to down
  text("PONG", width * 0.5, height * 0.22);

  textSize(24);
  text("Choose left player keyboard layout", width * 0.5, height * 0.40);
  text("Press Q for QWERTY (W/S/A/D)", width * 0.5, height * 0.48);
  text("Press A for AZERTY (Z/S/Q/D)", width * 0.5, height * 0.54);

  textSize(18);
  text("Right player uses arrow keys (UP/DOWN/LEFT/RIGHT)", width * 0.5, height * 0.64);
  text("Press SPACE to serve after selection", width * 0.5, height * 0.69);
}

void drawServeMessage() {
  // Start Message

  if (ball.waitingForServe) {
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(255);
    text("Press SPACE to start", width*0.5, height*0.5);
  }
}


void displayScore() {
  // Score - Display
  //textFont("Arial");
  textAlign(CENTER, CENTER);    // position text relative to given x and y
  textSize(height/6);
  fill(128);  // grey / blue =(0, 0, 255)
  text(scoreLeft, width*0.25, height*0.12);    //text(str, x1, y1, x2, y2) replaced through(center,center)
  text(scoreRight, width*0.75, height*0.12);
}


public class Element {
  // Fields
  float x;    // x-position
  float y;    // y-position
  float w;    // width
  float h;    // height

  float mv_hor;    // horizontal movement
  float mv_ver;    // horizontal movement

  // Constructor

  Element(float x, float y, float w, float h, float mv_hor, float mv_ver) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.mv_hor = mv_hor;
    this.mv_ver = mv_ver;
  }

  // Method(Generic)

  void updatePosition() {
    x += mv_hor;
    y += mv_ver;
  }
}
;

public class Ball extends Element {
  // Fields
  float r;    // radius

  boolean waitingForServe = true;
  float baseSpeed;

  float offset = 0;    // offset for collision

  Ball(float x, float y, float diameter, float baseSpeed) {
    super(x, y, diameter, diameter, 0, 0);
    this.r = diameter * 0.5;
    this.baseSpeed = baseSpeed;
  }
  // Methods

  @Override
    void updatePosition() {
    if (!waitingForServe) {
      x += mv_hor;
      y += mv_ver;
    }
  }

  void display() {
    fill(255, 0, 0);    // red
    ellipse(x, y, w, h);
  }

  void resetBall() {
    x = width * 0.5;
    y = height / 3.0;

    mv_hor = 0;
    mv_ver = 0;

    waitingForServe = true;
  }

  void startServe() {
    waitingForServe = false;

    // Move : Horizontal
    // Random : Left / Right
    if (random(1) < 0.5) {
      mv_hor = baseSpeed;
    } else {
      mv_hor = -baseSpeed;
    }
    // Move : Vertical
    // Random : Angle between -8 and 8
    mv_ver = int(random(-8, 9));
    if (abs(mv_ver) < 0) {
      mv_ver = 5;
    }
  }


  void checkWallCollision() {
    // bounce on upper / down borders
    if (y - r <= 0) {
      y = r;
      mv_ver *= -1;
    } else if (y + r >= height) {
      y = height - r;
      mv_ver *= -1;
    }
  }

  float increaseSpeed(float speedStep, float maxSpeed) {
    baseSpeed = min(maxSpeed, baseSpeed + speedStep);
    return baseSpeed;
  }
}
public class Paddle extends Element {
  // key state
  boolean upPressed = false;
  boolean downPressed = false;
  boolean leftPressed = false;
  boolean rightPressed = false;

  // key mapping [Feature : QWERTY && AZERTY Logic]
  char upChar = 0;
  char downChar = 0;
  char leftChar = 0;
  char rightChar = 0;

  int upCode = 0; // setup for coded keys
  int downCode = 0;
  int leftCode = 0;
  int rightCode = 0;
  boolean useCodedKeys = false;

  float minX;
  float maxX;
  float minY;
  float maxY;

  // Constructor

  Paddle(float x, float y, float w, float h, float mv_hor, float mv_ver) {
    super(x, y, w, h, mv_hor, mv_ver);  // from Elements
    setBounds(0, width - w, 0, height - h);
  }
  void setBounds(float minX, float maxX, float minY, float maxY) {
    // Control the emplacement of the paddle in the screen (Left side vs Right Side)
    this.minX = minX;
    this.maxX = maxX;
    this.minY = minY;
    this.maxY = maxY;
    x = constrain(x, minX, maxX);
    y = constrain(y, minY, maxY);
  }

  void setCharKeys(char up, char down, char left, char right) {
    // Get the char strings to lowerCase
    upChar = Character.toLowerCase(up);
    downChar = Character.toLowerCase(down);
    leftChar = Character.toLowerCase(left);
    rightChar = Character.toLowerCase(right);
    useCodedKeys = false;
  }


  void setCodedKeys(int up, int down, int left, int right) {
    upCode = up;
    downCode = down;
    leftCode = left;
    rightCode = right;
    useCodedKeys = true;
  }

  void handleKey(int keyCodeValue, boolean isCoded, char keyValue, boolean pressed) {
    // Handle Coded Keys
    if (useCodedKeys) {
      if (isCoded) {
        if (keyCodeValue == upCode) {
          upPressed = pressed;
        }
        if (keyCodeValue == downCode) {
          downPressed = pressed;
        }
        if (keyCodeValue == leftCode) {
          leftPressed = pressed;
        }
        if (keyCodeValue == rightCode) {
          rightPressed = pressed;
        }
      }
      // Handle Character Keys
    } else {
      char k = Character.toLowerCase(keyValue);
      if (k == upChar) {
        upPressed = pressed;
      }
      if (k == downChar) {
        downPressed = pressed;
      }
      if (k == leftChar) {
        leftPressed = pressed;
      }
      if (k == rightChar) {
        rightPressed = pressed;
      }
    }
  }

  @Override void updatePosition() {
    // Move paddle(keys commands)

    if (upPressed) {
      y -= mv_ver;
    }

    if (downPressed) {
      y += mv_ver;
    }

    if (leftPressed) {
      x -= mv_hor;
    }

    if (rightPressed) {
      x += mv_hor;
    }
    // Limit Paddles
    x = constrain(x, minX, maxX);
    y = constrain(y, minY, maxY); // constrain(amt, low, high)
  }

  void setHeight(float newHeight) {
    // Feature : Shrinking paddle
    float oldHeight = h;
    h = newHeight;
    // Keep paddle center stable while shrinking.
    y = y + (oldHeight - h) * 0.5;
    setBounds(minX, maxX, minY, maxY);
  }

  void display() {
    fill(0, 255, 0);  // green
    rect(x, y, w, h);        // rect(x1, y1,width, height)
  }
}
