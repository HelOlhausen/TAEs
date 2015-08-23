
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  ColorPicker[] cp = new ColorPicker[7];
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

    cp5.addSlider("Cantidad de barras adyacentes a colorear")
      .plugTo(parent,"cantBarrasAdyacentesColoreadas")
      .setRange(0, 6)
      .setValue(6)
      .setPosition(10,10);
    cp5.addSlider("Luminosidad de Ruido")
      .plugTo(parent,"luminosidadRuido")
      .setRange(0,255)
      .setValue(255)
      .setPosition(10,30);
    cp5.addToggle("Modo invertido")
     .plugTo(parent,"modoInvertido")
     .setPosition(10,50)
     .setSize(50,20)
     .setValue(false);
    cp5.addToggle("Modo espejo")
     .plugTo(parent,"espejado")
     .setPosition(10,90)
     .setSize(50,20)
     .setValue(false);
    cp5.addToggle("Lluvia colorida")
     .plugTo(parent,"lluviaColorida")
     .setPosition(10,130)
     .setSize(50,20)
     .setValue(false);
     
    int yInicial = 20; 
    for(int i = 0; i < 7; i++)
    {      
      // Selecciono colores aleatorios iniciales
      int colorR = ((Float) random(255)).intValue();
      int colorG = ((Float) random(255)).intValue();
      int colorB = ((Float) random(255)).intValue();
      cp[i] = cp5.addColorPicker("picker" + i)
        .setPosition(320, (yInicial + 80*i))
        .setTitle("Colr de barra " + i)
        .setColorValue(color(colorR,colorG,colorB));
    }
     
      cp5.addBang("bangColores")
        .setPosition(10, 170)
        .setSize(50,20)
        .setLabel("Cambiar colores");
  }
  
  public void draw() {
    background(0);
    for(int i = 0; i < 7; i++)
    {
      color_bars[i]=cp[i].getColorValue();
      text("Color de barra " + (i + 1), 320, 17 + (i*80));
    }
    
    stroke(0,255,0);
    line(310,10,310,580);
  }
  
  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }
  public ControlP5 control() {
    return cp5;
  }
  
  void controlEvent(ControlEvent theEvent) {  
  String n = theEvent.getName();

    // Cambiar todos los colores
    if( n == "bangColores") {
      for(int i = 0; i < 7; i++)
      {        
        int colorR = ((Float) random(255)).intValue();
        int colorG = ((Float) random(255)).intValue();
        int colorB = ((Float) random(255)).intValue();
        this.cp[i].setColorValue(color(colorR, colorG, colorB));
      }
    }
  }
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

