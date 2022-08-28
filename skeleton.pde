class Skeleton
{
  private PVector positions[];
  private boolean keypoint_3d;
  private PGraphics canvas;
  private boolean color_lines;
  private boolean circle;
  
  
  //                                0       1         2      3          4          5             6         7         8        9         10       11       12        13           14        15      16
  private final String names[] = {"NOSE", "EYE_R","EYE_L", "NECK", "SHOULDER_R","SHOULDER_L","ELBOW_R","ELBOW_L","WRIST_R","WRIST_L", "HIP_R", "HIP_L", "KNEE_R", "ANKLE_R", "KNEE_L", "ANKLE_L", "SPINE_SHOULDER"};
  
  private final int[][] pairs = {/*{1,2}, {2,19}, {19,3}, {3,18}, {18,1}, */{3,4}, {3,5}, {4,6}, {5,7}, {6,8}, {7,9}, {4,10}, {5,11}, {10,11}, {10,12}, {12,13}, {11,14}, {14,15}, {0,16}, {16,4}, {16,5}, {12,17}, {14,17}};
  private final int[] side    = {   0,      1,      1,      -1,     -1,    -1,    1,     -1,     1,     -1,    1,      -1,     1,      0,      -1,       -1,       1,       1,     0,      -1,     1,       -1,      1};
  //1 = left, -1 = right
  
  private final int[][] shapes = {{4,5,11,10}, {10,12,17}, {11,14,17}};
  
  private final int n_kp = 18;
  
  public Skeleton(PGraphics canvas, boolean keypoint_3d)
  {
    positions = new PVector[n_kp];
    this.canvas = canvas;
    this.keypoint_3d = keypoint_3d;
    
    this.color_lines = false;
    this.circle = false;
  }
  
  public void setColorLines(boolean color_lines)
  {
    this.color_lines = color_lines;
  }
  
  public void setCircle(boolean circle)
  {
    this.circle = circle;
  }
  
  public void reset()
  {
    positions = new PVector[n_kp];
  }
  
  public void setKeypoint(String name, float[] position)
  {
    for(int i = 0; i<names.length; i++)
    {
      
      if(names[i].compareToIgnoreCase(name) == 0)
      {
        positions[i] = new PVector(position[0],position[1], position[2]);
      }
      
   
    }
  }
  
  private void complete_kp()
  {
    //Se não tem nem NECK nem SHOULDER_SPINE, mas tem os SHOULDERS, 
    //definir SHOULDER_SPINE como a média dos SHOULDERS
    if(positions[3] == null && positions[16] == null)
    {
      if(positions[4] != null && positions[5] != null)
      {
        PVector spine_shoulder = new PVector();
        spine_shoulder.add(positions[4]);
        spine_shoulder.add(positions[5]);
        
        spine_shoulder.div(2);
        
        positions[16] = spine_shoulder;
      }
      
    }
    
    //Se NECK, mas não SHOULDER_SPINE, definer SHOULDER_SPINE = NECK
    
    if(positions[3] != null && positions[16] == null)
    {
      positions[16] = positions[3];
    }
    
    //cria o ponto intermediario entre os hips
    if(positions[10] != null && positions[11] != null)
    {
      PVector mean_hip = new PVector();
      mean_hip.add(positions[11]);
      mean_hip.add(positions[10]);
      
      mean_hip.div(2);
      
      positions[17] = mean_hip;
    }
    
    /* outros pontos
    if(positions[0] != null && positions[1] != null && positions[2] != null)
    {
      PVector right_eye = new PVector();
      PVector left_eye = new PVector();
      right_eye.add(positions[3]);
      right_eye.add(positions[1]);
      
      right_eye.div(2);
      
      left_eye.add(positions[3]);
      left_eye.add(positions[2]);
      
      left_eye.div(2);
      
      positions[18] = right_eye;
      positions[19] = left_eye;
    }*/
  }
  
  private PVector mean_kp()
  {
    PVector mean = new PVector();
    int n = 0;
    for(PVector position : positions)
    {
      if(position != null)
      {
        mean.add(position);
        n += 1;
      }
    }
    
    mean.div(n);
    
    return mean;
  }
  
  private void process_kp()
  {
    complete_kp();
    PVector mean = mean_kp();
    
    PVector translation = mean.sub(250,250,0);
    
    for(PVector position : positions)
    {
      if(position != null)
      {
        position.sub(translation);
      }
      
    }
  }
  
  public void show()
  {
    pushStyle();
    canvas.clear();
    
    
    process_kp();
    
    for(int i = 0; i<pairs.length; i++)
    {
      if(positions[pairs[i][0]] != null && positions[pairs[i][1]] != null)
      {
        if(color_lines)
        {
          if(side[i] == -1)
          {
            canvas.stroke(0,255,0);
          }
          else if (side[i] == 1)
          {
            canvas.stroke(255,0,0);
          }
          else
          {
            canvas.stroke(#00FFFF,200);
            canvas.stroke(255,255,0);
          }
        }
        else
        {
          canvas.stroke(#00FFFF,200);
          canvas.stroke(255,255,255);
        }
        
        canvas.strokeWeight(10);
        //line(positions[pairs[i][0]].x, positions[pairs[i][0]].y, positions[pairs[i][0]].z, positions[pairs[i][1]].x, positions[pairs[i][1]].y, positions[pairs[i][1]].z);
        canvas.line(positions[pairs[i][0]].x, positions[pairs[i][0]].y, positions[pairs[i][1]].x, positions[pairs[i][1]].y);
      }
    }

    //desenha a cabeca
    canvas.stroke(#00FFFF,200);
    canvas.fill(#00FFFF,200);
    if(positions[0] != null && positions[1] != null)
    {
      canvas.ellipse(positions[0].x, positions[0].y, 25, 25);
    }
    
    //desenha a coxa direita
    /*if(positions[10] != null && positions[12] != null && positions[17] != null)
    {
      canvas.triangle(positions[10].x, positions[10].y, positions[12].x, positions[12].y, positions[17].x, positions[17].y);
    }
    */
    //desenha a coxa esquerda
    /*if(positions[11] != null && positions[14] != null && positions[17] != null)
    {
      canvas.triangle(positions[11].x, positions[11].y, positions[14].x, positions[14].y, positions[17].x, positions[17].y);
    }*/
    
    canvas.fill(255,255,255);

    for(int[] shape : shapes)
    {
      boolean have_kp = true;
      
      for(int i : shape)
      {
        if(positions[i] == null)
        {
          have_kp = false;
          
          break;
        }
      }
      
      if(!have_kp)
      {
        continue;
      }
      
      PShape s = canvas.createShape();
      s.beginShape();
      for(int i : shape)
      {
        //para os ombros nao serem muito pontudos
        if(i != 4 && i != 5){
          s.vertex(positions[i].x, positions[i].y);
        } else{
          if(i == 4){
            s.vertex(positions[i].x - 5, positions[i].y);
          } else{
            s.vertex(positions[i].x + 5, positions[i].y);
          }
        }
      }
      s.endShape(CLOSE);
      
    }
    
    
    if(circle)
    {
      strokeWeight(1);
      for(int i = 0; i<positions.length; i++)
      {
        if(positions[i] != null)
        {
          canvas.pushMatrix();
          canvas.translate(positions[i].x, positions[i].y);
          color(255, 255, 255);
          canvas.fill(255,255,255);
          canvas.stroke(255,255,255);
          canvas.circle(0,0,10);
          canvas.popMatrix();
        }
      }
    }
    
    
    popStyle();
  }
  
}
