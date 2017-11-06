// Globals
TableReader tableReader;
ArrayList<Item> items;
ArrayList<String> axisLabels;
ArrayList<Axis> axes;
ArrayList<Line> lines;
HashMap<String, Integer> colorMap;

// Constants
String PATH = "../Data/cars-cleaned.tsv";
int AXIS_Y = 500;
int AXIS_HEIGHT = 400;
int PLOT_X = 100;
int PLOT_Y = 25;
int PLOT_WIDTH = 1400;
int Y_STAGGER = 20;

// Colors
// Array of pregenerated distinct CIELab colors from https://stackoverflow.com/questions/309149/generate-distinctly-different-rgb-colors-in-graphs
int[] distinctColors = {#9BC4E5,#310106,#04640D,#FEFB0A,#FB5514,#E115C0,#00587F,
  #0BC582,#FEB8C8,#9E8317,#01190F,#847D81,#58018B,#B70639,#703B01,#118B8A,
  #4AFEFA,#FCB164,#796EE6,#000D2C,#53495F,#F95475,#61FC03,#5D9608,#DE98FD};

void setup() {
  // Adjust canvas
  size(1500, 750);
  pixelDensity(displayDensity());
  
  loadData();
  // Create canvas elements
  createAxes();
  createColorMap();
  createLines();
}

void loadData() {
  tableReader = new TableReader(PATH);
  items = tableReader.parseTable();
  
  axisLabels = items.get(0).getQuantKeys();
}


// Data Structure Creation Methods

void createColorMap() {
  colorMap = new HashMap();
  int nextColorIndex = 0;
  for (Item item: items){
    String currentVal = item.getCatValue();
    if (!colorMap.containsKey(currentVal)) {
      colorMap.put(currentVal, distinctColors[nextColorIndex]);
      nextColorIndex++;
    }
  }
}

void createAxes() {
  axes = new ArrayList();
  int axisX = PLOT_X;
  int axisY = PLOT_Y + AXIS_HEIGHT; // Axis is anchord by bottom coordinate
  int axisSpacing = PLOT_WIDTH / axisLabels.size();
  boolean labelStagger = false;
  for (String axisLabel: axisLabels) {
   
    int minValue = 0;
    if (axisLabel.toLowerCase().equals("release year")) { // Special exception: axis min shouldn't be zero for year attribute
      minValue = (int) getMinValue(axisLabel);
    }
    
    Axis axis = new Axis(axisX, axisY, AXIS_HEIGHT, axisLabel, minValue, (int) getMaxValue(axisLabel), labelStagger);
    axes.add(axis);
    axisX += axisSpacing;
    labelStagger = !labelStagger;
  }
}

void createLines() {
  
  lines = new ArrayList();
  for (Item item: items) {
     
    ArrayList<String> quantKeys = item.getQuantKeys();
    ArrayList<Float> quantValues = item.getQuantValues();

    ArrayList<Position> positions = new ArrayList();
    for (int i = 0; i < quantKeys.size(); i++) { // Loop over all targets
        String quantKey = quantKeys.get(i);
        float quantValue = quantValues.get(i);
        Axis axis = getAxisFromLabel(quantKey);
        positions.add(new Position(axis.getX(), getYPosOnAxisFromValue(quantValue, axis)));
    }
    int colorHex = colorMap.get(item.getCatValue());
    lines.add(new Line(positions, colorHex));
  }
  
}


// Drawing Methods

void drawGroups(){
  // loop for drawing group names
  // Using an enhanced loop to interate over each entry
  String currentGroup = "";
  int currentColor = 0;
  int heightAdjust = 0;
  textAlign(LEFT, BOTTOM);
  textSize(18);
  int xPos = PLOT_X;
  
  int i = 0;
  for (HashMap.Entry group : colorMap.entrySet()) {
    currentGroup = group.getKey().toString();
    currentColor = (int) group.getValue();
    fill(currentColor);
    text(currentGroup, xPos, height - heightAdjust);
    heightAdjust += Y_STAGGER;

    if (i == 9) { // Hacky way of creating multiple columns
      xPos += 100;
      heightAdjust = 0;
    }
    i++;
  }
}


// Helper Methods

Axis getAxisFromLabel(String label) {
  for (Axis axis: axes) {
    if (axis.getLabel().equals(label)) {
      return axis;
    }
  }
  return null;
}

float getYPosOnAxisFromValue(float value, Axis axis) {
  float distance = ((value - axis.getMin()) / (axis.getMax() - axis.getMin())) * axis.getAxisHeight();
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

float getMinValue(String label) {
  int itemsIndex = items.get(0).getQuantKeys().indexOf(label);
  float minValue = 10000000;
  
  for (int i = 0; i < items.size(); i++) {
    float itemValue = items.get(i).getQuantValues().get(itemsIndex);
    if (itemValue < minValue) {
      minValue = itemValue;
    }
  }
  return minValue;
}


// Draw Method

void draw(){
  background(#FFFFFF);
  for (Axis axis: axes) {
    axis.display();
  }
  for (Line line: lines) {
    line.display();
  }
  drawGroups();
}