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

void draw(){
  for (Axis axis: axes) {
    axis.display();
  }
}