// Globals
Table dataTable;
Axis exampleAxis;
ArrayList<Item> items;

// Constants
int AXIS_X = 100;
int AXIS_Y = 500;
int AXIS_HEIGHT = 300;


void setup() {
  // Adjust canvas
  size(1500, 750);
  pixelDensity(displayDensity());
  
  loadData();
  
  // Position canvas elements
  exampleAxis = new Axis(100, 500, AXIS_HEIGHT, "example", 0, 500);
}

void loadData(){
  TableReader tableReader = new TableReader("../Data/cars-cleaned.tsv");
  items = tableReader.parseTable();
}

void draw(){
  exampleAxis.display();
}