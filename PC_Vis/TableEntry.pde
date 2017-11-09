
 
class TableEntry {
  
  int CHAR_WIDTH = 11;
  int CHAR_HEIGHT = 20;
  float x;
  float y;
  String label;
  int colorHex;
  
  TableEntry(float tempX, float tempY, String tempLabel, int tempColorHex) {
    x = tempX;
    y = tempY;
    label = tempLabel;
    colorHex = tempColorHex;
  }
  
  boolean isPosInsideLabel(float posX, float posY) {
    if (posX >= x && posX <= x + (label.length() * CHAR_WIDTH)) {
      if (posY <= y && posY >= (y - CHAR_HEIGHT)) {
        return true;
      }
    }
    return false;
  }
  
  void display() {
    textAlign(LEFT, BOTTOM);
    textSize(18);
    fill(colorHex);
    text(label, x, y);
    
    // Debug Rect
    //rect(x,y-CHAR_HEIGHT,(label.length() * CHAR_WIDTH), CHAR_HEIGHT);
  }
  
  
  
  
}