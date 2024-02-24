class Wall
{
  float xPos, yPos;
  float size;
  
  int wallImageType;
  
  int wallType;
  
  boolean open;
  
  boolean pathable = false;
  
  public Wall(float x, float y, boolean solid )
  {
    xPos = x;
    yPos = y;
    size = wallSize;
    
    open = !solid;
  }
  
  void drawWall()
  {
    float X = xPos+xOffset;
    float Y = yPos+yOffset;
    
    if(open)
    {
      image(wallImage[1],X,Y);
    }
    else
    {
      image(wallImage[0],X,Y);
    }
  }
  
  void checkCollision()
  {
    //Player
    //Top of wall
    while( player.bottom() > yPos-size/2 && player.xPos < right() && player.xPos > left() && player.bottom() < yPos )
      player.yPos--;
    //Bottom of wall
    while( player.top() < yPos+size/2 && player.xPos < right() && player.xPos > left() && player.top() > yPos )
      player.yPos++;
    //Left of wall
    while( player.right() > xPos-size/2 && player.yPos < bottom() && player.yPos > top() && player.right() < xPos )
      player.xPos--;
    //Right of wall
    while( player.left() < xPos+size/2 && player.yPos < bottom() && player.yPos > top() && player.left() > xPos )
      player.xPos++;
   
    //Enemies
    for( Enemy e: enemies )
    {
      while( e.bottom() > yPos-size/2 && e.xPos < right() && e.xPos > left() && e.bottom() < yPos )
        e.yPos--;
      while( e.top() < yPos+size/2 && e.xPos < right() && e.xPos > left() && e.top() > yPos )
        e.yPos++;
      while( e.right() > xPos-size/2 && e.yPos < bottom() && e.yPos > top() && e.right() < xPos )
        e.xPos--;
      while( e.left() < xPos+size/2 && e.yPos < bottom() && e.yPos > top() && e.left() > xPos )
        e.xPos++;
    }
    
    for( Enemy b: bosses )
    {
      while( b.bottom() > yPos-size/2 && b.xPos < right() && b.xPos > left() && b.bottom() < yPos )
        b.yPos--;
      while( b.top() < yPos+size/2 && b.xPos < right() && b.xPos > left() && b.top() > yPos )
        b.yPos++;
      while( b.right() > xPos-size/2 && b.yPos < bottom() && b.yPos > top() && b.right() < xPos )
        b.xPos--;
      while( b.left() < xPos+size/2 && b.yPos < bottom() && b.yPos > top() && b.left() > xPos )
        b.xPos++;
    }
   
   
    //Shots
    if(!open)
      for( Shot s: shots )
      {
        if( s.right() > left() && s.left() < right() && s.top() < bottom() && s.bottom() > top() && !s.returns)
        {
          s.active = false;
        }
        if( s.right() > left() && s.left() < right() && s.top() < bottom() && s.bottom() > top() && s.returns && !s.returning)
        {
          s.xSpd *= 0.25;
          s.ySpd *= 0.25;
          s.returning = true;
        }
      }
  }

  public float top() { return yPos-size/2; }
  public float bottom() { return yPos+size/2; }
  public float left() { return xPos-size/2; }
  public float right() { return xPos+size/2; }
}
