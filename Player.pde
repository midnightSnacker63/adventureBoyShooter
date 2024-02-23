class Player
{
  float xPos,yPos;
  float xSpd,ySpd;
  float maxSpeed = wallSize/10;
  float angle;
  float size = wallSize;
  
  int maxHealth;
  int health;
  int type;
  int money;
  int weapon = 0; 
  int cooldown = 1000;
  int eyeFrames = 1000;
  int invincibilityTimer;
  int [] weaponYOffset = {-85,-50,-70,-25,-25,0,0,0};//how far weapon sits from player
  int [] weaponXOffset = {0,0,0,0,-25,25,0,0};//how far weapon sits from player
  
  boolean movingLeft, movingRight, movingUp, movingDown;
  boolean invincible;
  
  PImage link;
  PImage [] weaponImage = new PImage[6];
 
  //ammo
  //I-frames
  public Player()
  {
   xPos = width/2;
   yPos = height/2;
  
   maxHealth = 100;
   health = maxHealth;
  
   link = loadImage("lonk.png");
   link.resize(int(size),0);
   weaponImage[0] = loadImage("masterSword.png");
   weaponImage[0].resize(75,0);
   weaponImage[1] = loadImage("bow.png");
   weaponImage[1].resize(85,0);
   weaponImage[2] = loadImage("hookShot.png");
   weaponImage[2].resize(85,0);
   weaponImage[3] = loadImage("hylianShieldUpsideDown.png");
   weaponImage[3].resize(85,0);
   weaponImage[4] = loadImage("boomerang.png");
   weaponImage[4].resize(70,0);
   weaponImage[5] = loadImage("bombUpsideDown.png");
   weaponImage[5].resize(70,0);
  }
  void drawPlayer()
  {
    if( !invincible || millis() % 100 < 50 )
    {
     float X = xPos+xOffset;
     float Y = yPos+yOffset;
     angle = atan2(mouseY-Y,mouseX-X); 
     image( link, X, Y );
     push();
     translate(X,Y);
     rotate(angle-HALF_PI);
     rotate(PI);
     image(weaponImage[weapon],weaponXOffset[weapon],weaponYOffset[weapon]);
     pop();
    }
  }
  void movePlayer()
  {
    if(movingUp)
      ySpd -=wallSize/100; 
    if(movingLeft)
      xSpd -=wallSize/100; 
    if(movingDown)
      ySpd +=wallSize/100;  
    if(movingRight)
      xSpd +=wallSize/100;  
    
    if(xSpd > maxSpeed)
    {
      xSpd = maxSpeed;
    }
    if(ySpd > maxSpeed)
    {
      ySpd = maxSpeed;
    }
    if(xSpd < -maxSpeed)
    {
      xSpd = -maxSpeed;
    }
    if(ySpd < -maxSpeed)
    {
      ySpd = -maxSpeed;
    }
    xPos += xSpd;
    yPos += ySpd;
    //friction
    xSpd *= 0.90;
    ySpd *= 0.90;
  }
  //************************//
  // Will move the 'screen' //
  //  when the player gets  //
  //   close to an edge.    //
  //************************//
  public void checkForScroll()
  {
    if( yPos+yOffset < scrollYDist ) //screen up
      yOffset -= yPos+yOffset-scrollYDist;
   
    if( xPos+xOffset < scrollXDist ) //screen left
      xOffset -= xPos+xOffset -scrollXDist;
     
    if( yPos+yOffset > height-scrollYDist ) //screen down
      yOffset -= yPos+yOffset - (height-scrollYDist);
     
    if( xPos+xOffset > width-scrollXDist) //screen right
      xOffset -= xPos+xOffset - (width-scrollXDist);
  }
  
  void checkNoDamage()
  {
    if(millis() > invincibilityTimer)
      invincible = false;
  }
  
  void takeDamage( float amount, float x, float y )
  {
    if(!invincible)
    {
      health -= amount;
      xSpd += x;
      ySpd += y;
    }
    invincible = true;
    invincibilityTimer = millis() + eyeFrames; 
    if(health <= 0)
    {
      health = 0;
    }
    
  }
  
  public float top() { return yPos-size/2; }
  public float bottom() { return yPos+size/2; }
  public float left() { return xPos-size/2; }
  public float right() { return xPos+size/2; }
}
