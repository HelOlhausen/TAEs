
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
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
  }
  public void draw() {
    background(0);
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
