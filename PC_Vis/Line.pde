

class Line {
  
  ArrayList<Position> positions;
  int colorHex;
   boolean isDisplayed;
   boolean isThicker;
  
  Line(ArrayList<Position> tempPositions, int tempColorHex) {
    positions = tempPositions;
    colorHex = tempColorHex;
    isDisplayed = true;
    isThicker = false;;
  }
  
  void setIsDisplayed(boolean tempIsDisplayed) {
    isDisplayed = tempIsDisplayed;
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