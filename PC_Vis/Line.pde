

class Line {
  
  Item item;
  ArrayList<Position> positions;
  int colorHex;
  boolean isDisplayed;
  boolean isThicker;
  
  Line(Item tempItem, ArrayList<Position> tempPositions, int tempColorHex) {
    item = tempItem;
    positions = tempPositions;
    colorHex = tempColorHex;
    isDisplayed = true;
    isThicker = false;;
  }
  
  void setIsDisplayed(boolean tempIsDisplayed) {
     isDisplayed = tempIsDisplayed;
  }
  
  Item getItem() {
    return item;
  }
  
  void setPositions(ArrayList<Position> tempPositions) {
    positions = tempPositions;
  }
  
  void display() {
    
    if (isDisplayed) {
      stroke(colorHex);
      strokeWeight(isThicker ? 3 : 1);
      
      Position sourcePosition = positions.get(0);
      for (int i = 1; i < positions.size(); i++) { // Loop over all target positions
        Position targetPosition = positions.get(i);
        line(sourcePosition.getX(), sourcePosition.getY(), targetPosition.getX(), targetPosition.getY()); 
        sourcePosition = targetPosition; // Target becomes source of next iteration
      }  
    }
  }
  
}