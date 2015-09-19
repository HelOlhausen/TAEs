public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  ColorPicker cp_fondo1, cp_sombra1;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

/////////////// Escena 1 - Tunel del Tiempo /////////////////////////////////
    cp_fondo1 = cp5.addColorPicker("colorFondo")
                .setPosition(10,40)
                .setTitle("Color de fondo")
                .setColorValue(color(50,0,50));
    cp_sombra1 = cp5.addColorPicker("colorSombra")
                .setPosition(10,120)
                .setTitle("Color de sombra")
                .setColorValue(color(192,0,192));

  }
  
  void controlEvent(ControlEvent theEvent) {
    String n = theEvent.getName();
  }

  public void draw() {
    background(0);
    fill(255);
    text("Escena 1 - Tunel del Tiempo",10,20);
    text("Color de fondo", 10, 34);
    text("Color de fondo", 10, 114);
    stroke(0,255,0); 
    
    fondo1 = cp_fondo1.getColorValue();
    sombra1 = cp_sombra1.getColorValue();
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
