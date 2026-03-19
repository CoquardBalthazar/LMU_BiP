int x, y;

void setup() {
  size(1000, 1000);  // Screen size(width, height)
  background(0);    // black backgroudn
  x = 500;          // beginning x value
  y = 500;           // beginning y value
}

void draw() {
  background(0);               // set background to black color
  x = x-1;                     // implement x+1 continously until the end of the program(as a loop)
  y -= 1;
  fill(255, 0, 0);    // red

  // LOOP MANAGEMENT functions ##########################
  // noLoop();                  // code inside draw does not run --> rectangle is fix at the given position
  // redraw();                    //  the code inside draw() to run a single time
  // loop();                      //  to resume running continuously

  // DRAW FORMS ##############################
  //   rect(x, y, 100, 100);      // draws a rectangle at x, y, wigth, height
  //   noFill();         // disable fill
  fill(0,0,255);        // blue
  //   circle(x, 100, 50);            // x, y, width/height
  ellipse(x, y, 50, 50);        // x, y, width, height

  // FILL THE SHAPES - RGB color mode
  //   By default Processing uses RGB color mode with values from 0 to 255.
  //   fill(255);          // white
  //   fill(0);            // black
  //   fill(0, 255, 0);    // green
  //   fill(0, 0, 255);    // blue
  //   If you want transparency, you can also use alpha:
  // fill(255, 0, 0, 128);   // semi-transparent red
}
// Tutorial 1
// 1 - Change form rect to circle / ellipse
// 2 - contrary direction
// 3 - Change the direction of the movement from horizontally to vertically.
// 4 - Try to use variables for other values in the sketch. Don't be afraid of breaking things!
