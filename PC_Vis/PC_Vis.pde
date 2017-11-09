import java.util.Collections;
import java.util.Comparator;

// Globals
TableReader tableReader;
ArrayList<Item> items;
ArrayList<String> axisLabels;
ArrayList<Axis> axes;
ArrayList<Integer> axisXPositions;
ArrayList<Line> lines;
ArrayList<Group> groups;
HashMap<String, Integer> colorMap;
String catName;
ArrayList<TableEntry> displayedEntries;
boolean isTableSortedAscending = true;

// Constants
String PATH = "../Data/cars-cleaned.tsv";
int AXIS_Y = 500;
int AXIS_HEIGHT = 400;
int PLOT_X = 100;
int PLOT_Y = 25;
int PLOT_WIDTH = 1400;
int Y_STAGGER = 25;
int HEADER_STAGGER = 250;
int BLOCK_WIDTH = 300;


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
  createDisplayedEntries();
}

void loadData() {
  tableReader = new TableReader(PATH);
  items = tableReader.parseTable();
  catName = items.get(0).getCatKey();
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
        positions.add(new Position(axis.x, axis.getYPosOnAxisFromValue(quantEntry.getValue())));
    }
    int colorHex = colorMap.get(item.getCatValue());
    lines.add(new Line(item, positions, colorHex));
  }
}

void createGroups(){
  // For drawing group names
  String currentGroup;
  int currentColor;
  int heightAdjust = 0;
  int xPos = PLOT_X;
  
  int i = 0;
  int groupSize = colorMap.size();
  groups = new ArrayList();
  for (HashMap.Entry group : colorMap.entrySet()) {
    if (groupSize <= 3){
      heightAdjust += 2 * Y_STAGGER;
      
    }
    currentGroup = group.getKey().toString();
    currentColor = (int) group.getValue();
    groups.add(new Group(xPos + BLOCK_WIDTH, height-heightAdjust, currentGroup, currentColor));
    
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
    if (axis.label.equals(label)) {
      return axis;
    }
  }
  return null;
}

float getValueFromYPosOnAxis(float yPos, Axis axis) { // TODO: Move this method into axis class
  float yDist = axis.y - yPos;
  return (((yDist / AXIS_HEIGHT) * (axis.max - axis.min)) + axis.min);
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
      axis.dragOffsetY = mouseY - axis.y;
    } else if (axis.isPosInsideAxis(mouseX, mouseY)) {
      float value = getValueFromYPosOnAxis(mouseY, axis);
      QuantFilter quantFilter = new QuantFilter(value, value); // TODO: Don't set movingValue until mouse is dragged
      axis.quantFilter = quantFilter; 
      axis.isFilterBeingDragged = true;
    }
  }
  applyAxisFilters();
  createDisplayedEntries();
}

void mouseDragged() {
  for (Axis axis : axes) {
    if (axis.isBeingDragged) {
      axis.x = mouseX;
      axis.y = (int) (mouseY - axis.dragOffsetY);
      repositionLinesFromAxes();
    } else if (axis.isFilterBeingDragged) {
      if (axis.isYPosInsideAxis(mouseX, mouseY)) {
        float newValue = getValueFromYPosOnAxis(mouseY, axis);
        QuantFilter axisFilter = axis.quantFilter;
        axisFilter.setMovingValue(newValue);
        axisFilter.setFilterOn(true);
        axis.quantFilter = axisFilter;
        createDisplayedEntries();
      }
    }
  }
}

void mouseReleased() {
  for (int i = 0; i < axes.size(); i++) {
    Axis axis = axes.get(i);
    if (axis.isBeingDragged) {
      reorderAxes(i, axis);
      createDisplayedEntries();
    }
    axis.isFilterBeingDragged = false;
  }
}

void mouseMoved() {
   resetLineGroupFilterBools();
   for (Group group: groups) {
      if (group.isPosInsideLabel(mouseX, mouseY)) {
         filterLinesByGroup(group.getLabel());
         createDisplayedEntries();
      }
   }
}

void resetLineGroupFilterBools() {
  for (Line line: lines) {
    line.setGroupFilterBool(true);
  }
}

void reorderAxes(int prevIndex, Axis draggedAxis) {
  
  int newIndex = getAxisIndexFromXPosition(draggedAxis.x);
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
    axis.x = axisXPositions.get(i);
    axis.y = PLOT_Y + AXIS_HEIGHT;
    axis.isBeingDragged = false;
    axis.staggered = labelStagger;
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
        positions.add(new Position(axis.x, axis.getYPosOnAxisFromValue(quantValue)));
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
      if (axis.quantFilter != null && axis.quantFilter.isFilterOn) {
        float itemValue = lineItem.quantMap.get(axis.label);
        if (!axis.quantFilter.isValueInRange(itemValue)) {
          allFiltersPass = false;
        }
      }
    }
    line.setQuantFilterBool(allFiltersPass);
  }
}

void drawHeaders(){
  fill(0);
  textSize(14);
  textAlign(LEFT, CENTER);
  String about = "This plot displays quantitative attributes of items from '" + PATH + 
  "' as parrallel coordinates. " + 
  "CLICK & DRAG the reorder icon at the bottom of each axis to swap its order with another axis. " + 
  "Items names are displayed in sorted order, by whichever is arranged first (from left). " +
  "CLICK & DRAG vertically along an axis to filter. " + 
  "HOVER over color group names to exclusively display that group.";
  text(about, PLOT_X, height - HEADER_STAGGER + Y_STAGGER, BLOCK_WIDTH, HEADER_STAGGER - Y_STAGGER);
  textSize(24);
  text("About", PLOT_X, height - HEADER_STAGGER); 
  text(catName, PLOT_X + BLOCK_WIDTH, height - HEADER_STAGGER);
  text("Items", PLOT_X + 2 * BLOCK_WIDTH, height - HEADER_STAGGER);
}

void createDisplayedEntries() {
  
  final String quantKey = axes.get(0).label; // Need to declare final to use in comparator, First axis determines table entries
  ArrayList<Line> optionLines = new ArrayList();
  for (Line line: lines) {
    if (line.quantFilterBool && line.groupFilterBool) { // Only include displayed lines in table entries
      optionLines.add(line);
    } 
   } 

   Collections.sort(optionLines, new Comparator<Line>() { // No access to streams so are defining our own comparator here to sort based on the value of the first axis
     public int compare(Line l1, Line l2) {
       float value1 = l1.item.quantMap.get(quantKey);
       float value2 = l2.item.quantMap.get(quantKey);
       if (value1 == value2) {
          return 0;
       } 
       return (value1 < value2) ? -1: 1;       
    }
   });
   
   if (!isTableSortedAscending) {
     Collections.reverse(optionLines);
   }
   
   displayedEntries = new ArrayList();
   float yPos = height - HEADER_STAGGER + 40; // TODO: Make these constants
   
   int numOptions = optionLines.size();
   for (int i = 0; i < min(10, numOptions); i++) { // Only display the first 10, or numOptions if it is less than 10
     Line optionLine = optionLines.get(i);
     TableEntry entry = new TableEntry(BLOCK_WIDTH * 2, yPos, optionLine.getItem().getNameValue(), optionLine.colorHex);
     displayedEntries.add(entry);
     yPos += 20;
   }
  }

// Draw Method

void draw(){
  background(#FFFFFF);
  drawHeaders();
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
  for (TableEntry entry: displayedEntries) {
    entry.display();
  }
}