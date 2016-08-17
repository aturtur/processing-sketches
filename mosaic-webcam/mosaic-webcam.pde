import processing.video.*;

Capture video;
PImage img;
int Size = 10;

void setup() {
  size(640,480);
  String[] cameras = Capture.list();
  ellipseMode(CORNER);
  video = new Capture(this, cameras[1]);
  video.start();
}

void draw() {
  if (video.available() == true) {
    video.read();
  }
  image(video, 0, 0);
  //filter(GRAY);
  img = get(0,0,640,480);
  background(0);
  
  int sy = 0; 
  for (int i = 0; i < height; i+=Size){
    int sx = 0;
    for (int j = 0; j < width; j+=Size) {
      color c = img.get(sx,sy);
      //noStroke();
      fill(c);
      ellipse(sx,sy,Size,Size);
      sx += Size;
    }
    sy += Size;
  }
}
