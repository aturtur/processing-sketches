// change these
String name = "noise";
String format = ".jpg";
int zeros = 4;
int firstFrame = 0;
int lastFrame = 125;
int totalFrames = 126;

float darkness = 12;
int re_width = 40;
int re_height = 40;

// don't touch these
PFont font;
char[] ramp = new char[40];
int currentIndex = firstFrame;
PImage[] images = new PImage[totalFrames];
void setup() {
  size(400,400); // change this
  background(255);
  font = loadFont("Courier-12.vlw");
  textFont(font, 12);
  textAlign(CENTER);
  for (int i = firstFrame; i <= lastFrame; i ++ ) {
    images[i-firstFrame] = loadImage(name+nf(i,zeros)+format);
  } 
  ramp[0] = 'M';
  ramp[1] = '@';
  ramp[2] = 'W';
  ramp[3] = 'B';
  ramp[4] = '0';
  ramp[5] = '8';
  ramp[6] = 'Z';
  ramp[7] = 'a';
  ramp[8] = '2';
  ramp[9] = 'S';
  ramp[10] = 'X';
  ramp[11] = '7';
  ramp[12] = 'r';
  ramp[13] = 'i';
  ramp[14] = '*';
  ramp[15] = ';';
  ramp[16] = ':';
  ramp[17] = ',';
  ramp[18] = '.';
  ramp[19] = ' ';  
}

void draw() {
  background(255);
  int gap = 10;
  translate(gap,gap);
  fill(0);
  
  if (currentIndex == lastFrame){
    exit();
  }
    
  for(int i = 0; i < re_height; i++) {
    for(int j = 0; j < re_width; j++) {
      images[currentIndex-firstFrame].resize(re_width, re_height);
      color c = images[currentIndex-firstFrame].get(j, i);
      char dot = ramp[int(brightness(c)/darkness)];
      text(dot, j * gap, i * gap);
    }
  }
  saveFrame("ascii_"+nf(currentIndex, zeros)+".jpg");
  currentIndex += 1;
}