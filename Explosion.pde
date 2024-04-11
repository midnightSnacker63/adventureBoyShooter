class Explosion
{
  float xPos, yPos;
  float xSpd, ySpd;
  float size;//how big it is
  float damage;//how much damage it does
  float angle;
  float rotateSpeed = 0.25;//how fast it spins
  float maxSize;//maximum size it can reach
  float growthRate;//how fast it expands
  float speed; 
  
  int timer;//how long its been alive
  int lifeTime;//how long it will last
  int type;
  
  boolean active;
  boolean bad;//will damage enemies if false but damage towers if true
  
  
  public Explosion(float x, float y, int t)
  {
    xPos = x;
    yPos = y;
    type = t;
    
    active = true;
    
    setTraits();
    
    timer = millis() + lifeTime;
    
    
    //explosionPic.resize(int(size),int(size));
  }
  
  void explode()
  {
  
  }
  
  void drawExplosion()
  {
    float X = xPos+xOffset;
    float Y = yPos+yOffset;
    push();
    translate(X,Y);
    rotate(angle);
    if(size < maxSize)
      size+=growthRate;
    angle+=rotateSpeed;
    image(explosionPic,0,0,size,size);
    pop();
    if( millis() > timer )
    {
      active = false;
    }
  }
  
  void moveExplosion()
  {
    xSpd += 1 * speed;
    
    xSpd *= 0.97;
    ySpd *= 0.97;
    
    xPos += xSpd;
    yPos += ySpd;
  }
  
  void checkForHit()
  {
    for( int i = 0; i < enemies.size(); i++ )//enemies
    {
      if( dist( xPos,yPos, enemies.get(i).xPos,enemies.get(i).yPos ) < (size+enemies.get(i).size)/2 && active && millis() > enemies.get(i).hitTimer && !bad )
      {
        enemies.get(i).takeDamage(damage, .25 , .25);
        enemies.get(i).hitTimer = millis()+enemies.get(i).hitCooldown;
      }
      
    }
    for( int i = 0; i < bosses.size(); i++ )//enemies
    {
      if( dist( xPos,yPos, bosses.get(i).xPos,bosses.get(i).yPos ) < (size+bosses.get(i).size)/2 && active && millis() > bosses.get(i).hitTimer && !bad )
      {
        bosses.get(i).takeDamage(damage, .25 , .25);
        bosses.get(i).hitTimer = millis()+bosses.get(i).hitCooldown;
      }
    }
    if( dist( xPos,yPos, player.xPos,player.yPos ) < (size+player.size)/2 && active && millis() > player.hitTimer && bad )
      {
        player.takeDamage(damage, 5 , 5);
        player.hitTimer = millis()+player.hitCooldown;
      }
  }
  
  void setTraits()
  {
    switch(type)
    {
      case 0:
        bad = false;
        damage = 25;
        size = 20;
        maxSize = 200;
        lifeTime = 1000;
        growthRate = 5;
        return;
      case 1:
        bad = true;
        damage = 25;
        size = 20;
        maxSize = 200;
        lifeTime = 1000;
        growthRate = 5;
        return;
      case 2:
        bad = true;
        damage = 100;
        size = 100;
        maxSize = 750;
        lifeTime = 2500;
        growthRate = 12;
        return;
    }
  }
}
