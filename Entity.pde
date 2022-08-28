public abstract class Entity
{
  protected PVector position;
  protected float[] orientation;
  protected boolean hidden;

  public Entity(PVector position, float[] orientation)
  {
    this.position = position;
    this.orientation = orientation;
    this.hidden = false;
  }

  public Entity(PVector position)
  {
    this.position = position;

    this.orientation = new float[3];
    this.orientation[0] = 0;
    this.orientation[1] = 0;
    this.orientation[2] = 0;

    this.hidden = false;
  }


  public void hide()
  {
    this.hidden = true;
  }

  public void show()
  {
    this.hidden = false;
  }

  public abstract void run(PGraphics canvas);
}

// RABISCO -------------------------------------------------------

public enum StrokeType
{
  LINE_STROKE, CIRCLE_STROKE, SQUARE_STROKE;
}

public class Face extends Entity
{
  private StrokeType strokeType;
  private PVector pointerPosition, prevPointerPosition;
  private float quadrant1, quadrant2, quadrant3, quadrant4;
  private boolean pointerChanged;

  public Face(PVector position)
  {
    super(position);
    this.strokeType = StrokeType.SQUARE_STROKE;
    pointerChanged = false;
  }

  public void setColor(float quadrant1, float quadrant2, float quadrant3, float quadrant4)
  {
    this.quadrant1 = quadrant1;
    this.quadrant2 = quadrant2;
    this.quadrant3 = quadrant3;
    this.quadrant4 = quadrant4;

  }

  public void setPointer(PVector position)
  {

    this.prevPointerPosition = this.pointerPosition;
    this.pointerPosition = position.copy();

    pointerChanged = true;
  }

  public void run(PGraphics canvas)
  {
    if (this.hidden || this.pointerPosition == null || this.prevPointerPosition == null || !pointerChanged)
    {
      return;
    }
    pointerChanged = false;


    float firstSpeed = pointerPosition.dist(prevPointerPosition);
    float lineWidth = map(firstSpeed, 5, 50, 2, 20);
    lineWidth = constrain(lineWidth, 0, 100);
    
    

    canvas.noStroke();
    canvas.fill(0, 100);
    canvas.strokeCap(ROUND);
    canvas.strokeWeight(lineWidth);

    canvas.colorMode(HSB, 360, 100, 100);

    
    
    PVector prevPosition = this.prevPointerPosition.copy(), 
      currPosition = this.pointerPosition.copy();
    
    float quadrantColor;
    if (currPosition.x > canvas.width/2.0)
    {
      if (currPosition.y > canvas.height/4.0)
      {
        quadrantColor = this.quadrant4;
      } else 
      {
        quadrantColor = this.quadrant1;
      }
    } else 
    {
      if (currPosition.y > canvas.height/4.0)
      {
        quadrantColor = this.quadrant3;
      } else
      {
        quadrantColor = this.quadrant2;
      }
    }
    
   
    
    canvas.stroke(quadrantColor, int(random(80, 100)), 100);

    switch(strokeType)
    {
    case LINE_STROKE:
      canvas.line(prevPosition.x, prevPosition.y, currPosition.x, currPosition.y);
      break;
    case CIRCLE_STROKE:
      canvas.point(currPosition.x, currPosition.y);
      break;
    case SQUARE_STROKE:
      canvas.rect(currPosition.x, currPosition.y, random(80), random(80));
      break;
    }
  }

  public void changeStroke(StrokeType strokeType)
  {
    this.strokeType = strokeType;
  }
}

public class Cube extends Entity
{
  private Face[] faces;
  PGraphics facesCanva[];
  private int currentFace;
  private int faceSize;

  private int blueValue, redValue, greenValue, yellowValue;
  
  public PVector interposition;

  public Cube(PVector position, boolean threeDimensional, int faceSize)
  {
    super(position);
    
    float radius = 0;
    if (threeDimensional)
    {
      radius = 100;
    }

    this.faces = new Face[6];
    this.faces[0] = new Face(position.copy().add(0, 0, 0));
    this.faces[1] = new Face(position.copy().add(0, 0, 0));
    this.faces[2] = new Face(position.copy().add(0, 0, 0));
    this.faces[3] = new Face(position.copy().add(-0, 0, 0));
    this.faces[4] = new Face(position.copy().add(0, -0, 0));
    this.faces[5] = new Face(position.copy().add(0, 0, -0));

    this.currentFace = 5;

    this.faceSize = faceSize;

    facesCanva = new PGraphics[6];
    for (int i = 0; i < 6; i++)
    {
      facesCanva[i] = createGraphics(faceSize, faceSize);
    }

    setFaceColors();
  }

  private void setFaceColors()
  {
    blueValue = int(random(175, 250));
    redValue = int(random(0, 20));
    greenValue = int(random(80, 120));
    yellowValue = int(random(40, 70));

    int[] colorsValues = {blueValue, redValue, greenValue, yellowValue}; 
    int[] quadrantColor = new int[4];
    boolean[] selected = {false, false, false, false};

    for(int i = 0; i < 4; i++)
    {
      int index;
      do
      {
        index = int(random(0, 4));
      }
      while(selected[index]);
      
      quadrantColor[i] = colorsValues[index];
      selected[index] = true;
    }

    for(int i = 0; i < 6; i++)
    {
      int quadranteCimaEsq, quadranteCimaDir, quadranteBaixoEsq, quadranteBaixoDir;

      switch(i)
      {
        case 0:
          quadranteCimaEsq = quadranteCimaDir = 3;
          quadranteBaixoEsq = quadranteBaixoDir = 2;
        break;

        case 1:
          quadranteCimaEsq = quadranteBaixoEsq = 1;
          quadranteCimaDir = quadranteBaixoDir = 2;
        break;

        case 2:
          quadranteCimaEsq  = 1;
          quadranteBaixoEsq = 0;
          quadranteCimaDir = 2;
          quadranteBaixoDir = 3;
        break;

        case 3:
          quadranteCimaEsq = quadranteCimaDir = 0;
          quadranteBaixoEsq = quadranteBaixoDir = 1;
        break;

        case 4:
          quadranteCimaEsq = quadranteBaixoEsq = 0;
          quadranteCimaDir = quadranteBaixoDir = 1;
        break;

        case 5:
          quadranteCimaEsq  = 0;
          quadranteBaixoEsq = 1;
          quadranteBaixoDir = 2;
          quadranteCimaDir = 3;
        break;
        
        default:
          quadranteCimaEsq  = 0;
          quadranteBaixoEsq = 1;
          quadranteBaixoDir = 2;
          quadranteCimaDir = 3;
        break;

      }

      faces[i].setColor(quadrantColor[quadranteCimaDir], quadrantColor[quadranteCimaEsq], quadrantColor[quadranteBaixoEsq], quadrantColor[quadranteBaixoDir]);

    }
  }

  /**
   @todo alterar para modificar a orientação
   */
  public void rotateLeft()
  {
    stopSound();
    switch(currentFace)
    {
    case 0:
      currentFace = 5;
      break;
    case 1:
      currentFace = 3;
      break;
    case 2:
      currentFace = 0;
      break;
    case 3:
      currentFace = 2;
      break;
    case 4:
      currentFace = 3;
      break;
    case 5:
      currentFace = 3;
      break;
    }
  }

  /**
   @todo alterar para modificar a orientação
   */
  public void rotateDown()
  {
    stopSound();
    switch(currentFace)
    {
    case 0:
      currentFace = 1;
      break;
    case 1:
      currentFace = 2;
      break;
    case 2:
      currentFace = 4;
      break;
    case 3:
      currentFace = 1;
      break;
    case 4:
      currentFace = 5;
      break;
    case 5:
      currentFace = 1;
      break;
    }
    
    playSound();
  }

  public void lineStroke()
  {
    this.faces[currentFace].changeStroke(StrokeType.LINE_STROKE);
  }

  public void circleStroke()
  {
    this.faces[currentFace].changeStroke(StrokeType.CIRCLE_STROKE);
  }

  public void squareStroke()
  {
    this.faces[currentFace].changeStroke(StrokeType.SQUARE_STROKE);
  }

  private void stopSound()
  {
    SoundService service = SoundService.getInstance();
    
    switch(currentFace)
    {
     case 0:
      service.stop(RabiscoSoundID.FACE1);
      break;
    case 1:
      service.stop(RabiscoSoundID.FACE2);
      break;
    case 2:
      service.stop(RabiscoSoundID.FACE3);
      break;
    case 3:
      service.stop(RabiscoSoundID.FACE4);
      break;
    case 4:
      service.stop(RabiscoSoundID.FACE5);
      break;
    case 5:
      service.stop(RabiscoSoundID.FACE6);
      break;
    }
    
  }

  private void playSound()
  {
    SoundService service = SoundService.getInstance();
    switch(currentFace)
    {
     case 0:
      service.play(RabiscoSoundID.FACE1);
      break;
    case 1:
      service.play(RabiscoSoundID.FACE2);
      break;
    case 2:
      service.play(RabiscoSoundID.FACE3);
      break;
    case 3:
      service.play(RabiscoSoundID.FACE4);
      break;
    case 4:
      service.play(RabiscoSoundID.FACE5);
      break;
    case 5:
      service.play(RabiscoSoundID.FACE6);
      break;
    }
  }

  public void setPointer(PVector pointerPosition)
  {
    interposition = pointerPosition;
    if(pointerPosition.x < width && pointerPosition.y < height)
    {
      if(pointerPosition.x >= 0 && pointerPosition.y >= 0)
      { 
        this.faces[currentFace].setPointer(pointerPosition);
        playSound();
      }
    }
  }

  public void run(PGraphics canvas)
  {
    if (this.hidden)
    {
      return;
    }

    for(int i = 0; i<6; i++)
    {
      facesCanva[i].beginDraw();
      faces[i].run(facesCanva[i]);
      facesCanva[i].endDraw();
    }

    canvas.image(facesCanva[currentFace], 0, 0);
  }
}

public class GestureIcon extends Entity
{
  private float percentage;
  private PImage iconImage;
  private String file;

  public GestureIcon(PVector position, String file)
  {
    super(position);

    this.percentage = 0.0;
    this.file = file;

    iconImage = loadImage(file);
    iconImage.resize(150, 150);
  }

  public void setLoading(float percentage)
  {
    this.percentage = percentage;  
  }

  /**
   @todo @TODO conferir se os ângulos e posições estão corretos
   */
  public void run(PGraphics canvas)
  {
    if (this.hidden || this.percentage == 0.0)
    {
      return;
    }
    
    

    canvas.noStroke();

    canvas.fill(235, 100, 100);
    //canvas.arc(this.position.x+75, this.position.y+75, this.position.x, this.position.y, PI + PI/2, PI + PI/2 + this.percentage*2*PI);
    arc(width-95, 95, 160, 160, PI + PI/2, PI + PI/2 + this.percentage*2*PI, PIE);
    
    canvas.fill(0, 0, 100);
    ellipse(width-95, 95, 150, 150);
    //ellipse(this.position.x+25, this.position.y+25, -this.position.x+25, -this.position.y+25);
    
    canvas.image(iconImage, this.position.x, this.position.y);
  }
}
