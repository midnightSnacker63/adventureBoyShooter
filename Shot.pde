//handle collision here
class Shot
{
  float xPos,yPos;
  float xSpd,ySpd;
  float size;
  float angle;
  float damage;
  float friction = 1;
  float knockBack  = 1;
  
  //negative = enemy shot, positive = player shot, 0 = nothing
  int type;
  int duration;
  int cooldown = 100;
  int travelDistance = 3000;
  
  //enemy shots are bad
  boolean bad;
  boolean active;
  boolean returns;
  boolean returning;
  boolean hitEnemy;
  boolean canShoot = true;
  boolean bouncy;
  
  public Shot( int t, float x, float y )
  {
    type = t;
    xPos = x;
    yPos = y;
    if( type > 0)
      bad = false;
    else
      bad = true;
      
    active = true;
    setTraitsByType();
    if(!bad)
      player.cooldown = millis()+cooldown;
  }
 void setTraitsByType()
 {
   switch(type)
   {
     //sword beam
     case 1:
       bad = false;
       size = 30;
       duration = 2000;
       damage = 2;
       setSpeed( 12 );
       knockBack = 1.5;
       cooldown = 750;
       break;
     //arrow  
     case 2:
       size = 20;
       duration = 2000;
       damage = 3;
       setSpeed( 20 );
       cooldown = 250;
       break;
     //hookshot 
     case 3:
       size = 20;
       duration = 2000;
       damage = 5;
       setSpeed( 12 );
       returns = true;
       friction = 0.9;
       travelDistance = 500;
       cooldown = 2000;
       break;
     case 4://shield Bash
       size = 50;
       duration = 2000;
       damage = 0;
       setSpeed( 25 );
       travelDistance = 120;
       knockBack = 2.5;
       cooldown = 500;
       break;
     case 5://boomerrang
       size = 60;
       duration = 2000;
       damage = 5;
       setSpeed( 20 );
       returns = true;
       friction = 0.95;
       travelDistance = 500;
       cooldown = 1500;
       knockBack = 2.5;
       break;
     case 6://bomb
       size = 60;
       duration = 20;
       damage = 25;
       setSpeed( 20 );
       friction = 0.95;
       travelDistance = 5000;
       cooldown = 1500;
       knockBack = 5;
       break;
     //bad guy deku nut
     case -1:
       size = 30;
       duration = 2000;
       damage = 1;
       setSpeed( 12 );
       break;
     //splat
     case -2:
       size = 30;
       duration = 2000;
       damage = 1;
       setSpeed( 0 );
       break;
   }
 }
 void setSpeed( float speed )
 {
   float targetX;
   float targetY;
   float X = xPos+xOffset;
   float Y = yPos+yOffset;
   
   if(type > 0)//player shots
   {
     targetX = mouseX;
     targetY = mouseY;
   }
   else//enemy shot
   {
     targetX = player.xPos;
     targetY = player.yPos;
   }
   //Determine speed based on vector subtraction
    xSpd = targetX-X;
    ySpd = targetY-Y;
   
    //Divide speeds based on speed variable
    xSpd /= dist(X,Y,targetX,targetY)/speed;
    ySpd /= dist(X,Y,targetX,targetY)/speed;
    
    angle = atan2(targetY-Y,targetX-X); 
 }
 void moveAndDrawShot()
 {
   float X = xPos+xOffset;
   float Y = yPos+yOffset;
   if(type == 1)//sword beam
   {
     push();
     translate(X,Y);
     rotate(angle-HALF_PI);
     rotate(PI);
     image(shotImage[type-1],0,-85);
     pop();
   }
   if(type == 2)//arrow
   {
     push();
     translate(X,Y);
     rotate(angle-HALF_PI);
     rotate(PI);
     image(shotImage[type-1],0,-50);
     pop();
   }
   if(type == 3)//hookShot
   {
     push();
     translate(X,Y);
     rotate(angle-HALF_PI);
     rotate(PI);
     image(shotImage[type-1],0,-50);
     pop();
     push();
     stroke(255);
     line(player.xPos+xOffset,player.yPos+yOffset,X,Y);
     pop();
   }
   if(type == 4)//not made yet
   {
     push();
     translate(X,Y);
     rotate(angle-HALF_PI);
     rotate(PI);
     image(shotImage[type-1],0,0);
     pop();
   }
   if(type == 5)//boomerang
   {
     push();
     translate(X,Y);
     rotate(angle-HALF_PI);
     rotate(PI);
     angle+=0.25;
     image(shotImage[type-1],-15,-15);
     
     //if(!returning)
     //  circle(0,0,size);
     pop();
   }
   if(type == 6)//bomb
   {
     push();
     translate(X,Y);
     rotate(angle-HALF_PI);
     rotate(PI);

     image(shotImage[type-1],-15,-15);
     //if(!returning)
     //  circle(0,0,size);
     pop();
   }
   if(type == -2)//splat
   {
     push();
     translate(X,Y);
     rotate(angle-HALF_PI);
     rotate(PI);
     image(shotImage[-type+1],0,-85);
     pop();
   }
   xPos += xSpd;
   yPos += ySpd;
   if(!returns && friction < 1)
   {
     xSpd *= friction;
     ySpd *= friction;
   }
   if( returning )//hook shot return
    {
      xSpd *= friction;//hookshot friction
      ySpd *= friction;
      if( player.xPos > xPos )
      {
        xSpd += 1.2;
      }
      else
      {
        xSpd -= 1.2;
      }
      if( player.yPos > yPos )
      {
        ySpd += 1.2;
      }
      else
      {
        ySpd -= 1.2;
      }
    }
    if( returns && dist(player.xPos,player.yPos,xPos,yPos) >= travelDistance)//tell hook shot to come back after certain distance
    {
      returning = true;
    }
    if(!returns && dist(player.xPos,player.yPos,xPos,yPos) >= travelDistance)
    {
      active = false;
     
    }
 }

  void checkForHit()
  {
    //bad shots
    if( bad && dist( xPos,yPos, player.xPos,player.yPos ) < size )
    {
      player.takeDamage( damage, (xSpd/3)*knockBack, (ySpd/3)*knockBack);
      active = false;
      return;
      //hurt lonk delete self
    }
    //good shot
    if( !bad )
    {
      for( int i = 0; i < enemies.size(); i++ )
      {
        if( dist( xPos,yPos, enemies.get(i).xPos,enemies.get(i).yPos ) < size/2+enemies.get(i).size && !returning )
        {
          enemies.get(i).takeDamage( damage, (xSpd/3)*knockBack, (ySpd/3)*knockBack );//enemy take damage
          if(returns)//kill normal shots when done but return hook shot
          {
            returning = true;
          }
          else
          {
            active = false;
          }
          return;
        }
      }
      for( int i = 0; i < bosses.size(); i++ )
      {
        if( dist( xPos,yPos, bosses.get(i).xPos,bosses.get(i).yPos ) < size+bosses.get(i).size/2 && !returning )
        {
          bosses.get(i).takeDamage( damage, (xSpd/3)*knockBack, (ySpd/3)*knockBack );//enemy take damage
          if(returns)//kill normal shots when done but return hook shot
          {
            returning = true;
          }
          else 
            active = false;
          return;
        }
      }
    }
    if( !bad && returns && returning && dist( xPos,yPos, player.xPos,player.yPos ) < size )//kill returning stuff when returned
    {
      active = false;
      return;
    }
  }
  
  
  public float top() { return yPos-size/2; }
  public float bottom() { return yPos+size/2; }
  public float left() { return xPos-size/2; }
  public float right() { return xPos+size/2; }
}
