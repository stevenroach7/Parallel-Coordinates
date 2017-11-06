// Globals
TableReader tableReader;
ArrayList<Item> items;
ArrayList<String> axisLabels;
ArrayList<Axis> axes;
ArrayList<Integer> axisXPositions;
ArrayList<Line> lines;
ArrayList<Group> groups;
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
  createGroups();
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
  axisXPositions = new ArrayList();
  int axisX = PLOT_X;
  int axisY = PLOT_Y + AXIS_HEIGHT; // Axis is anchored by bottom coordinate
  int axisSpacing = PLOT_WIDTH / axisLabels.size();
  boolean labelStagger = false;
  for (String axisLabel: axisLabels) {
   
    int minValue = 0;
    if (axisLabel.toLowerCase().equals("release year")) { // Special exception: axis min shouldn't be zero for year attribute
      minValue = (int) getMinValue(axisLabel);
    }
    
    Axis axis = new Axis(axisX, axisY, AXIS_HEIGHT, axisLabel, minValue, (int) getMaxValue(axisLabel), labelStagger);
    axes.add(axis);
    axisXPositions.add(axisX);
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
    lines.add(new Line(item, positions, colorHex));
  }
}

void createGroups(){
  // loop for drawing group names
  // Using an enhanced loop to interate over each entry
  String currentGroup;
  int currentColor;
  int heightAdjust = 0;
  int xPos = PLOT_X;
  
  int i = 0;
  groups = new ArrayList();
  for (HashMap.Entry group : colorMap.entrySet()) {
    currentGroup = group.getKey().toString();
    currentColor = (int) group.getValue();
    groups.add(new Group(xPos, height-heightAdjust, currentGroup, currentColor));
    
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


// Interaction methods

void mousePressed() {
  for (Axis axis : axes) {
    if (axis.isPosInsideAxis(mouseX, mouseY)) {
      axis.isBeingDragged = true;
      axis.setDragOffsetY(mouseY - axis.getY());
    }
  }
}

void mouseDragged() {
  for (Axis axis : axes) {
    if (axis.isBeingDragged) {
      axis.setX(mouseX);
      axis.setY((int) (mouseY - axis.getDragOffsetY()));
      repositionLinesFromAxes();
    }
  }
  
}

void mouseReleased() {
  for (int i = 0; i < axes.size(); i++) {
    Axis axis = axes.get(i);
    if (axis.isBeingDragged) {
      reorderAxes(i, axis);
    }
  }
}

void mouseMoved() {
   resetLines();
   for (Group group: groups) {
      if (group.isPosInsideLabel(mouseX, mouseY)) {
         filterLinesByGroup(group.getLabel());
      }
   }
}

void filterLinesByGroup(String groupLabel) {
  for (Line line: lines) {
    if (!groupLabel.equals(line.getItem().getCatValue())) {
      line.setIsDisplayed(false);
    }
  }
}

void resetLines() {
  for (Line line: lines) {
    line.setIsDisplayed(true);
  }
}

void reorderAxes(int prevIndex, Axis draggedAxis) {
  
  int newIndex = getAxisIndexFromXPosition(draggedAxis.getX());
  axes.remove(prevIndex);
  
  if (newIndex <= prevIndex) { 
    axes.add(newIndex, draggedAxis);
  } else { // If new index is after previous index, removing axis in previous step will affect indices of all axes after
    axes.add(newIndex - 1, draggedAxis);
  }
  
  // Reposition axes
  for (int i = 0; i < axes.size(); i++) {
    Axis axis = axes.get(i);
    axis.setX(axisXPositions.get(i));
    axis.setY(PLOT_Y + AXIS_HEIGHT);
    axis.setIsBeingDragged(false);
  }
  repositionLinesFromAxes();
}

int getAxisIndexFromXPosition(float xPos) {
    for (int i = 0; i < axisXPositions.size(); i++) {
      if (xPos < axisXPositions.get(i)) {
        return i;
      }
    }
    return axisXPositions.size() - 1;
}

void repositionLinesFromAxes() {
  for (Line line: lines) {
    ArrayList<Position> positions = new ArrayList();
    for (Axis axis: axes) {
        int quantValuesIndex = line.item.getQuantKeys().indexOf(axis.label); // TODO: Maybe store map in Item so we don't have to search here.
        float quantValue = line.item.getQuantValues().get(quantValuesIndex);
        positions.add(new Position(axis.getX(), getYPosOnAxisFromValue(quantValue, axis)));
    }
    line.setPositions(positions);
  }
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
  for (Group group: groups) {
    group.display();
  }
}