
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

/////////////// Escena 1 /////////////////////////////////
    cp5.addSlider("cStroke")
      .plugTo(parent,"strokeCol")
      .setRange(0, 255)
      .setPosition(10,30)
      .setSize(250,20)
      .setValue(0)
      .setLabel("Color de linea")
      ;
    strokeCol = 0;  
    
    cp5.addRadioButton("colBW")
      .setPosition(10,60)
      .setSize(60,20)
      .setItemsPerRow(3)
      .setSpacingColumn(80)
      .addItem("Blanco y negro",1)
      .addItem("Color",2)
      ;

    cp5.addSlider("strokeWeight")
      .plugTo(parent,"sWeight")
      .setRange(1, 5)
      .setPosition(10,90)
      .setSize(250,10)
      .setValue(1)
      .setLabel("Grosor de la linea")
      ;   
    sWeight = 1; 

    cp5.addSlider("displaceMagnitudeControl")
      .plugTo(parent,"displaceMagnitude")
      .setRange(1, 30)
      .setPosition(10,110)
      .setSize(250,10)
      .setValue(1)
      .setLabel("Magnitud de cambio")
      ;   
    displaceMagnitude =1;

    cp5.addBang("bang1")
      .setPosition(360, 30)
      .setSize(80, 80)
      .setLabel("Activar  Escena  1")
      ;

/////////////// Escena 2 /////////////////////////////////
    cp5.addToggle("gravityControl")
      .plugTo(parent,"gravity")
      .setPosition(10,170)
      .setSize(65,20)
      .setValue(true)
      .setLabel("Sin gravitacion")
      ;
    gravity = false;

    cp5.addToggle("linesControl")
      .plugTo(parent,"lines")
      .setPosition(95,170)
      .setSize(65,20)
      .setValue(true)
      .setLabel("Puntos o lineas")
      ;
    lines = false;

    cp5.addToggle("rejectControl")
      .plugTo(parent,"reject")
      .setPosition(180,170)
      .setSize(65,20)
      .setValue(false)
      .setLabel("Atraer o rechazar")
      ;
    reject = false;

    
    cp5.addSlider("influenceControl")
      .plugTo(parent,"influenceRadius")
      .setRange(1, 200)
      .setPosition(10,220)
      .setSize(250,10)
      .setValue(70)
      .setLabel("Radio de influencia");
    influenceRadius =70;
    
    cp5.addSlider("strokeWeightFluid")
      .plugTo(parent,"sWeightFluid")
      .setRange(1, 20)
      .setPosition(10,250)
      .setSize(250,10)
      .setValue(1)
      .setLabel("Grosor de la linea")
      ;
    sWeightFluid = 1;
    
    cp5.addSlider("lineTransparencyControl")
      .plugTo(parent,"lineTransparency")
      .setRange(1, 255)
      .setPosition(10,280)
      .setSize(250,10)
      .setValue(200)
      .setLabel("Transparencia del trazo")
      ;
    lineTransparency = 200;


    cp5.addSlider("cFondoFluid")
      .plugTo(parent,"backColFluid")
      .setRange(0, 255)
      .setPosition(10,310)
      .setSize(250,20)
      .setValue(0)
      .setLabel("Color del fondo")
      ;
    backColFluid = 0;  

    cp5.addBang("bang2")
      .setPosition(360, 165)
      .setSize(80, 80)
      .setLabel("Activar  Escena  2")
      ;  

////////////////// Escena 3//////////////////////////////
    cp5.addRadioButton("blendPhoto")
      .setPosition(10,390)
      .setSize(40,20)
      .setItemsPerRow(3)
      .setSpacingColumn(60)
      .addItem("ADD",1)
      .addItem("LIGHTEST",2)
      .addItem("EXCLUSION",3)
      .addItem("SUBTRACT",4)
      .addItem("DARKEST",5)
      .addItem("MULTIPLY",6)
      .addItem("BLEND",7)
      ;
    blendModeSelected = BLEND;

    cp5.addSlider("photoTransparencyControl")
      .plugTo(parent,"photoTransparency")
      .setRange(0, 255)
      .setPosition(10,470)
      .setSize(250,10)
      .setValue(127)
      .setLabel("Transparencia")
      ;
    photoTransparency = 127;

    cp5.addSlider("photoEasingControl")
      .plugTo(parent,"photoEasing")
      .setRange(0.01, 0.05)
      .setPosition(10,490)
      .setSize(250,10)
      .setValue(0.03)
      .setLabel("Tiempo de respuesta")
      ;
    photoEasing = 0.03;

    cp5.addBang("bang3")
      .setPosition(360, 380)
      .setSize(80, 80)
      .setLabel("Activar  Escena  3")
      ; 

/////////////////// Escena 4 /////////////////////////////
    cp5.addSlider("meTvTransparencyControl")
      .plugTo(parent,"meTvTransparency")
      .setRange(0, 255)
      .setPosition(10,560)
      .setSize(250,10)
      .setValue(127)
      .setLabel("Transparencia")
      ;
    meTvTransparency = 127;

    cp5.addButton("select picture")
     .setPosition(10,580)
     .setSize(60,30)
     .setLabel("Elegi imagen")
     ;

    cp5.addBang("bang4")
      .setPosition(360, 550)
      .setSize(80, 80)
      .setLabel("Activar  Escena  4")
      ; 

  }




  void controlEvent(ControlEvent theEvent) {
    String n = theEvent.getName();

    // Escena 1
    if( n == "colBW") {
      float v = theEvent.getValue();
      if ( v == 1 ) inColor = false;
      if ( v == 2 ) inColor = true;
    }
    if( n == "bang1") {
      manager.activate(0);
    }
    // Escena 2
    if( n == "gravityControl") {
      gravity = !gravity;
    }
    if( n == "linesControl") {
      lines = !lines;
    }
    if( n == "rejectControl") {
      reject = !reject;
    }
    if( n == "bang2") {
      manager.activate(1);
    }
    // Escena 3
    if( n == "blendPhoto") {
      float v = theEvent.getValue();
      if ( v == 1 ) blendModeSelected = ADD;
      if ( v == 2 ) blendModeSelected = LIGHTEST;
      if ( v == 3 ) blendModeSelected = EXCLUSION;
      if ( v == 4 ) blendModeSelected = SUBTRACT;
      if ( v == 5 ) blendModeSelected = DARKEST;
      if ( v == 6 ) blendModeSelected = MULTIPLY;
      if ( v == 7 ) blendModeSelected = BLEND;
    }
    if( n == "bang3") {
      manager.activate(2);
    }
    // Escena 4
    if( n == "select picture") {
      loadBackPicture();
    }
    if( n == "bang4") {
      manager.activate(3);
    }
  }

  public void draw() {
    background(0);
    fill(255);
    text("Escena 1 - Espejo de lineas",10,20);
    stroke(255,0,0);

    line(5,135,445,135);
    text("Escena 2 - Sistema de particulas",10,160);

    line(5,345,445,345);
    text("Escena 3 - Imagen desplazada",10,370);  

    line(5,515,445,515);
    text("Escena 4 - Yo en la imagen",10,540);  
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

