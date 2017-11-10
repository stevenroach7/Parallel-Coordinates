

class Line {
  
  Item item;
  ArrayList<Position> positions;
  int colorHex;
  boolean groupFilterBool;
  boolean quantFilterBool;
  boolean isThicker;
  
  Line(Item tempItem, ArrayList<Position> tempPositions, int tempColorHex) {
    item = tempItem;
    positions = tempPositions;
    colorHex = tempColorHex;
    groupFilterBool = true;
    quantFilterBool = true;
    isThicker = false;
  }
  
  void display() {
    
    if (groupFilterBool && quantFilterBool) {
      stroke(colorHex);
      strokeWeight(isThicker ? 5 : 1);
      
      Position sourcePosition = positions.get(0);
      for (int i = 1; i < positions.size(); i++) { // Loop over all target positions
        Position targetPosition = positions.get(i);
        line(sourcePosition.x, sourcePosition.y, targetPosition.x, targetPosition.y); 
        sourcePosition = targetPosition; // Target becomes source of next iteration
      }  
    }
  }
  
}