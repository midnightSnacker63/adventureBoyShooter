//Joshua Poppy
//TwinStick shooter

Player player;

ArrayList<Shot> shots = new ArrayList<Shot>();

ArrayList<Pickup> pickups = new ArrayList<Pickup>();

ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Enemy> bosses = new ArrayList<Enemy>();

ArrayList<Wall> walls = new ArrayList<Wall>();

//for scrolling
float xOffset, yOffset;
float scrollXDist = 550, scrollYDist = 340;

//wall data
float wallSize = 100;

float miniMapZoom = 10;

boolean firingWeapon = false;

PImage [] pickupImage = new PImage[5];

PImage [] shotImage = new PImage[6];
PImage [] badShotImage = new PImage[5];
PImage [] badGuyImage = new PImage[20];

PImage [] wallImage = new PImage[5];

PImage money;
PImage mapBorder;


void setup()
{
 size(1600,900);
 fullScreen();
 imageMode(CENTER);
 textAlign(CENTER);
 noSmooth();
 //load image
 money = loadImage("rupee.png");
 money.resize(50,0);
 
 shotImage[0] = loadImage("swordBeam.png");
 shotImage[0].resize(75,0);
 shotImage[1] = loadImage("arrow.png");
 shotImage[1].resize(20,0);
 shotImage[2] = loadImage("hookShotShot.png");
 shotImage[2].resize(35,0);
 shotImage[3] = loadImage("parry.png");
 shotImage[3].resize(85,0);
 shotImage[4] = loadImage("boomerang.png");
 shotImage[4].resize(70,0);
 shotImage[5] = loadImage("bomb.png");
 shotImage[5].resize(70,0);
 
 badGuyImage[0] = loadImage("dekuScrub.png");
 badGuyImage[0].resize(75,0);
 badGuyImage[1] = loadImage("cosmoPixel.png");
 badGuyImage[1].resize(100,0);
 badGuyImage[2] = loadImage("splat.png");
 badGuyImage[2].resize(100,0);
 
 badGuyImage[11] = loadImage("ganon.png");
 badGuyImage[11].resize(250,0);
 
 
 pickupImage[0] = loadImage("rupee.png");
 pickupImage[0].resize(75,0);
 pickupImage[1] = loadImage("heartContainer.png");
 pickupImage[1].resize(75,0);
 
 wallImage[0] = loadImage("cobbleColor.png");
 wallImage[0].resize(int(wallSize),0);
 wallImage[1] = loadImage("woodTile.png");
 wallImage[1].resize(int(wallSize),0);
 
 mapBorder = loadImage("mapBorder.png");
 mapBorder.resize(365,0);
 createMap();
 player = new Player();
 bosses.add( new Enemy( 11,43.5*wallSize-xOffset,39*wallSize-yOffset ));
}
void draw()
{
  background(50,100,50);
  handleWalls();
  handlePlayer();
  handleEnemies();
  handleShots();
  handlePickups();
  drawHUD();
  drawMiniMap();
}

void handlePlayer()
{
  player.drawPlayer();
  player.movePlayer();
  player.checkForScroll();
  player.checkNoDamage();
}

void handleEnemies()
{
  
  
  for(Enemy e: enemies)
  {
    e.moveAndDraw();
    e.checkForHit();
    if(e.type == 2)
    {
      //enemies.add( new Enemy( int(random(0,3)),e.xPos-xOffset,e.yPos-yOffset ));
    }
  }
  for( int i = 0; i< enemies.size(); i++ )
  {
    if(!enemies.get(i).active)
    {
      if(enemies.get(i).value > 0)
        pickups.add( new Pickup( 1,enemies.get(i).xPos,enemies.get(i).yPos ));
      enemies.remove(i);
      
      i--;
    }
  }
  
  for(Enemy b: bosses)
  {
    b.moveAndDraw();
    b.checkForHit();
  }
  for( int i = 0; i< bosses.size(); i++ )
  {
    if(!bosses.get(i).active)
    {
      if(bosses.get(i).value > 0)
        pickups.add( new Pickup( 6,bosses.get(i).xPos,bosses.get(i).yPos ));
      bosses.remove(i);
      
      i--;
    }
  }
}

void handleShots()
{
  if(firingWeapon)
    attemptShot();
  for( int i = 0; i< shots.size(); i++ )
  {
    if(!shots.get(i).active)
    {
      shots.remove(i);
      i--;
    }
  }
  for(Shot s: shots)
  {
    
    s.moveAndDrawShot();
    s.checkForHit();
  }
}

void handleWalls()
{
  for( Wall w: walls)
  {
    w.drawWall();
    w.checkCollision();
  }
}

void handlePickups()
{
  for(Pickup p: pickups)
  {
    p.moveAndDraw();
  }
  for( int i = 0; i< pickups.size(); i++ )
  {
    if(!pickups.get(i).active)
    {
      pickups.remove(i);
      i--;
    }
  }
}
void attemptShot()
{
   if(millis() > player.cooldown)
   {
     shots.add(new Shot(player.weapon+1,player.xPos,player.yPos));
   }
}

//Mini-map

void drawMiniMap()
{
  push();
  fill(50,200,50);
  circle(width-155,height-170,250);
  noFill();
  strokeWeight(17);
  stroke(#059CE0);
  circle( width-155, height-170, 250 );
  strokeWeight(3);
  fill(#059CE0);
  circle(width-150,height-165,5 );
  imageMode(CORNER);

  noStroke();
  fill(#81D8FF);
  float xDist, yDist; //distance from player to wall
  for( Wall w: walls )
    if( dist( w.xPos, w.yPos, player.xPos, player.yPos ) < 125*miniMapZoom )
    {
      xDist = w.xPos-player.xPos;
      yDist = w.yPos-player.yPos;
      
      if(w.open)
      {
        push();
        fill(255,0,0);
        square( width-155+xDist/miniMapZoom, height-170+yDist/miniMapZoom, wallSize/miniMapZoom+1 );
        pop();
      }
      else
      {
        square( width-155+xDist/miniMapZoom, height-170+yDist/miniMapZoom, wallSize/miniMapZoom+1 );
      }
      //image(wallImage[w.Type],width-110+xDist/10, height-110+yDist/10, wallSize/10,wallSize/10);
      
    }
    
    for( Enemy e: enemies)
    {
      if( dist( e.xPos, e.yPos, player.xPos, player.yPos ) < 125*miniMapZoom )
      {
        xDist = e.xPos-player.xPos;
        yDist = e.yPos-player.yPos;
        push();
        strokeWeight(1);
        stroke(1);
        fill(255,0,0);
        circle( width-155+xDist/miniMapZoom, height-170+yDist/miniMapZoom, wallSize/miniMapZoom+1 );
        pop();
      }
    }
    for( Enemy b: bosses)
    {
      if( dist( b.xPos, b.yPos, player.xPos, player.yPos ) < 125*miniMapZoom )
      {
        xDist = b.xPos-player.xPos;
        yDist = b.yPos-player.yPos;
        push();
        strokeWeight(1);
        stroke(1);
        fill(255,0,0);
        circle( width-155+xDist/miniMapZoom, height-170+yDist/miniMapZoom, wallSize/miniMapZoom+10 );
        pop();
      }
    }
    for( Pickup p: pickups)
    {
      if( dist( p.xPos, p.yPos, player.xPos, player.yPos ) < 125*miniMapZoom )
      {
        xDist = p.xPos-player.xPos;
        yDist = p.yPos-player.yPos;
        fill(0,255,0);
        circle( width-155+xDist/miniMapZoom, height-170+yDist/miniMapZoom, wallSize/(miniMapZoom+5) );
      }
    }
  noFill();
  strokeWeight(17);
  
  stroke(#059CE0);
  circle( width-155, height-170, 240 );
  //circle( width-155, height-170, 260 );
  stroke(#81D8FF);
  circle( width-155, height-170, 250 );
  push();
  imageMode(CENTER);
  image(mapBorder,width-155,height-170);
  pop();
  
  pop();
}
void keyPressed()
{
  if(key == 'w')
    player.movingUp = true;
  if(key == 'a')
    player.movingLeft = true;
  if(key == 's')
    player.movingDown = true;
  if(key == 'd')
    player.movingRight = true;
  if(key == 'e')
    enemies.add( new Enemy( int(random(0,2)),random(mouseX-50,mouseX+50)-xOffset,random(mouseY-50,mouseY+50)-yOffset ));
  if(key == 'f')
    pickups.add( new Pickup( int(random(1,6)),random(mouseX-200,mouseX+200)-xOffset,random(mouseY-200,mouseY+200)-yOffset ));
  if(key == 'r')
  {
    shots.add(new Shot(player.weapon+1,random(player.xPos-75,player.xPos+75),random(player.yPos-75,player.yPos+75)));
    shots.add(new Shot(player.weapon+1,random(player.xPos-75,player.xPos+75),random(player.yPos-75,player.yPos+75)));
    shots.add(new Shot(player.weapon+1,random(player.xPos-75,player.xPos+75),random(player.yPos-75,player.yPos+75)));

  } 
  if(key == 'q' && player.weapon < player.weaponImage.length-1)
  {
    player.weapon++;
  }
  if(key == '1' && player.weapon > 0)
  {
    player.weapon--;
  }
  if(key == 'c')
  {
    enemies.clear();
  }
  
}
void keyReleased()
{
  if(key == 'w')
    player.movingUp = false;
  if(key == 'a')
    player.movingLeft = false;
  if(key == 's')
    player.movingDown = false;
  if(key == 'd')
    player.movingRight = false;
}
void mousePressed()
{
  //shots.add(new Shot(player.weapon+1,player.xPos,player.yPos));
  if(mousePressed && (mouseButton == RIGHT))
  {
    bosses.add( new Enemy( 11,random(mouseX-50,mouseX+50)-xOffset,random(mouseY-50,mouseY+50)-yOffset ));
  }
  if(mousePressed && (mouseButton == LEFT))
  {
    firingWeapon = true;
  }
}
void mouseReleased()
{
  firingWeapon = false;
}
void drawHUD()
{
  push();//money
  tint(20,240,80);
  image(money,90,height - 50);
  textSize(50);
  fill(255);
  textAlign(CORNER);
  text("X" + player.money,100,height - 35);
  text(int((player.xPos/wallSize)+1)+", "+int((player.yPos/wallSize)+1),85,height - 90);
  pop();
  
  push();//health bar
  rectMode(CORNER);
  noFill();
  rect(50,50,player.maxHealth*5,20);
  fill(255,10,0);
  rect(50,50,player.health*5,20);
  pop();  
  push();//weapons
  stroke(#CEB63A);
  strokeWeight(7);
  fill(#FFE146);
  circle(width - 160,100,100);
  if(player.weapon > 0)
  {
    circle(width - 240,125,70);
  }
  if(player.weapon < player.weaponImage.length-1)
  {
    circle(width - 80,125,70);
  }
  if(player.weapon > 1)
  {
    circle(width - 300,150,60);
  }
  if(player.weapon < player.weaponImage.length-2)
  {
    circle(width - 20,150,60);
  }
  pop();
  
  if(player.weapon > 0)
  {
    image(player.weaponImage[player.weapon-1],width - 240, 125);//previous weapon
  }
  if(player.weapon < player.weaponImage.length-1)
  {
    image(player.weaponImage[player.weapon+1],width - 80, 125);//next weapon
    
  }
  if(player.weapon > 1)
  {
    image(player.weaponImage[player.weapon-2],width - 300, 150);//previous weapon
  }
  if(player.weapon < player.weaponImage.length-2)
  {
    image(player.weaponImage[player.weapon+2],width - 20, 150);//next weapon
    
  }
  image(player.weaponImage[player.weapon],width - 160, 100);//curent weapon
}

void mouseWheel(MouseEvent event) 
{
 float e = event.getCount();
 if(e > 0 && player.weapon < player.weaponImage.length-1 && dist(mouseX,mouseY,width-155,height-170) > 150)//next weapon
  {
    player.weapon++;
  }
  if(e < 0 && player.weapon > 0 && dist(mouseX,mouseY,width-155,height-170) > 150)//previous weapon
  {
    player.weapon--;
  }
  if( e > 0 && miniMapZoom <= wallSize/4  && dist(mouseX,mouseY,width-155,height-170) < 150)//zoom out
  {
    miniMapZoom+=wallSize/100;
  }
  if( e < 0 && miniMapZoom > 10 && dist(mouseX,mouseY,width-155,height-170) < 150)//zoom in
  {
    miniMapZoom-=wallSize/100;
  }
}
