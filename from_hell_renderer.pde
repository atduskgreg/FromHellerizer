import monclubelec.javacvPro.*;

PImage img, original;
PGraphics hash;
PImage hashImg;
PImage[] hatchLevels;
int hatchSpacing = 7;

ArrayList<Path> paths;
ArrayList<Vehicle> vehicles;
boolean debug = false;

HatchLayer[] hatchLayers;

OpenCV opencv;

void setup() {
  original = loadImage("hand_profile.jpg");
  size(original.width*2, original.height, P2D);
  
  
  opencv = new OpenCV(this);
  opencv.allocate(original.width, original.height);
  opencv.copy(original);
  // run a canny edge filter
  opencv.canny(1000, 2000, 5);
  // invert for black lines
  opencv.invert();

  background(255);

  img = createImage(original.width, original.height, RGB);
  hash = createGraphics(original.width, original.height, P2D);
  hashImg = createImage(original.width, original.height, ARGB);

  hatchLayers = new HatchLayer[5];
  for(int i = 0; i < hatchLayers.length; i++){
    hatchLayers[i] = new HatchLayer(original.width, original.height, hatchSpacing, i);
  }

  hatchLevels = new PImage[5];

  for (int i = 0; i < hatchLevels.length; i++) {
    hatchLevels[i] = createImage(original.width, original.height, RGB);
    
    println("processing level: " + i);

    hatchLevels[i].loadPixels();
    for (int p = 0; p < original.pixels.length; p ++) {
      if (inRangeForLevel(original.pixels[p], i)) {
        hatchLevels[i].pixels[p] = color(255);
      } 
      else {
        hatchLevels[i].pixels[p] = color(0);
      }
    }
    hatchLevels[i].updatePixels();


    println("done processing pixels, drawing");

//    hash.beginDraw();
//    hash.background(255, 255);
//    hatchToDarkness(4-i, hatchSpacing);
//    hash.endDraw();
//    hash.updatePixels();

   

    //println("displaying image");
   // image(hashImg, 0, 0);
  }
  println("here");


  image(original, img.width, 0);

  // draw the edges on top
  //blendMode(DARKEST);
  //image(opencv.getBuffer(), 0, 0);
}

boolean inRangeForLevel(int pixel, int i) {
  if (i == 0 ) {
    return(brightness(pixel) < 40);
  }
  else if (i == 1) {
    return(brightness(pixel) >= 40 && brightness(pixel) < 100);
  } 
  else if (i == 2) {
    return(brightness(pixel) >= 100 && brightness(pixel) < 140);
  } 
  else if (i == 3) {
    return(brightness(pixel) >= 140 && brightness(pixel) < 180);
  }
  else {
    return(brightness(pixel) >= 180 && brightness(pixel) < 255);
  }
}

void draw() {
  background(255);

  strokeWeight(0.2);
  for(int i = 0; i < hatchLayers.length; i++){
    hatchLayers[i].draw();
    //image(hatchLayers[i].canvas, 0,0);
    hashImg = hatchLayers[i].canvas.get();
    hashImg.mask(hatchLevels[4-i]);
    image(hashImg,0,0);
 }
   // draw the edges on top
  blendMode(DARKEST);
  image(opencv.getBuffer(), 0, 0);
 
 image(original, original.width, 0);
}
