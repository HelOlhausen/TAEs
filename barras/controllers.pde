public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  ColorPicker[] cp = new ColorPicker[7];
  CheckBox checkbox;
  
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

    checkbox = cp5.addCheckBox("checkbox")
      .setPosition(10,50)
      .setSize(20,20)
      .setItemsPerRow(1)
      .setSpacingRow(20)
      .addItem("Modo invertido", 0)
      .addItem("Modo espejo", 0)
      .addItem("Lluvia colorida", 0);
     
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
        
      cp5.addToggle("multiBarra")
        .setPosition(10, 220)
        .plugTo(parent,"multiBarra")
        .setLabel("Modo Multi-Barra");
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
    
    // Cambio en las checkbox
    if( n == "checkbox"){
      float[] v = theEvent.getArrayValue();
      println(v);
      modoInvertido  = v[0] == 1;
      espejado       = v[1] == 1;
      lluviaColorida = v[2] == 1;      
    }
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
