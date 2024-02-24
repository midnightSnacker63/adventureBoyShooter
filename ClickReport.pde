class ClickReport
{
  float xPos, yPos;
  String clicks;
  boolean active;
 
  public ClickReport( String clicks ,float x, float y )
  {
    
    this.clicks = clicks;
    xPos = x;
    yPos = y;
    
  }
 
  public void moveAndDraw()
  {
    float X = xPos+xOffset;
    float Y = yPos+yOffset;
    yPos-=3;
    textSize(20);
    fill(255,yPos-50);
    text(clicks,X,Y);
    if(yPos<-20)
      active=false;
  }
}
