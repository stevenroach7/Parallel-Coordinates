

class Axis {
  
  int x, y;
  int axisHeight;
  float min, mid, max;
  String label;
  int TICKWIDTH = 10;
  
  // Create the Axis
  Axis(int tempX, int tempY, int tempAxisHeight, String s, float tempMin, float tempMax) {
    x = tempX;
    y = tempY;
    axisHeight = tempAxisHeight;
    label = s;
    min = tempMin;
    max = tempMax;
    mid = (min + max)/2;
  }
  
  
  //Display the Axis
  void display() {
    stroke(0);
    strokeWeight(1);
    textSize(16);
    
    //vertical axis line and variable label
    line(x, y, x, y - axisHeight);
    text(label, x, y + 20);
    
    //min tick mark and label
    line(x-TICKWIDTH, y, x+TICKWIDTH, y);
    text(min, x, y);
    
    //mid tick mark and label
    line(x-TICKWIDTH, y - axisHeight/2, x+TICKWIDTH, y - axisHeight/2);
    text(mid, x, y - axisHeight/2);
    
    //max tick mark and label
    line(x-TICKWIDTH, y - axisHeight, x+TICKWIDTH, y - axisHeight);
    text(max, x, y - axisHeight);
  }
}