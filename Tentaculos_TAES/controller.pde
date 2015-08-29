
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  ColorPicker[] cp = new ColorPicker[7];
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

    cp5.addSlider("Largo de segmento")
      .plugTo(parent,"segLength")
      .setRange(3, 35)
      .setPosition(10,10);
    cp5.addSlider("Cantidad de segmentos")
      .plugTo(parent,"numSegments")
      .setRange(3, 10)
      .setPosition(10,20);
    cp5.addToggle("DibujarEsqueleto")
        .setPosition(10, 50)
        .plugTo(parent,"draw_Skeleton")
        .setLabel("Dibujar esqueleto");
    cp5.addToggle("DibujarUsuario")
        .setPosition(10, 100)
        .plugTo(parent,"draw_User")
        .setLabel("Dibujar Usuario");
    // Selecciono colores aleatorios iniciales
    cp[1] = cp5.addColorPicker("picker")
      .setPosition(10, 150)
      .setTitle("Color de tentaculo")
      .setColorValue(color(255,255,255,200));
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
