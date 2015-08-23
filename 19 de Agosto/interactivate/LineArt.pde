class LineArt implements Scene
{   
  float theta;
  public LineArt(){};

  void closeScene(){};
  void initialScene(){
    theta=0;
    colorMode(HSB,255);
  };
  void drawScene(){
    theta+=.1;
    // en color = fondo negro y lineas de color
    if(inColor) {
      background(0,0,0);
      stroke(strokeCol,255,255);
    }
    // escala de grises para el fondo y trazo
    else {
      background(0,0,strokeCol);
      stroke(0,0,255 - strokeCol);
    }
    noFill();

    pushMatrix();
      scale(1.6);
      translate(-(width - context.depthWidth()), 0);

      context.update();
      int[] u = context.userMap();
      for(int y =0; y<context.depthHeight();y+=6){
        // dibujamos la linea
        beginShape();
        // el grosor de la linea
        strokeWeight(sWeight);
        for(int x =0; x<context.depthWidth();x+=1){
          int i= y*context.depthWidth() + x;
          if(u[i]==0){
            // desplazamiento de alto
            // fondo se mueve
            vertex(width-x, y-displaceMagnitude*cos(theta));
          }else {
            // usuario queda fijo
            vertex(width-x, y);
          }
        }
        endShape();
      }
    popMatrix();
  };
  String getSceneName(){return "LineArt";};
}