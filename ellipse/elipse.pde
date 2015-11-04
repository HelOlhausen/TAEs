/**
 * Alpha Mask. 
 * 
 * Loads a "mask" for an image to specify the transparency 
 * in different parts of the image. The two images are blended
 * together using the mask() method of PImage. 
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="moonwalk.jpg,mask.jpg"; */ 

PImage img;
PImage imgMask;
PGraphics mask;
float radio;

void setup() {
  size(640, 360);
  img = loadImage("moonwalk.jpg");
  imgMask = loadImage("mask.jpg");
  //img.mask(imgMask);
  mask = createGraphics(width, height);
  imageMode(CENTER);
  radio =300;
}

void draw() {
  mask = createGraphics(width, height);
  mask.beginDraw();
  
  
 // mask.ellipse(mouseX, mouseY, radio, radio);
  for(int i=1; i<101; i++){
     mask.noStroke();
     mask.fill(i*3);
     mask.ellipse(mouseX, mouseY, radio/i, radio/i*2); 
     mask.ellipse(mouseX +  width/2, mouseY, radio/i, radio/i*2); 
  }
  mask.endDraw();
  background(0, 0, 0);
  image(img, width/2, height/2);
  img.mask(mask);
}

void mouseClicked(){
  radio = radio * 1.1;  
}
