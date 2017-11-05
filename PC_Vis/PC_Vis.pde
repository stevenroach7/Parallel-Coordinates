// Globals
TableReader tableReader;
ArrayList<Item> items;
ArrayList<String> axisLabels;
ArrayList<Axis> axes;

// Constants
String PATH = "../Data/cars-cleaned.tsv";
int AXIS_Y = 500;
int AXIS_HEIGHT = 300;
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
  
  for (String axisLabel: axisLabels) {
   
    Axis axis = new Axis(axisX, axisY, AXIS_HEIGHT, axisLabel, 0, (int) getMaxValue(axisLabel));
    axes.add(axis);
    axisX += axisSpacing;
  }
}

void drawLines() {
  
  for (Item item: items) {
    // TODO: add item filters here
    // TODO: Set color of line based on categorical attribute
     stroke(0);
     strokeWeight(1);
    
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