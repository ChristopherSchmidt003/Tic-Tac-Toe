import processing.net.*;

//Client

Client myClient;

color orange = #F78145;
color green  = #A0B046;
boolean itsMyTurn = false;

int [][] grid;

void setup() {
  size(300, 300);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);

  myClient = new Client(this, "127.0.0.1", 1234);
}

void draw() {
  if (itsMyTurn) background(green); else background(orange);

  //draw the dividing lines
  stroke(0);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);

  //draw the x's and o's
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++){
      drawXO(row, col);
    }
  }
  
  if (myClient.available() > 0) {
    String incoming = myClient.readString();
    int r = int (incoming.substring(0,1));
    int c = int (incoming.substring(2,3));
    grid[r][c] = 2;
    itsMyTurn = true;
  }
}

void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid[row][col] == 1) {
    fill(0);
    ellipse(50, 50, 90, 90);
  } else if (grid[row][col] == 2) {
    line(10, 10, 90, 90);
    line(90, 10, 10, 90);
  }
  popMatrix();
}

void mouseReleased() {
  //assign the clicked-on box with the crrent player's mark
  int row = mouseX/100;
  int col = mouseY/100;
  if (itsMyTurn && grid[row][col] == 0) {
    grid[row][col] = 1;
    myClient.write(row + "," + col);
    grid[row][col] = 1;
    itsMyTurn = false;
  }
}
