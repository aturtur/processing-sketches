// tracks brightest pixel from webcam and sends that position via OSC
import processing.video.*;
import oscP5.*;
import netP5.*;
Capture video;
OscP5 osc;
NetAddress myBroadcastLocation; 

color trackColor; 
float threshold = 25;

void setup() {
  size(640, 480);
  osc = new OscP5(this,6449);
  myBroadcastLocation = new NetAddress("127.0.0.1",32000);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[1]);
  video.start();
  trackColor = color(255, 255, 255);
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 80;

  float avgX = 0;
  float avgY = 0;

  int count = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {
        stroke(255);
        strokeWeight(1);
        point(x, y);
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }

  if (count > 0) { 
    avgX = avgX / count;
    avgY = avgY / count;
    // Draw a circle at the tracked pixel
    fill(255);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avgX, avgY, 24, 24);
    send(avgX, avgY);
  }
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}

void send(float x, float y) {
    OscMessage myOscMessage = new OscMessage("track");
    myOscMessage.add(x);
    myOscMessage.add(-y);
    osc.send(myOscMessage, myBroadcastLocation);
}