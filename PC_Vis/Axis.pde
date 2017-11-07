

class Axis {

  int x, y;
  int axisHeight;
  String label;
  int min;
  int max;
  boolean staggered;
  boolean isBeingDragged;
  float dragOffsetY;
  boolean isFilterBeingDragged;
  QuantFilter quantFilter;
  
  int TICKWIDTH = 8;
  int LABELSTAGGER = 20;
  int CLICKABLE_WIDTH = 20;

  // Create the Axis
  Axis(int tempX, int tempY, int tempAxisHeight, String tempLabel, int tempMin, int tempMax, boolean tempStaggered){
    x = tempX;
    y = tempY;
    axisHeight = tempAxisHeight;
    label = tempLabel;
    min = tempMin - (tempMin % 10); // Round down to nearest 10
    max = Math.round((tempMax + 5)/ 10.0) * 10; // Round up to nearest 10
    staggered = tempStaggered;
    isBeingDragged = false;
    dragOffsetY = 0;
    isFilterBeingDragged = false;
  }

  // Display the Axis
  void display() {
    stroke(0);
    strokeWeight(1);
    textSize(16);
    fill(0);
    textAlign(CENTER, BOTTOM);
    

    // vertical axis line, variable label, and move axis button
    line(x, y, x, y - axisHeight);
    if (staggered){
      text(label, x, y + LABELSTAGGER*2);
      rect(x - (CLICKABLE_WIDTH / 2), y, CLICKABLE_WIDTH, LABELSTAGGER);
    } else {
      text(label, x, y + LABELSTAGGER);
      rect(x - (CLICKABLE_WIDTH / 2), y+LABELSTAGGER, CLICKABLE_WIDTH, LABELSTAGGER);
    }

    textAlign(CENTER, BOTTOM);
    // min tick mark and label
    line(x-TICKWIDTH, y, x+TICKWIDTH, y);
    text(min, x + TICKWIDTH, y);

    // intermediate tick marks
    line(x-TICKWIDTH, y - axisHeight * 0.25, x+TICKWIDTH, y - axisHeight * 0.25);
    line(x-TICKWIDTH, y - axisHeight * 0.5, x+TICKWIDTH, y - axisHeight * 0.5);
    line(x-TICKWIDTH, y - axisHeight * 0.75, x+TICKWIDTH, y - axisHeight * 0.75);


    // max tick mark and label
    line(x-TICKWIDTH, y - axisHeight, x+TICKWIDTH, y - axisHeight);
    text(max, x, y - axisHeight);
    
    // draw filter
    if (quantFilter != null && quantFilter.getIsFilterOn()) {
      float fixedValue = quantFilter.getFixedValue();
      float movingValue = quantFilter.getMovingValue();
      float yMinPos = getYPosOnAxisFromValue(min(fixedValue, movingValue));
      float yMaxPos = getYPosOnAxisFromValue(max(fixedValue, movingValue));
      rect(x - CLICKABLE_WIDTH/2, yMaxPos, CLICKABLE_WIDTH, yMinPos - yMaxPos);
    }
    
    // Debug Rect
    //rect(x - CLICKABLE_WIDTH/2, y-axisHeight, CLICKABLE_WIDTH, axisHeight);
  }


  
  float getYPosOnAxisFromValue(float value) {
    float distance = ((value - min) / (max - min)) * axisHeight;
    return y - distance;
  }

  int getX() {
    return x;
  }
  
  void setX(int tempX) {
    x = tempX;
  }

  int getY() {
    return y;
  }
  
  void setY(int tempY) {
    y = tempY;
  }

  int getAxisHeight() {
    return axisHeight;
  }

  String getLabel() {
    return label;
  }

  int getMin() {
    return min;
  }

  int getMax() {
    return max;
  }
  
  void setStaggered(boolean tempStaggered) {
    staggered = tempStaggered;
  }
  
  boolean getIsBeingDragged() {
    return isBeingDragged;
  }
  
  void setIsBeingDragged(boolean tempIsBeingDragged) {
    isBeingDragged = tempIsBeingDragged;
  }
  
  boolean getIsFilterBeingDragged() {
    return isFilterBeingDragged;
  }
  
  void setIsFilterBeingDragged(boolean tempIsFilterBeingDragged) {
    isFilterBeingDragged = tempIsFilterBeingDragged;
  }
  
  float getDragOffsetY() {
    return dragOffsetY;
  }
  
 void setDragOffsetY(float tempOffsetY) {
    dragOffsetY = tempOffsetY;
  }
  
  QuantFilter getQuantFilter() {
    return quantFilter;
  }
  
  void setQuantFilter(QuantFilter tempQuantFilter) {
    quantFilter = tempQuantFilter;
  }
  
  boolean isPosInsideMoveButton(float posX, float posY) {
    if (posX >= x - (CLICKABLE_WIDTH / 2) && posX <= x + (CLICKABLE_WIDTH / 2)) {
      if (staggered) {
        if (posY >= y  && posY <= (y + LABELSTAGGER)) {
          return true;
        }
      } else {
        if (posY >= y + LABELSTAGGER  && posY <= (y + (2 * LABELSTAGGER))) {
          return true;
        }
      }
    }
    return false;
  }
  
  boolean isPosInsideAxis(float posX, float posY) {
    if (posX >= x - (CLICKABLE_WIDTH / 2) && posX <= x + (CLICKABLE_WIDTH / 2)) {
      if (posY <= y && posY >= (y - axisHeight)) {
        return true;
      }
    }
    return false;
  }
  
}