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
String PATH = "../Data/cameras-cleaned.tsv";
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
  size(1500, 750, P2D);
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
  
  axisLabels = new ArrayList(items.get(0).getQuantMap().keySet());
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
     
    HashMap<String, Float> quantMap = item.getQuantMap();

    ArrayList<Position> positions = new ArrayList();
    for (HashMap.Entry<String, Float> quantEntry: quantMap.entrySet()) {
        Axis axis = getAxisFromLabel(quantEntry.getKey());
        positions.add(new Position(axis.getX(), axis.getYPosOnAxisFromValue(quantEntry.getValue())));
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

float getValueFromYPosOnAxis(float yPos, Axis axis) { // TODO: Move this method into axis class
  float yDist = axis.getY() - yPos;
  return (((yDist / AXIS_HEIGHT) * (axis.getMax() - axis.getMin())) + axis.getMin());
}

float getMaxValue(String label) {
  
  float maxValue = 0;
  for (int i = 0; i < items.size(); i++) {
    float itemValue = items.get(i).getQuantMap().get(label);
    if (itemValue > maxValue) {
      maxValue = itemValue;
    }
  }
  return maxValue;
}

float getMinValue(String label) {

  float minValue = 10000000;
  for (int i = 0; i < items.size(); i++) {
    float itemValue = items.get(i).getQuantMap().get(label);
    if (itemValue < minValue) {
      minValue = itemValue;
    }
  }
  return minValue;
}


// Interaction methods

void mousePressed() {
  for (Axis axis : axes) {
    if (axis.isPosInsideMoveButton(mouseX, mouseY)) {
      axis.isBeingDragged = true;
      axis.setDragOffsetY(mouseY - axis.getY());
    } else if (axis.isPosInsideAxis(mouseX, mouseY)) { // TODO: Implement filter canceling
      float value = getValueFromYPosOnAxis(mouseY, axis);
      QuantFilter quantFilter = new QuantFilter(value, value); // TODO: Don't set movingValue until mouse is dragged
      axis.setQuantFilter(quantFilter); 
      axis.setIsFilterBeingDragged(true);
    }
  }
}

void mouseDragged() {
  for (Axis axis : axes) {
    if (axis.getIsBeingDragged()) {
      axis.setX(mouseX);
      axis.setY((int) (mouseY - axis.getDragOffsetY()));
      repositionLinesFromAxes();
    } else if (axis.getIsFilterBeingDragged()) {
      if (axis.isYPosInsideAxis(mouseX, mouseY)) {
        float newValue = getValueFromYPosOnAxis(mouseY, axis);
        QuantFilter axisFilter = axis.getQuantFilter();
        axisFilter.setMovingValue(newValue);
        axisFilter.setFilterOn(true);
        axis.setQuantFilter(axisFilter);
      }
    }
  }
}

void mouseReleased() {
  for (int i = 0; i < axes.size(); i++) {
    Axis axis = axes.get(i);
    if (axis.getIsBeingDragged()) {
      reorderAxes(i, axis);
    }
    axis.setIsFilterBeingDragged(false);
  }
}

void mouseMoved() {
   resetLineGroupFilterBools();
   for (Group group: groups) {
      if (group.isPosInsideLabel(mouseX, mouseY)) {
         filterLinesByGroup(group.getLabel());
      }
   }
}

void resetLineGroupFilterBools() {
  for (Line line: lines) {
    line.setGroupFilterBool(true);
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
  boolean labelStagger = false;
  for (int i = 0; i < axes.size(); i++) {
    Axis axis = axes.get(i);
    axis.setX(axisXPositions.get(i));
    axis.setY(PLOT_Y + AXIS_HEIGHT);
    axis.setIsBeingDragged(false);
    axis.setStaggered(labelStagger);
    labelStagger = !labelStagger;
  }
  repositionLinesFromAxes();
}

int getAxisIndexFromXPosition(float xPos) {
    for (int i = 0; i < axisXPositions.size(); i++) {
      if (xPos < axisXPositions.get(i)) {
        return i;
      }
    }
    return axisXPositions.size();
}

void repositionLinesFromAxes() {
  for (Line line: lines) {
    ArrayList<Position> positions = new ArrayList();
    for (Axis axis: axes) {
        float quantValue = line.item.getQuantMap().get(axis.label);
        positions.add(new Position(axis.getX(), axis.getYPosOnAxisFromValue(quantValue)));
    }
    line.setPositions(positions);
  }
}

void filterLinesByGroup(String groupLabel) {
  for (Line line: lines) {
    if (!groupLabel.equals(line.getItem().getCatValue())) {
      line.setGroupFilterBool(false);
    }
  }
}

void applyAxisFilters() {
  
  for (Line line: lines) {
    
    Item lineItem = line.item;
    boolean allFiltersPass = true;
    for (Axis axis: axes) {
      if (axis.quantFilter != null) {
        float itemValue = lineItem.quantMap.get(axis.getLabel());
        if (!axis.quantFilter.isValueInRange(itemValue)) {
          allFiltersPass = false;
        }
      }
    }
    line.setQuantFilterBool(allFiltersPass);
  }
}


// Draw Method

void draw(){
  background(#FFFFFF);
  applyAxisFilters();
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