class Fluid implements Scene
{   
  // en total 1500 particulas
  int particleCount = 1500;
  Particle[] particles = new Particle[particleCount];

  public Fluid(){};

  void closeScene(){};
  void initialScene(){
    reject = true;
    for (int i = 0; i < particleCount; i++) { 
      particles[i] = new Particle();
    }
  };
  void drawScene(){
    blendMode(BLEND);
    background(backColFluid);

    // buscamos al usuario
    dPos = getCoMPosition();
    // definimos color del fondo y del trazo
    fill(backColFluid);
    stroke (255 - backColFluid);
    // definimos el grosor del trazo
    strokeWeight(sWeightFluid);
    // actualizamos las posiciones de las particulas
    for (int i = 0; i < particleCount; i++) { 
      Particle particle = (Particle) particles[i];
      particle.update(i);
    }
  };
  String getSceneName(){return "Fluid";};

  class Particle {
    // coordenada x,y
    float x;
    float y;
    // velocidad en eje x y y
    float vx;
    float vy; 
    // se incia en una posicion randomin=ca en la pantalla
    Particle() {
      x = random(10,width-10);
      y = random(10,height-10);
    }
    // devuelve la posicion x
    float getx() {
      return x; 
    }
    // devuelve la posicion y
    float gety() {
      return y;
    }
    void update(int num) {
      // simulamos la friccion
      vx *= 0.84;
      vy *= 0.84;
      // Loopeamos para checkear la influencia entre si de las particulas
      for (int i = 0; i < particleCount; i++) { 
        // i = num no nos interesa porque seria calcular influencia de uno a uno mismo
        if (i != num) { 
          // para definir si dibujamos la linea o no
          boolean drawthis = false;
          // particula vecina
          Particle particle = (Particle) particles[i];
          float tx = particle.getx();
          float ty = particle.gety();
          // la distancia entre la particula actual y la particula vecina
          float radius = dist(x,y,tx,ty);
          // las lineas las dibujamos solo entre las particulas en radio menor de 35 
          if (radius < 35) { 
            drawthis = true; 
            // el angulo para poder dibujar la linea
            float angle = atan2(y-ty,x-tx);
            // si esta muy cerca - se desvia
            if (radius < 30) {
              // cambiamos las velocidades
              vx += (30 - radius) * 0.07 * cos(angle);
              vy += (30 - radius) * 0.07 * sin(angle);
             }
             if (radius > 25) { 
               // si estan entre 25 y 30 se acercan
               vx -= (25 - radius) * 0.005 * cos(angle);
               vy -= (25 - radius) * 0.005 * sin(angle);
             }
          }
          // si dibujamos lineas y deberiamos dibujar - dibujamos!
          if (lines) {
            if (drawthis) {
               stroke(255-backColFluid,lineTransparency);
               line(x,y,tx,ty);
            }
          }
        }
      }
      // aca consideramos la influencia del usuario
      if (hasDancers) {
        // la posicion del usuario
        float tx = dPos.x;
        float ty = dPos.y;
        float radius = dist(x,y,tx,ty);
        if (radius < influenceRadius) {
          float angle = atan2(ty-y,tx-x);
          // atraemos o rebotamos?
          if (reject) {
            // rebotamos
            vx -= radius * 0.07 * cos(angle);
            vy -= radius * 0.07 * sin(angle);
          }
          else {
            // atraemos
            vx += radius * 0.07 * cos(angle);
            vy += radius * 0.07 * sin(angle); 
          }
        }
      }   
      /* Previox x and y coordinates are set, for drawing the trail */
      int px = (int)x;
      int py = (int)y;
      // actualizamos las coordenadas de la particula
      x += vx;
      y += vy;
      // aplicamos la gravedad
      if (gravity == true) vy += 0.7;
      // rebotamos contra los bordes
      if (x > width-10) {
        if (abs(vx) == vx) vx *= -1.0;
        x = width-10;
      }
      if (x < 10) {
        if (abs(vx) != vx) vx *= -1.0;
        x = 11;
      }
      if (y < 10) {
        if (abs(vy) != vy) vy *= -1.0;
        y = 10;
      }
      if (y > height-10) {
        if (abs(vy) == vy) vy *= -1.0;
        vx *= 0.6;
        y = height-10;
      }
      // si no dibujamos lineas, dibujamos particulas
      if (!lines) {
        stroke (255 - backColFluid,lineTransparency);
        line(px,py,int(x),int(y));
      }
    }
  }  
}