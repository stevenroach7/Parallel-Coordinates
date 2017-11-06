

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
    isThicker = false;;
  }
  
  void setGroupFilterBool(boolean tempGroupFilerBool) {
     groupFilterBool = tempGroupFilerBool;
  }
  
  void setQuantFilterBool(boolean tempQuantFilerBool) {
     quantFilterBool = tempQuantFilerBool;
  }
  
  Item getItem() {
    return item;
  }
  
  void setPositions(ArrayList<Position> tempPositions) {
    positions = tempPositions;
  }
  
  void display() {
    
    if (groupFilterBool && quantFilterBool) {
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