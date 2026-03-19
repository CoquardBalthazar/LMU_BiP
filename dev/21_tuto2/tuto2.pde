// TASK 2 Arrays
float [] x = {200, 500, 700};
float [] y = {200, 500, 700};

void setup() {
  size(800, 800);
  background(0);
}

void draw() {
  // background(0);
  //   line(mouseX, 500, pmouseX, 500);       //line between(x1, y1, x2, y2)
  //   println(mouseX + " : " + pmouseX);     // print to the console the current x and previous x

  //   // TASK 1 moving circle following mouse
  //   fill(255, 0, 0);    // red
  //   ellipse(mouseX, mouseY, 50, 50);
  //   println(mouseX + " : " + pmouseX);     // print to the console the current x and previous x

  //// TASK 2 : store positions in arrays
  //background(0);
  //for (int i = 0; i< x.length; i++) {
  //  // movement
  //  x[i] += (mouseX/10);
  //  y[i] += (mouseY/10);

  //  // form
  //  fill(255, 0, 0);    // red
  //  ellipse(x[i], y[i], 50, 50);
  //};
  //println(mouseX + " : " + pmouseX);     // print to the console the current x and previous x


  //Task 3 Loops in loops? How to draw a chessboard pattern?
  background(0);

  int squareSize = 100;


  for (int i =0; i<8; i++) {  // rows
    for (int j =0; j<8; j++) {

      if ((i+j) % 2 == 0 ) {
        fill(255); //  white
      } else {
        fill(0); // black
      }
      rect(j * squareSize, i * squareSize, squareSize, squareSize);
    }
  }
}












// Task 1 Go to: processing.org/reference
// and find commands for getting mouse-position. Change the example code from the lecture
// to display a moving circle.
// Write a sketch where a circle follows the mouse pointer.
// What else can you use the mouseX and mouseY values for?

// Task 2
// Define arrays that store x and y coordinates of multiple circles.
// Move each circle independently. Use arrays and loops to minimize code

// Task 3 Loops in loops?
// How to draw a chessboard pattern?
// Try to nest loops to iterate over 2 dimensions?

// Task 4 Try to use loops and arrays for other things in the sketch. Don't be afraid of breaking things!
