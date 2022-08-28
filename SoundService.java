import java.util.HashMap;

import processing.core.*;
import processing.sound.*;


public class SoundService
{
  private HashMap<String, SoundFile> soundFileMap;
  private HashMap<SoundID, SoundFile> soundIDMap;
  private PApplet pApplet;
  private static SoundService soundService;

  private SoundService(PApplet pApplet)
  {
    soundFileMap = new HashMap<String, SoundFile>();
    soundIDMap = new HashMap<SoundID, SoundFile>();
    this.pApplet = pApplet;
  }

  public void load(String file)
  {
    SoundFile soundFile = new SoundFile(pApplet, file);
    soundFileMap.put(file, soundFile);
  }

  public void defineID(SoundID id, String file)
  {
    SoundFile soundFile = soundFileMap.get(file);
    soundIDMap.put(id, soundFile);
  }
  
  private void play(SoundFile soundFile)
  {
    if(!soundFile.isPlaying())
    {
      soundFile.play();
    }
  }
  
  private void loop(SoundFile soundFile)
  {
    if(!soundFile.isPlaying())
    {
      soundFile.loop();
    }
  }

  public void play(SoundID id)
  {
    SoundFile soundFile = soundIDMap.get(id);
    
    play(soundFile);
  }
  

  public void play(String file)
  {
    SoundFile soundFile = soundFileMap.get(file);
    play(soundFile);
  }

  public void stop(SoundID id)
  {
    SoundFile soundFile = soundIDMap.get(id);
    soundFile.stop();
  }

  public void stop(String file)
  {
    SoundFile soundFile = soundFileMap.get(file);
    soundFile.stop();
  }

  public void loop(SoundID id)
  {
    SoundFile soundFile = soundIDMap.get(id);
    loop(soundFile);
  }

  public void loop(String file)
  {
    SoundFile soundFile = soundFileMap.get(file);
    loop(soundFile);
  }

  public void stopAll()
  {
    for (SoundFile soundFile : soundFileMap.values())
    {
      soundFile.stop();
    }
  }

  static public void initialize(PApplet papplet)
  {
    SoundService.soundService = new SoundService(papplet);
  }

  static public SoundService getInstance()
  {
    return soundService;
  }
}
