/**
 * Reach 2  
 * based on code from Keith Peters.
 * 
 * The arm follows the position of the mouse by
 * calculating the angles with atan2(). 
 */
 
import SimpleOpenNI.*;

SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };



int numSegments = 10;
float segLength = 26;

// Variables para definir el tentaculo izquierdo
float[] xIzq = new float[numSegments];
float[] yIzq = new float[numSegments];
float[] angleIzq = new float[numSegments];
float targetXIzq, targetYIzq;

// Variables para definir el tentaculo derecho
float[] xDer = new float[numSegments];
float[] yDer = new float[numSegments];
float[] angleDer = new float[numSegments];
float targetXDer, targetYDer;

void setup() {
  size(640, 360);
  strokeWeight(20.0);
  stroke(255, 100);
  xIzq[xIzq.length-1] = width/7;     // Set base x-coordinate
  yIzq[xIzq.length-1] = height;  // Set base y-coordinate
  
  xDer[xDer.length-1] = width - width/7;     // Set base x-coordinate
  yDer[xDer.length-1] = height;  // Set base y-coordinate
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();
}

void draw() {
  background(0);
  
  // update the cam
  context.update();
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    } 
  }
  
  // Dibujamos tentaculo izquierdo
  reachSegmentIzq(0, mouseX, mouseY);
  for(int i=1; i<numSegments; i++) {
    reachSegmentIzq(i, targetXIzq, targetYIzq);
  }
  for(int i=xIzq.length-1; i>=1; i--) {
    positionSegmentIzq(i, i-1);  
  } 
  for(int i=0; i<xIzq.length; i++) {
    segment(xIzq[i], yIzq[i], angleIzq[i], (i+1)*2); 
  }
  
  
  // Dibujamos tentaculo derecho
  reachSegmentDer(0, mouseX, mouseY);
  for(int i=1; i<numSegments; i++) {
    reachSegmentDer(i, targetXDer, targetYDer);
  }
  for(int i=xDer.length-1; i>=1; i--) {
    positionSegmentDer(i, i-1);  
  } 
  for(int i=0; i<xDer.length; i++) {
    segment(xDer[i], yDer[i], angleDer[i], (i+1)*2); 
  }
}

// Funciones tentaculo izquierdo
void positionSegmentIzq(int a, int b) {
  xIzq[b] = xIzq[a] + cos(angleIzq[a]) * segLength;
  yIzq[b] = yIzq[a] + sin(angleIzq[a]) * segLength; 
}

void reachSegmentIzq(int i, float xin, float yin) {
  float dx = xin - xIzq[i];
  float dy = yin - yIzq[i];
  angleIzq[i] = atan2(dy, dx);  
  targetXIzq = xin - cos(angleIzq[i]) * segLength;
  targetYIzq = yin - sin(angleIzq[i]) * segLength;
}


// Funciones tentaculo derecho
void positionSegmentDer(int a, int b) {
  xDer[b] = xDer[a] + cos(angleDer[a]) * segLength;
  yDer[b] = yDer[a] + sin(angleDer[a]) * segLength; 
}

void reachSegmentDer(int i, float xin, float yin) {
  float dx = xin - xDer[i];
  float dy = yin - yDer[i];
  angleDer[i] = atan2(dy, dx);  
  targetXDer = xin - cos(angleDer[i]) * segLength;
  targetYDer = yin - sin(angleDer[i]) * segLength;
}

////////////

void segment(float x, float y, float a, float sw) {
  strokeWeight(sw);
  pushMatrix();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  popMatrix();
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
}  

