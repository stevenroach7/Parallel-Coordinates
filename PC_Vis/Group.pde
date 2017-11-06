

class Group {
  
  int x;
  int y;
  String label;
  int colorHex;
  
  Group(int tempX, int tempY, String tempLabel, int tempColorHex) {
    x = tempX;
    y = tempY;
    label = tempLabel;
    colorHex = tempColorHex;
  }
  
  String getLabel() {
    return label;
  }
 
  boolean isPosInsideLabel(float posX, float posY) {
    // TODO: Write this method
    return true;
  }
  
  void display() {
    textAlign(LEFT, BOTTOM);
    textSize(18);
    fill(colorHex);
    text(label, x, y);
  }
}