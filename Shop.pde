class Shop
{
  float xPos,yPos;
  
  PImage shopBackground;
  PImage shopForeground;
  PImage shopKeeper;
  
  int [] itemCost = {10,20,30,40,50,60};
  int shopPage;
  
  boolean [] itemBought = {true,false,false,false,false,false};
  
  public Shop(float x, float y)
  {
    xPos = x;
    yPos = y;
    
    shopBackground = loadImage("bigWoodWall.png");
    shopBackground.resize(width,0);
    shopForeground = loadImage("shopCounter.png");
    shopForeground.resize(width,0);
    
    shopKeeper = loadImage("beedle.png");
    shopKeeper.resize(500,0);
  }
  void drawShop()
  {
    float X = xPos+xOffset;
    float Y = yPos+yOffset;
    if( player.onShop() )
    {
      push();
      text("e - enter shop",X,Y-75);
      pop();  
    }
    circle(X,Y,100);
  }
  
  void drawInside()
  {
    push();
    imageMode(CORNER);
    image(shopBackground,0,0);//back wall
    imageMode(CENTER);
    image(shopKeeper,width/2,height/2.5);//beedle
    imageMode(CORNER);
    image(shopForeground,0,0);//counter
    
    push();//money
    imageMode(CENTER);
    tint(20, 240, 80);
    image(money, 90, height - 50);
    textSize(50);
    fill(255);
    textAlign(CORNER);
    text("X" + player.money, 100, height - 35);
    pop();
    
    for(int i = 0; i < 6; i++)
    {
      int x = 225*(i%6+1);
      push();
      stroke(#CEB63A);
      strokeWeight(7);
      fill(#FFE146);
      
      circle(x,height-200,150);
      fill(0);
      if(!itemBought[i])
      {
        image(player.weaponImage[i],x,height-180);
        text(itemCost[i],x,height-180);
      }
      else if(itemBought[i])
        text("bought",x,height-180);
      
      pop();
    }
    
    pop();
  }
  
  void buyThings()
  {
    for(int i = 0; i < 6 ; i++)
    {
      int x = 225*(i%6+1);
      if(dist(mouseX,mouseY,x,height-200) < 75 && !itemBought[i] && player.money >= itemCost[i]  )
      {
        println("chaching"+i);
        player.currentWeaponCount++;
        player.money -= itemCost[i];
        itemBought[i] = true;
        
      }
    }
  }
  
}
