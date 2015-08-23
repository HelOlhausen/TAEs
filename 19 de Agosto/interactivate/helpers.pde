
void defaultModes(){
  rectMode(CORNER);
  imageMode(CORNER);
  ellipseMode(CENTER);
}

void resetDancers(){
  dPos= new PVector();
  hasDancers = false;
}

PVector getCoMPosition(){
  PVector com = new PVector();                                   
  PVector com2d = new PVector(); 

  hasDancers = false;

  context.update();
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);

      if(com2d.z != 0){
        // rescalamos la data que se ajustaba a 640x480 no a nuestro proyector 1024x768
        com2d.x = map(com2d.x,0,640,0,1024);
        com2d.y = map(com2d.y,0,480,0,768);
        hasDancers = true;
        return com2d;
      }
    }
  }
  return new PVector(0, 0);
}

void loadBackPicture(){
  selectInput("Elegi archivo:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Ventana fue cerrada o el usuario apreto cancelar.");
  } else {
    println("Usuario selecciono " + selection.getAbsolutePath());
    backPic = loadImage(selection.getAbsolutePath());
  }
}