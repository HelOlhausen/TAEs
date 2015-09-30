import punktiert.math.Vec;
import punktiert.physics.*;
import java.util.ArrayList;

class Gravedad implements Scene
{
  //Mundo Fisico
  VPhysics physics;  
  //Gravedad
  BConstantForce gravedad;
  float g =0.1;
  Vec direccion = new Vec (0,0);  
  //Fuerzas de atraccion
  //BAttraction attrH;
  BAttraction attrC;
  BAttraction attrMI;
  BAttraction attrMD;
  BAttraction attrCdr;
  BAttraction attrPI;
  BAttraction attrPD;
  //Constantes de la fuerzas
  int radioFuerza=  50;
  Float poderFuerza= .5f;    
  //Colicion
  BCollision colicion;  
  float peso = 10;
  float posibilidadExistencia = 0.0025;  
  //Vector para guardar valores del esqueleto
  PVector jointPos = new PVector();
  PVector jointPos2 = new PVector();
  
  color[]       userClr = new color[]{ color(255,0,0), color(0,255,0), color(0,0,255),
                                     color(255,255,0), color(255,0,255), color(0,255,255)};
  
  void closeScene(){};
  
  void initialScene(){
    //Doy color a las lineas
    stroke(0,0,255);
    //Ensancho las lineas
    strokeWeight(3);
    //Dibujo mas suavemente
    smooth();
    //Dejo de dibujar los bordes
    noStroke();
  
    //Creo el mundo y lo doto de friccion
    physics = new VPhysics();
    physics.setfriction(.1f);
    
    //Creo y agrego una gravedad al Mundo 
    gravedad = new BConstantForce(direccion);
    physics.addBehavior(gravedad);
    
    //Creo y agrego tres nuevas fuerzas de atraccion
    // new AttractionForce: (Vec pos, radius, strength)
    attrC = new BAttraction(new Vec(width * .5f, height * .5f), radioFuerza, poderFuerza);
    attrMI = new BAttraction(new Vec(width * .5f, height * .5f), radioFuerza, poderFuerza);
    attrMD = new BAttraction(new Vec(width * .5f, height * .5f), radioFuerza, poderFuerza);
    attrCdr = new BAttraction(new Vec(width * .5f, height * .5f), radioFuerza, poderFuerza);
    attrPI = new BAttraction(new Vec(width * .5f, height * .5f), radioFuerza, poderFuerza);
    attrPD = new BAttraction(new Vec(width * .5f, height * .5f), radioFuerza, poderFuerza);
  
    physics.addBehavior(attrC);
    physics.addBehavior(attrMI);
    physics.addBehavior(attrMD);
    physics.addBehavior(attrCdr);  
    physics.addBehavior(attrPI);
    physics.addBehavior(attrPD);
  };
  
  void drawScene(){
      //Fondo blanco
    background(0);
    // update the cam
    //context.update();
    scale(1.6);
    
    // Borramos las particulas si el boton fue presionado
    if(borrarParticulas)
    {
      physics= new  VPhysics();
      borrarParticulas = false;
      physics.addBehavior(attrC);
      physics.addBehavior(attrMI);
      physics.addBehavior(attrMD);
      physics.addBehavior(attrCdr);  
      physics.addBehavior(attrPI);
      physics.addBehavior(attrPD);
      physics.addBehavior(gravedad);
    }
        
    // draw the skeleton if it's available
//    int[] userList = context.getUsers();
//    for(int i=0;i<userList.length;i++)
//    {
//      if(context.isTrackingSkeleton(userList[i]))
//      {
//        stroke(userClr[ (userList[i] - 1) % userClr.length ] );
//        atraerAlUsuario(userList[i]);
//      } 
//    }    
    
    // Creo las nuevas particulas
    for (int i = 0; i < particulasPorFrame; i++)
    {
      //Creo o NO una particuloa en un lugar random por encima de la pantalla
      if (random(0,100)<posibilidadCreacionEspontanea){
        crearParticula((int) random(0,width), (int) random(0, height));
      };
    }
    //Corrijo la gravedad
    gravedad.setForce( new Vec ( -(direccionGravedadX/ 10), -(direccionGravedadY/ 10) ) );
    
    //Updeteo la fisica
    physics.update();
    //Dejo de dibujar los rellenos
    noFill();
    //Dibujo los bordes en rojo
    stroke(200, 0, 0);
  
    //Dejo de dibujar los bordes
    noStroke();
    //Vuelvo a dibujar los rellenos
    fill(255, 255,255, 220);
    //Dibujo cada particula
    for (VParticle p : physics.particles) {
      float radioRandom = p.getRadius();
      if(radioEpileptico)
      {
         radioRandom = random (0 , p.getRadius());
      }
      ellipse(p.x, p.y, radioRandom, radioRandom);
    }
  }
  
  
  String getSceneName(){return "Gravedad";};
  
  // Funciones auxiliares
    public void crearParticula (int x , int y){
    float radioParticula;
    //Creo un vector con la posicion asignada
    Vec pos = new Vec(x,y);
    if(radioVariable){
      radioParticula = random(0, radio);
    }else{
      radioParticula = radio;
    }
    
    //Creo la particula en la posicion pedida con el radio y el parametrizados
    VParticle particle = new VParticle(pos, peso, radioParticula);
    //Creo comportamiento de colicion
    colicion = new BCollision();
    //Agrego Colicion
    particle.addBehavior(colicion);
    //Agrego la particula al mundo
    physics.addParticle(particle);
  }
  
  //Funcion para dar al usuario poder de atraccion
  void atraerAlUsuario(int userId){
    //Dejo de dibujar los rellenos
    noFill();
    //Dibujo los bordes en rojo
    stroke(200, 0, 0);
    
    //Dibujo el radio de la FdA CdM
    //ellipse(attrCdM.getAttractor().x, attrCdM.getAttractor().y, attrCdM.getRadius(), attrCdM.getRadius());
    
    
    //Chequeo si se debe agregar una FdA a la cabeza
    if(partesDelCuerpo[0]){
      //Obtengo las coordenadas de la Cabeza
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD ,jointPos);
      //Corrijo  los valores
      context.convertRealWorldToProjective(jointPos,jointPos);
      //Seteo la FdA de la Cabeza
      attrC.setAttractor(new Vec(jointPos.x, jointPos.y));
      attrC.setRadius(radioFuerza);
      attrC.setStrength(poderFuerza);
      //Dibujo el radio de la FdA C
      if (dibujarRadios){
        ellipse(attrC.getAttractor().x, attrC.getAttractor().y, attrC.getRadius(), attrC.getRadius());
      }
    } else{
      attrC.setRadius(0);
      attrC.setStrength(0);
    }
    
    //Chequeo si se debe agregar una FdA a la MI
    if(partesDelCuerpo[1]){
      //Obtengo las coordenadas de la MI
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND ,jointPos);
      //Corrijo  los valores
      context.convertRealWorldToProjective(jointPos,jointPos);
      //Seteo la FdA de la MI
      attrMI.setAttractor(new Vec(jointPos.x, jointPos.y));
      attrMI.setRadius(radioFuerza);
      attrMI.setStrength(poderFuerza);
      //Dibujo el radio de la FdA MI
      if (dibujarRadios){
        ellipse(attrMI.getAttractor().x, attrMI.getAttractor().y, attrMI.getRadius(), attrMI.getRadius());
      }
    }else{
      attrMI.setRadius(0);
      attrMI.setStrength(0);
    }
    
    //Chequeo si se debe agregar una FdA a la MD
    if(partesDelCuerpo[2]){
      //Obtengo las coordenadas de la MD
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND ,jointPos);
      //Corrijo  los valores
      context.convertRealWorldToProjective(jointPos,jointPos);
      //Seteo la FdA de la MD
      attrMD.setAttractor(new Vec(jointPos.x, jointPos.y));
      attrMD.setRadius(radioFuerza);
      attrMD.setStrength(poderFuerza);
      //Dibujo el radio de la FdA MD
      if (dibujarRadios){
        ellipse(attrMD.getAttractor().x, attrMD.getAttractor().y, attrMD.getRadius(), attrMD.getRadius());
      }
    }else{
      attrMD.setRadius(0);
      attrMD.setStrength(0);
    }
    //Chequeo si se debe agregar una FdA a la Cdr
    if(partesDelCuerpo[3]){
      //Obtengo las coordenadas de la Cdr
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP ,jointPos);
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP ,jointPos2);
      //Corrijo  los valores
      context.convertRealWorldToProjective(jointPos,jointPos);
      context.convertRealWorldToProjective(jointPos2,jointPos2);
      //Seteo la FdA de la Cdr
      attrCdr.setAttractor(new Vec((jointPos.x + jointPos2.x)/2, (jointPos.y + jointPos2.y)/2));
      attrCdr.setRadius(radioFuerza);
      attrCdr.setStrength(poderFuerza);
      //Dibujo el radio de la FdA Cdr
      if (dibujarRadios){
        ellipse(attrCdr.getAttractor().x, attrCdr.getAttractor().y, attrCdr.getRadius(), attrCdr.getRadius());
      }
    }else{
      attrCdr.setRadius(0);
      attrCdr.setStrength(0);
    }
    //Chequeo si se debe agregar una FdA a la PI
    if(partesDelCuerpo[4]){
      //Obtengo las coordenadas de la PI
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT ,jointPos);
      //Corrijo  los valores
      context.convertRealWorldToProjective(jointPos,jointPos);
      //Seteo la FdA de la PI
      attrPI.setAttractor(new Vec(jointPos.x, jointPos.y));
      attrPI.setRadius(radioFuerza);
      attrPI.setStrength(poderFuerza);
      //Dibujo el radio de la FdA PI
      if (dibujarRadios){
        ellipse(attrPI.getAttractor().x, attrPI.getAttractor().y, attrPI.getRadius(), attrPI.getRadius());
      }
    }else{
      attrPI.setRadius(0);
      attrPI.setStrength(0);
    }
    if(partesDelCuerpo[5]){
      //Obtengo las coordenadas de la PD
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT ,jointPos);
      //Corrijo  los valores
      context.convertRealWorldToProjective(jointPos,jointPos);
      //Seteo la FdA de la PD
      attrPD.setAttractor(new Vec(jointPos.x, jointPos.y));
      attrPD.setRadius(radioFuerza);
      attrPD.setStrength(poderFuerza);
      //Dibujo el radio de la FdA PD
      if (dibujarRadios){
        ellipse(attrPD.getAttractor().x, attrPD.getAttractor().y, attrPD.getRadius(), attrPD.getRadius());
      }
    }else{
      attrPD.setRadius(0);
      attrPD.setStrength(0);
    }
  
  }
  
}
