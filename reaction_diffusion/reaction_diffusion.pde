// readction diffusion

// default settings: dA=1.0, dB=0.5, f=0.055, k=0.062
// experiment_1: dA=1.0, dB=0.5, f=0.01, k=0.05
// experiment_2: dA=1.0, dB=0.5, f=0.056, k=0.061
// experiment_3: dA=1.0, dB=0.6, f=0.02, k=0.05
// experiment_4: dA=1.0, dB=0.445; f=0.05, k=0.066;

float dA = 0.5;
float dB = 0.25;
float f = 0.0432;
float k = 0.06;
float t = 1.0;
int blobs = 10;

String folder = "out1";
String name = "reaction_diffusion";
int zeros = 4;
int saveEveryNth = 25; 

Cell[][] grid;
Cell[][] prev;
int loop = 0;
int number = 0;

void setup() {
  size(500, 500);
  grid = new Cell[width][height];
  prev = new Cell[width][height];
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j ++) {
      float a = 1;
      float b = 0;
      grid[i][j] = new Cell(a, b);
      prev[i][j] = new Cell(a, b);
    }
  }

  for (int n = 0; n < blobs; n++) {
    int startx = int(random(20, width-20));
    int starty = int(random(20, height-20));

    for (int i = startx; i < startx+10; i++) {
      for (int j = starty; j < starty+10; j ++) {
        float a = 1;
        float b = 1;
        grid[i][j] = new Cell(a, b);
        prev[i][j] = new Cell(a, b);
      }
    }
  }
}
class Cell {
  float a;
  float b;
  Cell(float a_, float b_) {
    a = a_;
    b = b_;
  }
}
void update() {
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {
      Cell spot = prev[i][j];
      Cell newspot = grid[i][j];
      float a = spot.a;
      float b = spot.b;
      float laplaceA = 0;
      laplaceA += a*-1;
      laplaceA += prev[i+1][j].a*0.2;
      laplaceA += prev[i-1][j].a*0.2;
      laplaceA += prev[i][j+1].a*0.2;
      laplaceA += prev[i][j-1].a*0.2;
      laplaceA += prev[i-1][j-1].a*0.05;
      laplaceA += prev[i+1][j-1].a*0.05;
      laplaceA += prev[i-1][j+1].a*0.05;
      laplaceA += prev[i+1][j+1].a*0.05;
      float laplaceB = 0;
      laplaceB += b*-1;
      laplaceB += prev[i+1][j].b*0.2;
      laplaceB += prev[i-1][j].b*0.2;
      laplaceB += prev[i][j+1].b*0.2;
      laplaceB += prev[i][j-1].b*0.2;
      laplaceB += prev[i-1][j-1].b*0.05;
      laplaceB += prev[i+1][j-1].b*0.05;
      laplaceB += prev[i-1][j+1].b*0.05;
      laplaceB += prev[i+1][j+1].b*0.05;
      newspot.a = a + (dA*laplaceA - a*b*b + f*(1-a))*t;
      newspot.b = b + (dB*laplaceB + a*b*b - (k+f)*b)*t;
      newspot.a = constrain(newspot.a, 0, 1);
      newspot.b = constrain(newspot.b, 0, 1);
    }
  }
}
void swap() {
  Cell[][] temp = prev;
  prev = grid;
  grid = temp;
}
void draw() {
  //println(frameRate);
  for (int i = 0; i < 1; i++) {
    update();
    swap();
  }
  loadPixels();
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {
      Cell spot = grid[i][j];
      float a = spot.a;
      float b = spot.b;
      int pos = i + j * width;
      pixels[pos] = color((a-b)*255);
    }
  }
  updatePixels();
  number = loop / saveEveryNth;
  if (loop%saveEveryNth==0) {
    saveFrame(folder+"/"+name+"_"+nf(number,zeros)+".jpg");
  } 
  loop += 1;  
}