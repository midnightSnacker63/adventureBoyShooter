class Pickup
{
  float xPos,yPos;
  float xSpd,ySpd;
  float range = 100;
  float size = 50;
  
  int type;
  int timer;
  int value = 1;
  
  boolean active;
  boolean lifeHeart;
  boolean healing;
  boolean doorKey;
  
  public Pickup(int t,float x, float y)
  {
    xPos = x;
    yPos = y;
    
    type = t;
    
    setTraitsByType();
    
    active = true;
    
    
  }
  
  void moveAndDraw()
  {
   //circle(xPos,yPos,range*2);//they range
   float X = xPos+xOffset;
   float Y = yPos+yOffset;
   
   if(type == 1)//rupee green
   {
     push();
     translate(X,Y);
     tint(0,255,0);
     image( pickupImage[0],0,0,size,size);
     pop();
   }
   if(type == 2)//rupee blue
   {
     push();
     translate(X,Y);
     tint(0,0,255);
     image( pickupImage[0],0,0,size,size);
     pop();
   }
   if(type == 3)//rupee orange
   {
     push();
     translate(X,Y);
     tint(255,200,0);
     image( pickupImage[0],0,0,size,size);
     pop();
   }
   if(type == 4)//rupee red
   {
     push();
     translate(X,Y);
     tint(255,0,0);
     image( pickupImage[0],0,0,size,size);
     pop();
   }
   if(type == 5)//rupee purple
   {
     push();
     translate(X,Y);
     tint(155,0,255);
     image( pickupImage[0],0,0,size,size);
     pop();
   }
   if(type == 6)//heart container
   {
     push();
     translate(X,Y);
     image( pickupImage[1],0,0,size,size);
     pop();
   }
   if(type == 7)//life heart
   {
     push();
     translate(X,Y);
     image( pickupImage[2],0,0,size,size);
     pop();
   }
   if(type == 8)//life heart
   {
     push();
     translate(X,Y);
     image( pickupImage[3],0,0,size,size);
     pop();
   }
    //movement
    if( dist(player.xPos,player.yPos,xPos,yPos) < range)
    {
      if( player.xPos > xPos )
      {
        xSpd += 1;
      }
      else
      {
        xSpd -= 1;
      }
      if( player.yPos > yPos )
      {
        ySpd += 1;
      }
      else
      {
        ySpd -= 1;
      }
    }
    
    xPos += xSpd;
    yPos += ySpd;
    //friction
    xSpd *= 0.90;
    ySpd *= 0.90;
    
    if(dist(player.xPos,player.yPos,xPos,yPos) < player.size/2 && !lifeHeart)//rupees
    {
      player.money += value;
      clickReports.add( new ClickReport("+"+int(value), random(xPos-50,xPos+50), random(yPos-50,yPos+50) ));
      active = false;
    }
    
    if(dist(player.xPos,player.yPos,xPos,yPos) < player.size/2 && lifeHeart)//heart containers
    {
      player.maxHealth += value;
      player.health = player.maxHealth;
      active = false;
    }
    if(dist(player.xPos,player.yPos,xPos,yPos) < player.size/2 && healing)//life heart
    {
      if( player.health < player.maxHealth)
        player.health += value;
      active = false;
      if(player.health >= player.maxHealth)
      {
        player.health = player.maxHealth;
      }
    }
    if(dist(player.xPos,player.yPos,xPos,yPos) < player.size/2 && doorKey)//key
    {
      
      player.keyCount += value;
      active = false;
      
    }
  }
  
  void setTraitsByType()
  {
   switch(type)
   {
     case 1://rupee green
       value = 1;
       timer = 30;
       range = 100;
       break;
     case 2://rupee blue
       value = 5;
       timer = 30;
       range = 100;
       break;
     case 3://rupee orange
       value = 10;
       timer = 30;
       range = 100;
       break;
     case 4://rupee red
       value = 20;
       timer = 30;
       range = 100;
       break;
     case 5://rupee purple
       value = 50;
       timer = 30;
       range = 100;
       break;
     case 6: //heart container
     value = 10;
     timer = 30;
     range = 100;
     lifeHeart = true;
       break;
     case 7: //healing heart
     value = 10;
     timer = 30;
     range = 100;
     healing = true;
       break;
     case 8: //key
     value = 1;
     timer = 30;
     range = 100;
     doorKey = true;
       break;
   }
  }
}
