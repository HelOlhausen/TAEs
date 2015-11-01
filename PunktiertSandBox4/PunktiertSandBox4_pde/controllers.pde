public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  CheckBox checkbox;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

    checkbox = cp5.addCheckBox("checkbox")
      .setPosition(10,10)
      .setSize(20,20)
      .setItemsPerRow(2)
      .setSpacingRow(10)   
      .setSpacingColumn(70)   
      .addItem("Cabeza", 0)
      .addItem("Mano izquierda", 0)
      .addItem("Mano derecha", 0)
      .addItem("Caderas", 0)
      .addItem("Pie izquierdo", 0)
      .addItem("Pie derecho", 0);
        
    cp5.addToggle("Dibujar esqueleto")
      .setPosition(10, 110)
      .setValue(false)
      .plugTo(parent,"dibujarEsqueleto")
      .setLabel("Dibujar esqueleto");              
  
         
    cp5.addToggle("Radio variable")
      .setPosition(10, 160)
      .setValue(false)
      .plugTo(parent,"radioVariable")
      .setLabel("Radio variable");   
     
    cp5.addToggle("Radio Epileptico")
      .setPosition(10, 200)
      .setValue(false)
      .plugTo(parent,"radioEpileptico")
      .setLabel("Radio epileptico");  
         
    cp5.addSlider("Radio de particulas")
      .plugTo(parent,"radio")
      .setRange(3, 15)
      .setValue(radio)
      .setPosition(220,10);
      
    cp5.addSlider("Radio de atraccion")
      .plugTo(parent,"radioFuerza")
      .setRange(0, 100)
      .setValue(100)
      .setPosition(220,40);    
     
    cp5.addSlider("Generacion espontanea de particulas")
      .setPosition(220, 80)
      .setValue(0)
      .setRange(0,100)
      .plugTo(parent,"posibilidadCreacionEspontanea")
      .setLabel("Generacion espontanea de particulas");    
     
     cp5.addToggle("Dibujar radios de atraccion")
      .setPosition(220, 110)
      .setValue(false)
      .plugTo(parent,"dibujarRadios")
      .setLabel("Dibujar radios de atraccion");    
      
      
    cp5.addSlider("Direccion gravedad X")
      .setPosition(220, 160)
      .setValue(0)
      .setRange(-10,10)
      .plugTo(parent,"direccionGravedadX")
      .setLabel("Direccion Gravedad X");  
      
    cp5.addSlider("Direccion gravedad Y")
      .setPosition(220, 190)
      .setValue(0)
      .setRange(-10,10)
      .plugTo(parent,"direccionGravedadY")
      .setLabel("Direccion Gravedad Y");  
      
    cp5.addSlider("Particulas por frame")
      .setPosition(220, 240)
      .setValue(5)
      .setRange(1,50)
      .plugTo(parent,"particulasPorFrame")
      .setLabel("Particulas por frame");  
      
    cp5.addBang("eliminarParticulas")
      .setPosition(220, 270)
      .setSize(50,20)
      .setLabel("Borrar particulas");
       
       
  }
  
  public void draw() {
    background(0);
  }
  
  void dropdown(int n) {
    /* request the selected item based on index n */
    println(n, cp5.get(ScrollableList.class, "direccionParticulas").getItem(n));
    
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
    
    // Eliminar particulas
    if( n == "eliminarParticulas") {
      borrarParticulas = true;
    }
    
    // Cambio en las checkbox
    if( n == "checkbox"){
      float[] v = theEvent.getArrayValue();
      for(int i = 0; i < 6; i++)
      {
        partesDelCuerpo[i] = v[i] == 1;
      }    
    } // end cambio en checkbox
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
