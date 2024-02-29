class Enemy
{
  float xPos,yPos;
  float xSpd,ySpd;
  float angle;
  float range = 500; // how far they see ya
  float size = wallSize*0.75;
  float speed;
  float maxSpeed = 20;
  float knockBack = 1;
  
  int maxHealth = 10;
  int health = 10;
  int timer;
  int cooldown;
  int hitCooldown = 1000;
  int type;
  int damage = 1;
  int value = 1;
  
  boolean active;
  boolean stunned;
  boolean dummy = false;
  
  //boss data
  boolean isBoss;
  float spawnRange;
  int spawnRate;
  int spawnCooldown = 0;
  int population;
  
  public Enemy( int t, float x, float y)
  {
    xPos = x;
    yPos = y;
    
    type = t;
    
    setTraitsByType();
    
    active = true;
    
    angle = random(180);
  }
  
  void setTraitsByType()
  {
   switch(type)
   {
     case 0://deku
     health = 10;
     damage = 2;
     value = 10;
     knockBack = 0.5;
     speed = 0.4;
       break;
     case 1://cosmo
     health = 50;
     knockBack = 0.75;
     speed = .45;
       break;
     case 2://dummy
     health = 5000;
     speed = 0.1;
     knockBack = 5;
     damage = 1;
     dummy = true;
     cooldown = 1000;
       break;
       
     //ganon
     case 11:
     isBoss = true;
     range = 500;
     maxHealth = 250;
     health = 250;
     size = wallSize * 2;
     damage = 10;
     speed = 0.05;
     population = 10;
     knockBack = 25;
     spawnRate = 3000;
     spawnRange = 50;
       break;
     case 12://test
     isBoss = true;
     range = 500;
     maxHealth = 250;
     health = 250;
     size = wallSize * 2;
     damage = 0;
     speed = 0;
     population = 1;
     knockBack = 0;
     spawnRate = 300;
     spawnRange = range;
       break;
   }
  }
  
  void moveAndDraw()
  {
   //circle(xPos,yPos,range*2);//they range
   float X = xPos+xOffset;
   float Y = yPos+yOffset;
   push();
   translate(X,Y);
   rotate(angle-HALF_PI);
   if(!isBoss)
   {
     
     image( badGuyImage[type],0,0,size,size);
   }
   else
   {
     image( badGuyImage[type],0,0,size+40,size+40);//boss
   }
   pop();
    //movement
    if( dist(player.xPos,player.yPos,xPos,yPos) < range && !stunned )
    {
      angle = atan2(player.yPos-yPos,player.xPos-xPos); 
      if( player.xPos > xPos )
      {
        xSpd += speed;
      }
      else
      {
        xSpd -= speed;
      }
      if( player.yPos > yPos )
      {
        ySpd += speed;
      }
      else
      {
        ySpd -= speed;
      }
      
      
    }
    
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
    xSpd *= 0.95;
    ySpd *= 0.95;
    
    if( isBoss )
    {
      checkForSpawn();
      
      push();//health bar
      rectMode(CORNER);
      noFill();
      rect(X-size/2-25, Y+100, maxHealth, 20);
      fill(255, 10, 0);
      rect(X-size/2-25, Y+100, health, 20);
      pop();
    }
      
    
  }
  void takeDamage( float amount, float x, float y )
  {
    if( isBoss )//knockback reduced on bosses
    {
      xSpd += x/10;
      ySpd += y/10;
    }
    if( !isBoss )
    {
      xSpd += x;
      ySpd += y;
    }
    health -= amount;
    spawnRange += amount;
    population += amount;
    if(range < 1000)
      range += 50;
    if( amount > 0 )
      clickReports.add( new ClickReport("-"+int(amount), random(xPos-50,xPos+50), random(yPos-50,yPos+50) ));
    if(health <= 0)
    {
      active = false;
    }
    
  }
  
  void checkForHit()
  {
    if(dist(xPos,yPos,player.xPos,player.yPos) < size/2 && !player.invincible)
    {
      player.takeDamage( damage, (xSpd*knockBack), (ySpd*knockBack));
    }
  }
  
  void checkForSpawn()
  {
    if( millis() > spawnCooldown && !areaFull() )
    {
      spawnCooldown = millis()+spawnRate;
      enemies.add( new Enemy( type-11, xPos+(random(-spawnRange,spawnRange)), yPos+(random(-spawnRange,spawnRange))));
    }
  }
  
  boolean areaFull()
  {
    int tally = 0;
    for( Enemy e: enemies )
      if( e.type == type-11 ) //if enemy was spawned by this boss
        tally++;
       
    if( tally >= population )
      return true;
     
    return false;
  }
  
  public float top() { return yPos-size/2; }
  public float bottom() { return yPos+size/2; }
  public float left() { return xPos-size/2; }
  public float right() { return xPos+size/2; }
}
