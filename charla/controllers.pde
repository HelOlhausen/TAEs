public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  CheckBox checkbox;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

  }
  
  public void draw() {
    background(0);
  }
  
  void dropdown(int n) {
    
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
    
    
  } // end controlEvent
  
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

