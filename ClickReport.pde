class ClickReport
{
  float xPos, yPos;
  float fadeY;//how far above it spawn that it will fade out
  String clicks;
  boolean active;
 
  public ClickReport( String clicks ,float x, float y )
  {
    
    this.clicks = clicks;
    xPos = x;
    yPos = y;
    fadeY = yPos - 250;
  }
 
  public void moveAndDraw()
  {
    float X = xPos+xOffset;
    float Y = yPos+yOffset;
    push();
    yPos-=3;
    textSize(20);
    fill(255,yPos-fadeY);
    text(clicks,X,Y);
    if(yPos<fadeY-20)
      active=false;
    pop();
  }
}
