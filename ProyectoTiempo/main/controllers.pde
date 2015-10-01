public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  CheckBox checkbox;
  ColorPicker cp_fondo1, cp_sombra1;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    
/////////////// Escena 1 - Gravedad /////////////////////////////////
    cp5.addBang("bang1")
      .setPosition(10, 40)
      .setSize(40, 15)
      .setLabel("Activar  Escena  1")
      ;
      
    checkbox = cp5.addCheckBox("checkbox")
      .setPosition(10,30)
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
      .setPosition(10, 130)
      .setValue(false)
      .plugTo(parent,"dibujarEsqueleto")
      .setLabel("Dibujar esqueleto");              
  
         
    cp5.addToggle("Radio variable")
      .setPosition(10, 180)
      .setValue(false)
      .plugTo(parent,"radioVariable")
      .setLabel("Radio variable");   
     
    cp5.addToggle("Radio Epileptico")
      .setPosition(10, 220)
      .setValue(false)
      .plugTo(parent,"radioEpileptico")
      .setLabel("Radio epileptico");  
         
    cp5.addSlider("Radio de particulas")
      .plugTo(parent,"radio")
      .setRange(3, 15)
      .setValue(radio)
      .setPosition(10,260);
      
    cp5.addSlider("Radio de atraccion")
      .plugTo(parent,"radioFuerza")
      .setRange(0, 100)
      .setValue(100)
      .setPosition(10,280);    
     
    cp5.addSlider("Generacion espontanea de particulas")
      .setPosition(10, 320)
      .setValue(5)
      .setRange(0,100)
      .plugTo(parent,"posibilidadCreacionEspontanea")
      .setLabel("Generacion espontanea de particulas");    
     
     cp5.addToggle("Dibujar radios de atraccion")
      .setPosition(10, 350)
      .setValue(false)
      .plugTo(parent,"dibujarRadios")
      .setLabel("Dibujar radios de atraccion");    
      
      
    cp5.addSlider("Direccion gravedad X")
      .setPosition(10, 400)
      .setValue(0)
      .setRange(-10,10)
      .plugTo(parent,"direccionGravedadX")
      .setLabel("Direccion Gravedad X");  
      
    cp5.addSlider("Direccion gravedad Y")
      .setPosition(10, 430)
      .setValue(0)
      .setRange(-10,10)
      .plugTo(parent,"direccionGravedadY")
      .setLabel("Direccion Gravedad Y");  
      
    cp5.addSlider("Particulas por frame")
      .setPosition(10, 480)
      .setValue(5)
      .setRange(1,50)
      .plugTo(parent,"particulasPorFrame")
      .setLabel("Particulas por frame");  
      
    cp5.addBang("eliminarParticulas")
      .setPosition(10, 510)
      .setSize(50,20)
      .setLabel("Borrar particulas");

/////////////// Escena 2 - Tunel del Tiempo /////////////////////////////////
    cp5.addBang("bang2")
      .setPosition(330, 40)
      .setSize(40, 15)
      .setLabel("Activar  Escena  2")
      ;

    cp_fondo1 = cp5.addColorPicker("colorFondo")
                .setPosition(330,90)
                .setTitle("Color de fondo")
                .setColorValue(color(50,0,50));
    cp_sombra1 = cp5.addColorPicker("colorSombra")
                .setPosition(330,170)
                .setTitle("Color de sombra")
                .setColorValue(color(192,0,192));
                
    cp5.addToggle("Movimiento horizontal")
        .setPosition(330,250)
        .plugTo(parent, "mover_lineas_hacia_arriba")
        .setLabel("Movimiento horizontal");

    cp5.addToggle("Movimiento vertical")
        .setPosition(330,300)
        .plugTo(parent, "mover_lineas_hacia_derecha")
        .setLabel("Movimiento vertical");
        
    cp5.addBang("bangInvertir")
    .setPosition(330,340)
    .setSize(50,20)
    .setLabel("Invertir Vertical/Horizontal");
    
    cp5.addSlider("Velocidad")
      .plugTo(parent,"velocidad")
      .setRange(-10,10)
      .setValue(6)
      .setPosition(330,400);
    
    cp5.addToggle("serPantalla")
        .setPosition(330,420)
        .plugTo(parent, "serPantalla")
        .setLabel("serPantalla");
  

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
    
    // Invertir Verticar/Horizontal
    if(n=="bangInvertir"){
        mover_lineas_hacia_arriba = ! mover_lineas_hacia_arriba;
        mover_lineas_hacia_derecha = ! mover_lineas_hacia_derecha;
    }
    if( n == "bang1") {
      manager.activate(0);
    }
    if( n == "bang2") {
      manager.activate(1);
    }
    
  }

  public void draw() {
    background(0);
    fill(255);
    text("Escena 1 - Gravedad",10,20);
    text("Escena 2 - Tunel del Tiempo",330,20);
    text("Color de fondo", 330, 84);
    text("Color de sombra", 330, 164);
    stroke(0,255,0); 
    line(320,10, 320, height -10);
    
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
