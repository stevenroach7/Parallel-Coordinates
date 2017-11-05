

class Axis {

  int x, y;
  int axisHeight;
  int min;
  int max;
  String label;
  int TICKWIDTH = 8;
  int LABELSTAGGER = 20;
  boolean staggered;
  

  // Create the Axis
  Axis(int tempX, int tempY, int tempAxisHeight, String s, int tempMin, int tempMax, boolean tempStaggered){
    x = tempX;
    y = tempY;
    axisHeight = tempAxisHeight;
    label = s;
    min = tempMin;
    max = Math.round((tempMax + 5)/ 10.0) * 10; // Round up to nearest 10
    staggered = tempStaggered;
    
  }

  // Display the Axis
  void display() {
    stroke(0);
    strokeWeight(1);
    textSize(16);
    fill(0);
    textAlign(CENTER, BOTTOM);
    

    // vertical axis line and variable label
    line(x, y, x, y - axisHeight);
    if (staggered){
      text(label, x, y + LABELSTAGGER*2);
    } else {
      text(label, x, y + LABELSTAGGER);
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
  }

  int getX() {
    return x;
  }

  int getY() {
    return y;
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
  
}