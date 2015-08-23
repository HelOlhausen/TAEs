class MoveImg implements Scene
{   
  float offset = 0;
  PImage bg;

  public MoveImg(){};

  void closeScene(){
    noTint();
  };

  void initialScene(){
    noStroke();
    bg = loadImage("testcard.png");
  };

  void drawScene(){
    dPos = getCoMPosition();
    // si no hay usuarios, la imagen volvera al centro
    if(!hasDancers) dPos = new PVector(width/2,height/2);
    
    image(bg, 0, 0); 
    // los controladores definen que tipo de mezcla de colores se ejecutara
    blendMode(blendModeSelected); 
    float dx = (dPos.x-bg.width/2) - offset;
    offset += dx * photoEasing; 
    // la transparencia de la segunda imagen la controla el slider conectado con la variable photoTransparency
    tint(255, photoTransparency);  
    image(bg, offset, 0);
    blendMode(REPLACE); 
  };

  String getSceneName(){return "MoveImg";};

}
