// Globals
TableReader tableReader;
ArrayList<Item> items;
ArrayList<String> axisLabels;
ArrayList<Axis> axes;

// Constants
String PATH = "../Data/cameras-cleaned.tsv";
int AXIS_Y = 500;
int AXIS_HEIGHT = 400;
int PLOT_X = 100;
int PLOT_Y = 25;
int PLOT_WIDTH = 1400;

void setup() {
  // Adjust canvas
  size(1500, 750);
  pixelDensity(displayDensity());
  
  loadData();
   // Draw canvas elements
   drawAxes();
}

void loadData() {
  tableReader = new TableReader(PATH);
  items = tableReader.parseTable();
  
  axisLabels = items.get(0).getQuantKeys();
}

void drawAxes() {
  axes = new ArrayList();
  
  int axisX = PLOT_X;
  int axisY = PLOT_Y + AXIS_HEIGHT; // Axis is anchord by bottom coordinate
  int axisSpacing = PLOT_WIDTH / axisLabels.size();
  boolean labelStagger = false;
  for (String axisLabel: axisLabels) {
   
    Axis axis = new Axis(axisX, axisY, AXIS_HEIGHT, axisLabel, 0, (int) getMaxValue(axisLabel), labelStagger);
    axes.add(axis);
    axisX += axisSpacing;
    if (labelStagger == false){
      labelStagger = true; 
    } else {
      labelStagger = false;
    }
  }
}

void drawLines() {
  
  for (Item item: items) {
    // TODO: add item filters here
    // TODO: Set color of line based on categorical attribute
     stroke(0);
     strokeWeight(1);
     // whatever command to changeColor(catColorMap.get(item.getCatValue()))
    
     // TODO: Make Line its own class for eventual interaction and highlighting?
     
     ArrayList<String> quantKeys = item.getQuantKeys();
     ArrayList<Float> quantValues = item.getQuantValues();
     
     String sourceKey = quantKeys.get(0);
     float sourceValue = quantValues.get(0);
     Axis sourceAxis = getAxisFromLabel(sourceKey);
     float sourceY = getYPosOnAxisFromValue(sourceValue, sourceAxis);
    
     for (int i = 1; i < quantKeys.size(); i++) { // Loop over all targets
       
        String targetKey = quantKeys.get(i);
        float targetValue = quantValues.get(i);
        Axis targetAxis = getAxisFromLabel(targetKey);
        float targetY = getYPosOnAxisFromValue(targetValue, targetAxis);
        
        line(sourceAxis.getX(), sourceY, targetAxis.getX(), targetY); 
        
        sourceAxis = targetAxis; // Target becomes source of next iteration
        sourceY = targetY;
     }
  }
}

Axis getAxisFromLabel(String label) {
  for (Axis axis: axes) {
    if (axis.getLabel().equals(label)) {
      return axis;
    }
  }
  return null;
}

float getYPosOnAxisFromValue(float value, Axis axis) {
  float distance = (value / axis.getMax()) * axis.getAxisHeight();
  return axis.getY() - distance;
}

float getMaxValue(String label) {
  
  int itemsIndex = items.get(0).getQuantKeys().indexOf(label);
  float maxValue = 0;
  
  for (int i = 0; i < items.size(); i++) {
    float itemValue = items.get(i).getQuantValues().get(itemsIndex);
    if (itemValue > maxValue) {
      maxValue = itemValue;
    }
  }
  return maxValue;
}

void draw(){
  for (Axis axis: axes) {
    axis.display();
  }
  drawLines();
}