class SceneManager{

  Scene[] scenes;  
  Scene actualScene;
  int actualSceneNr;

  SceneManager(){

    Scene [] allScenes = {        
      new TunelTiempo()
    };

    scenes =allScenes;
    actualSceneNr = 0;
    scenes[0].initialScene();
    actualScene = scenes[0];
  }

  void activateNextScene(){
    int sceneNr = (actualSceneNr+1)%(scenes.length);
    activate(sceneNr);
  }

  void activatePrevScene(){
    int sceneNr;
    if(actualSceneNr-1 < 0) sceneNr = scenes.length -1;
    else sceneNr = (actualSceneNr-1)%(scenes.length);
    activate(sceneNr);
  }

  void activate(int sceneNr){
    stopDraw = true;
    actualSceneNr = sceneNr;
    actualScene.closeScene();
    actualScene = scenes[sceneNr];
    actualScene.initialScene();
    println(sceneNr,actualScene.getSceneName());
    stopDraw = false;
  }
}


// Escena
interface Scene
{ 
    void initialScene();
    void drawScene();
    void closeScene();
    String getSceneName();
}

class Example implements Scene
{   
  public Example(){};

  void closeScene(){};
  void initialScene(){};
  void drawScene(){};
  String getSceneName(){return "Example";};

}
