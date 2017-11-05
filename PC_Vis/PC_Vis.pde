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
   
    Axis axis = new Axis(axisX, axisY, AXIS_HEIGHT, axisLabel, 0, (int) tableReader.getMaxValue(axisLabel));
    axes.add(axis);
    axisX += axisSpacing;
  }
}

void drawLines() {
  
  for (Item item: items) {
    // TODO: add item filters here 
     stroke(0);
     strokeWeight(1);
    
     // TODO: Make Line its own class?
     
     ArrayList<String> quantKeys = item.getQuantKeys();
     ArrayList<Float> quantValues = item.getQuantValues();
     
     for (int i = 0; i < quantKeys.size() - 1; i++) { // TODO: Optimize this
        String sourceKey = quantKeys.get(i);
        float sourceValue = quantValues.get(i);
        Axis sourceAxis = getAxisFromLabel(sourceKey);
        float sourceY = getYPosOnAxisFromValue(sourceValue, sourceAxis);
        
        String targetKey = quantKeys.get(i + 1);
        float targetValue = quantValues.get(i + 1);
        Axis targetAxis = getAxisFromLabel(targetKey);
        float targetY = getYPosOnAxisFromValue(targetValue, targetAxis);
        
        line(sourceAxis.getX(), sourceY, targetAxis.getX(), targetY); 
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

void draw(){
  for (Axis axis: axes) {
    axis.display();
    drawLines();
  }
}