import punktiert.math.Vec;
import punktiert.physics.*;
import SimpleOpenNI.*;

//Parametros para usuarios
SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0), color(0,255,0), color(0,0,255),
                                     color(255,255,0), color(255,0,255), color(0,255,255)}; 
PVector com = new PVector();                                   
PVector com2d = new PVector(); 

//Mundo Fisico
VPhysics physics;
//Gravedad
BConstantForce gravedad;
float g =9.8;
//Fuerzas de atraccion
//BAttraction attrH;
BAttraction attrH;
//BAttraction attrCdM;
BAttraction attrMD;
BAttraction attrMI;
//Colicion
BCollision colicion;
//Parametros de las particulas
float radio = 5;
float peso = 10;
float posibilidadExistencia = 0.005;
float posibilidadCreacionEspontanea = 0.00000;
//Vector para guardar valores del esqueleto
PVector jointPos = new PVector();
public void setup() {
  //Creo pantalla
  size(1024,768);
  //Inicializo el contexto
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
  
  //Doy color a las lineas
  stroke(0,0,255);
  //Ensancho las lineas
  strokeWeight(3);
  //Dibujo mas suavemente
  smooth();
  //Dejo de dibujar los bordes
  noStroke();

  //Creo el mundo y lo doto de friccion
  physics = new VPhysics(/*width,height*/);
  physics.setfriction(.1f);
  
  //Creo y agrego una gravedad al Mundo 
  //gravedad = new BConstantForce(new Vec(0, g).normalizeTo(.03f));
  //physics.addBehavior(gravedad);
  
  //Creo y agrego tres nuevas fuerzas de atraccion
  // new AttractionForce: (Vec pos, radius, strength)
  //attrCdM = new BAttraction(new Vec(width * .5f, height * .5f), 100, .5f);
  attrMD = new BAttraction(new Vec(width * .5f, height * .5f), 50, .5f);
  attrMI = new BAttraction(new Vec(width * .5f, height * .5f), 50, .5f);
  //physics.addBehavior(attrCdM);
  physics.addBehavior(attrMD);
  physics.addBehavior(attrMI);
  //Creo pelotitas
  for (int x=0; x<width; x++){
    for(int y=0; y<height; y++){
      if (random(0,1)<posibilidadExistencia){
        crearParticula(x, y);
      };
    }  
  }
}

public void draw() {
  //Fondo blanco
  background(0);
  // update the cam
  context.update();
  scale(1.6);
  // draw depthImageMap
  //image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
      atraerAlUsuario(userList[i]);
      haduken (userList[i]);
    }      
      
    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(1);
      beginShape(LINES);
        vertex(com2d.x,com2d.y - 5);
        vertex(com2d.x,com2d.y + 5);

        vertex(com2d.x - 5,com2d.y);
        vertex(com2d.x + 5,com2d.y);
      endShape();
      
      fill(0,255,100);
      text(Integer.toString(userList[i]),com2d.x,com2d.y);
    }
  }    
  
  //Creo o NO una particuloa en un lugar random por encima de la pantalla
  if (random(0,1)>posibilidadCreacionEspontanea){
    crearParticula((int) random(0,width), (int) random(0, height));
  };
  //Updeteo la fisica
  physics.update();
  //Dejo de dibujar los rellenos
  noFill();
  //Dibujo los bordes en rojo
  stroke(200, 0, 0);
  
  //Dibujo el radio de la FdA CdM
  //ellipse(attrCdM.getAttractor().x, attrCdM.getAttractor().y, attrCdM.getRadius(), attrCdM.getRadius());
  //Dibujo el radio de la FdA MD
  ellipse(attrMD.getAttractor().x, attrMD.getAttractor().y, attrMD.getRadius(), attrMD.getRadius());
  //Dibujo el radio de la FdA MI
  ellipse(attrMI.getAttractor().x, attrMI.getAttractor().y, attrMI.getRadius(), attrMI.getRadius());

  //Dejo de dibujar los bordes
  noStroke();
  //Vuelvo a dibujar los rellenos
  fill(255, 255,255, 220);
  //Dibujo cada particula
  for (VParticle p : physics.particles) {
    ellipse(p.x, p.y, p.getRadius() * 2, p.getRadius() * 2);
  }

}

public void crearParticula (int x , int y){
  //Creo un vector con la posicion asignada
  Vec pos = new Vec(x,y);
  //Creo la particula en la posicion pedida con el radio y el parametrizados
  VParticle particle = new VParticle(pos, peso, radio);
  //Creo comportamiento de colicion
  colicion = new BCollision();
  //Agrego Colicion
  particle.addBehavior(colicion);
  //Agrego la particula al mundo
  physics.addParticle(particle);
}

//Funcion para dar al usuario poder de atraccion
void atraerAlUsuario(int userId){
  // Seteo las fuerzas de atraccion hacia el CdM, mano izquierda y Mano Derecha de cada usuario
  //Seteo la FdA para el CdM
  //attrCdM.setAttractor(new Vec(com2d.x,com2d.y));
  //Obtengo las coordenadas de la MD
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND ,jointPos);
  //Corrijo  los valores
  context.convertRealWorldToProjective(jointPos,jointPos);
  //Seteo la FdA de la MD
  attrMD.setAttractor(new Vec(jointPos.x, jointPos.y));
  //Obtengo las coordenadas de la MI
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND ,jointPos);
  //Corrijo  los valores
  context.convertRealWorldToProjective(jointPos,jointPos);
  //Seteo la FdA de la MI
  attrMI.setAttractor(new Vec(jointPos.x, jointPos.y));
}

//Funcion para dar al usuario poder KameHameHaaa
void haduken (int userId){
  PVector mD = new PVector();
  PVector mI= new PVector();
  PVector pHI= new PVector();
  if (true/*MANOS SE TOCAN*/){
     //Obtengo las coordenadas de la MD
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND ,mD);
    //Corrijo  los valores
    context.convertRealWorldToProjective(mD,mD);
    //Obtengo las coordenadas de la MI
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND ,mI);
    //Corrijo  los valores
    context.convertRealWorldToProjective(mI,mI);
    //Seteo la fHI
    pHI.x= (mD.x+mI.x)/2;
    pHI.y= (mD.y+mI.y)/2;
    println("Punto Inicial del Haduken del usuario "+ userId+" : "+ pHI.x + "," + pHI.y);
    stroke(0,200,0);
    fill(0,200,0);
    ellipse(pHI.x, pHI.y, 10,10);
    
    ///SEGUIR ACA!!!!!!!!!!
  }
 
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  
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


