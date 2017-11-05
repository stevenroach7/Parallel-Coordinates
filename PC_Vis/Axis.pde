class Axis {
  int x, y;
  float min, mid, max;
  String label;
  int AXISHEIGHT = 500;
  int TICKWIDTH = 10;
  
  // Create the Axis
  Axis(int tempX, int tempY, String s, float tempMin, float tempMax) {
    x = tempX;
    y = tempY;
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
    line(x, y, x, y - AXISHEIGHT);
    text(label, x, y + 20);
    //min tick mark and label
    line(x-TICKWIDTH, y, x+TICKWIDTH, y);
    text(min, x, y);
    //mid tick mark and label
    line(x-TICKWIDTH, y - AXISHEIGHT/2, x+TICKWIDTH, y - AXISHEIGHT/2);
    text(mid, x, y - AXISHEIGHT/2);
    //max tick mark and label
    line(x-TICKWIDTH, y - AXISHEIGHT, x+TICKWIDTH, y - AXISHEIGHT);
    text(max, x, y - AXISHEIGHT);
  }
}