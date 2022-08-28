import hypermedia.net.*;
import br.campinas.redrawing.MessageManager;
import br.campinas.redrawing.data.BodyPose;
import br.campinas.redrawing.data.BodyVel;
import br.campinas.redrawing.data.Gesture;
import processing.sound.*;
import java.lang.reflect.*;

public enum RabiscoState
{
  DRAW, EDIT;
}

public class RabiscoMain
{
  public Cube cubo;
  private InputManager inputManager;
  
  private GestureIcon oneIcon, twoIcon, threeIcon, okIcon, fistIcon;
  
  private String soundMode = "pottery";//"pottery","games", "embodie", "piano"
  
  private boolean blackBackground = true;
  
  private boolean drawMode = true;

  public RabiscoMain(InputManager inputManager)
  {
    this.inputManager = inputManager;
    this.cubo = new Cube(new PVector(), false, width);
    
    oneIcon = new GestureIcon(new PVector(width-170, 20),  "one.png");
    twoIcon = new GestureIcon(new PVector(width-170, 20),  "two.png");
    threeIcon = new GestureIcon(new PVector(width-170, 20),  "three.png");
    okIcon = new GestureIcon(new PVector(width-170, 20),  "ok.png");
    fistIcon = new GestureIcon(new PVector(width-170, 20), "fist.png");

    loadSound(soundMode);
    configDraw();
  }
  
  public void setBlackBackground(boolean blackBackground)
  {
    this.blackBackground = blackBackground;
  }

  public void configDraw()
  {  
    println("draw mode");
    drawMode = true;
    
    oneIcon.hide();
    twoIcon.hide();
    threeIcon.hide();
    okIcon.hide();
    fistIcon.hide();
    
    inputManager.clearCommands();
    
    Method pointerMethod = null;

    try
    {
      pointerMethod = cubo.getClass().getMethod("setPointer", PVector.class);
    }
    catch(Exception e)
    {
      println("ERRO");
    }
    
    PointerCommand pointerCommand = new PointerCommand(cubo, pointerMethod);

    if (inputManager.haveInput(BodyInputID.WRIST_L))
    {
      inputManager.addCommand(BodyInputID.WRIST_L, pointerCommand);
    } 
    else if (inputManager.haveInput(MouseInputID.POINTER))
    {
      inputManager.addCommand(MouseInputID.POINTER, pointerCommand);
    }          
  }
  
  public void configEdit()
  {
    println("edit mode");
    drawMode = false;
    
    oneIcon.show();
    twoIcon.show();
    threeIcon.show();
    okIcon.show();
    fistIcon.show();
    
    inputManager.clearCommands();

    Method lineMethod = null;
    Method circleMethod = null;
    Method squareMethod = null;

    Method rDownMethod = null;
    Method rLeftMethod = null;

    Method oneLoadingMethod = null;
    Method twoLoadingMethod = null;
    Method threeLoadingMethod = null;
    Method okLoadingMethod = null;
    Method fistLoadingMethod = null;
    
    Method drawModeMethod = null;
    
    try
    {
      lineMethod = cubo.getClass().getMethod("lineStroke");
      circleMethod = cubo.getClass().getMethod("circleStroke");
      squareMethod = cubo.getClass().getMethod("squareStroke");

      rDownMethod = cubo.getClass().getMethod("rotateDown");
      rLeftMethod = cubo.getClass().getMethod("rotateLeft");

      oneLoadingMethod = oneIcon.getClass().getMethod("setLoading", Float.TYPE);
      twoLoadingMethod = twoIcon.getClass().getMethod("setLoading", Float.TYPE);
      threeLoadingMethod = threeIcon.getClass().getMethod("setLoading", Float.TYPE);
      okLoadingMethod = okIcon.getClass().getMethod("setLoading", Float.TYPE);
      fistLoadingMethod = fistIcon.getClass().getMethod("setLoading", Float.TYPE);
      
      drawModeMethod = this.getClass().getMethod("configDraw");
    }
    catch(Exception e)
    {
      println("ERRO");
    }
    

    TriggerCommand lineCommand = new TriggerCommand(cubo, lineMethod);
    TriggerCommand circleCommand = new TriggerCommand(cubo, circleMethod);
    TriggerCommand squareCommand = new TriggerCommand(cubo, squareMethod);
    TriggerCommand rDownCommand = new TriggerCommand(cubo, rDownMethod);
    TriggerCommand rLeftCommand = new TriggerCommand(cubo, rLeftMethod);
    
    TriggerCommand drawModeCommand = new TriggerCommand(this, drawModeMethod);

    AxisCommand oneLoading = new AxisCommand(oneIcon, oneLoadingMethod);
    AxisCommand twoLoading = new AxisCommand(twoIcon, twoLoadingMethod);
    AxisCommand threeLoading = new AxisCommand(threeIcon, threeLoadingMethod);
    AxisCommand okLoading = new AxisCommand(okIcon, okLoadingMethod);
    AxisCommand fistLoading = new AxisCommand(fistIcon, fistLoadingMethod);
    
    if(inputManager.haveInput(GestureInputID.FIVE))
    {
      inputManager.addCommand(GestureInputID.ONE, lineCommand);
      inputManager.addCommand(GestureInputID.TWO, circleCommand);
      inputManager.addCommand(GestureInputID.THREE, squareCommand);
      inputManager.addCommand(GestureInputID.OK, rDownCommand);
      inputManager.addCommand(GestureInputID.FIST, rLeftCommand);
      

      inputManager.addCommand(GestureInputID.ONE_LOADING, oneLoading);
      inputManager.addCommand(GestureInputID.TWO_LOADING, twoLoading);
      inputManager.addCommand(GestureInputID.THREE_LOADING, threeLoading);
      inputManager.addCommand(GestureInputID.OK_LOADING, okLoading);
      inputManager.addCommand(GestureInputID.FIST_LOADING, fistLoading);
      
      inputManager.addCommand(GestureInputID.ONE, drawModeCommand);
      inputManager.addCommand(GestureInputID.TWO, drawModeCommand);
      inputManager.addCommand(GestureInputID.THREE, drawModeCommand);
      inputManager.addCommand(GestureInputID.OK, drawModeCommand);
      inputManager.addCommand(GestureInputID.FIST, drawModeCommand);
      
    }
    else if (inputManager.haveInput(MouseInputID.RIGHT_BUTTON))
    {
      inputManager.addCommand(MouseInputID.RIGHT_BUTTON, rLeftCommand);
      
      inputManager.addCommand(MouseInputID.RIGHT_BUTTON, drawModeCommand);
    }
         
  }
  

  public void run()
  {
    if(blackBackground)
    {
      background(0,0,0);
    }
    else
    {
      background(255,255,255);
    }
    
    if(drawMode)
    {
      BodyInputManager bdInMan = (BodyInputManager) inputManager;
      
      float[] nose, wl, wr;
      
      nose = bdInMan.getKP(BodyInputID.NOSE);
      wl = bdInMan.getKP(BodyInputID.WRIST_R);
      wr = bdInMan.getKP(BodyInputID.WRIST_L);
      
      if(wl != null && wr != null && nose != null)
      {
        if(wl[1] < nose[1] &&  wr[1] < nose[1])
        {
          configEdit();
        }
      }
      
    }
    
    cubo.run(g);

    if(!drawMode)
    {
      colorMode(RGB, 255);
      fill(125,125,125, 125);
      rect(0,0, width, height);
    }
    
    oneIcon.run(g);
    twoIcon.run(g);
    threeIcon.run(g);
    okIcon.run(g);
    fistIcon.run(g);
  }

  private void loadSound(String soundMode)
  {
    SoundService service = SoundService.getInstance();
    
    service.load("face1-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.FACE1, "face1-"+soundMode+".wav");

    service.load("face2-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.FACE2, "face2-"+soundMode+".wav");

    service.load("face3-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.FACE3, "face3-"+soundMode+".wav");

    service.load("face4-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.FACE4, "face4-"+soundMode+".wav");

    service.load("face5-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.FACE5, "face5-"+soundMode+".wav");

    service.load("face6-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.FACE6, "face6-"+soundMode+".wav");
    
    service.load("rota1-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.ROT_UP, "rota1-"+soundMode+".wav");

    service.load("rota2-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.ROT_DOWN, "rota2-"+soundMode+".wav");

    service.load("rota3-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.ROT_LEFT, "rota3-"+soundMode+".wav");

    service.load("rota4-"+soundMode+".wav");
    service.defineID(RabiscoSoundID.ROT_RIGHT, "rota4-"+soundMode+".wav");
  }
}


MessageManager msgManager;
MessageManager skeletonMsgManager;
UDP udp;
BodyInputManager bodyInputManager;
RabiscoMain rabisco;

Skeleton skeleton;
ParticleSystem system;

PGraphics skeleton_canvas; 

void setup()
{
  SoundService.initialize(this);
  msgManager = new MessageManager(5, true);
  skeletonMsgManager = new MessageManager(5, true);

  udp = new UDP(this, 6000);
  udp.listen(true); 

  bodyInputManager = new BodyInputManager(msgManager, width, height);
   
  InputManager inputManager;
  inputManager = bodyInputManager;
  //inputManager = new MouseInputManager();

  rabisco = new RabiscoMain(inputManager);
  
  size(displayWidth,displayHeight,P2D);
  udp = new UDP(this, 6000); //Default ReDrawing port
  udp.listen(true);
  
  skeleton_canvas = createGraphics(displayWidth/3,displayHeight/3); 
  
  skeleton = new Skeleton(skeleton_canvas, false);
  system = new ParticleSystem();
  
  for(int i = 0; i<100; i++)
  {
    for(int j = 0; j<100; j++)
    {
      Particle p = new StaticParticle(new PVector((i*10)-500, j*10));
      system.addParticle(p);
    }
  }

  fullScreen();
}

boolean display = true;
int imageIndex = 0;

void draw()
{
  clear();
  
  skeleton_canvas.beginDraw();

  if(skeletonMsgManager.hasMessage(BodyPose.class))
  {
    skeleton.reset();
    BodyPose bodypose = skeletonMsgManager.getData(BodyPose.class);
      
    for(String name : skeleton.names)
    {
      float[] kp = bodypose.keypoints.get(name);
        
      if(Float.isInfinite(kp[0]))
      {
        continue;
      }
      skeleton.setKeypoint(name, kp);
       
      if(name.compareToIgnoreCase("WRIST_R") == 0 || name.compareToIgnoreCase("WRIST_L") == 0)
      {
        RadialField f = new RadialField(new PVector(kp[0],kp[1]), 1,  0, 1000, 0, 1000);
        system.insertField(f);
      }
    }
  }
  
  skeleton.show();
  skeleton_canvas.endDraw();
  
  bodyInputManager.run();
  rabisco.run();
  
  
  
if (keyPressed) {
  if (key == 'c') {
    display = !display;
  }
  if (key == 's') {
    save("face" + imageIndex + ".png");
    imageIndex++;
  }
}

if(display){
  image(skeleton_canvas.copy(),(displayWidth-400)/2,displayHeight-700,700,700);
}
  
  
}

void receive(byte[] data, String ip, int port)
{
  data = subset(data, 0, data.length);
  String message = new String( data );
  msgManager.insertMessage(message);
  skeletonMsgManager.insertMessage(message);
} 
