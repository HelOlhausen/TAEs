class MeTv implements Scene
{   
  PImage bImg; 
  public MeTv(){};

  void closeScene(){};
  void initialScene(){};
  void drawScene(){
    blendMode(BLEND);
    fill(0,meTvTransparency);
    rect(0, 0, width, height);
    bImg = getMeImg();
    image(bImg,0,0);
  };
  String getSceneName(){return "MeTv";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

  PImage getMeImg(){
    // para imagen de la kinect
    PImage img = new PImage(context.depthWidth(),context.depthHeight(),ARGB); 
    img.loadPixels();
    // para imagen escalada
    PImage bigImg = new PImage(width,height,ARGB); 
    bigImg.loadPixels();

    context.update();
    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap();

    int index;
    for(int x=0;x <context.depthWidth();x+=1)
    {
      for(int y=0;y < context.depthHeight() ;y+=1)
      {
        index = x + y * context.depthWidth();
        int d = depthMap[index];
        // si no hay usuarios
        // ponemos un pixel transparente
        img.pixels[index] = backPic.pixels[index];
        if(d>0){
          int userNr =userMap[index];
          if( userNr > 0)
          { 
            // si esta un usuario cargamos img con el valor del pixel
            // de la backPic
            img.pixels[index] = color(255,255);
          }
        }
      }
    }
    img.updatePixels(); 
    // escalamos las imagenes
    bigImg.copy(img, 0, 0, 640, 480, 0, 0, width, height);
    return bigImg;
  }

}
