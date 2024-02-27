class Shop
{
  float xPos,yPos;
  
  boolean inShop;
  
  public Shop(float x, float y)
  {
    xPos = x;
    yPos = y;
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
  
  void enterShop()
  {
    
  }
  
}
