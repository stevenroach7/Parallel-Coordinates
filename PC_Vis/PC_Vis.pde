Table dataTable;
String dataSetName;
Axis exampleAxis;
ArrayList<Item> items;

void setup() {
  size(1000, 1000);
  TableReader tableReader = new TableReader("../Data/cars-cleaned.tsv");
  items = tableReader.parseTable();
  loadData();
}

void loadData(){
  dataSetName = "cars-cleaned.tsv";
  dataTable = loadTable(dataSetName, "header");
  exampleAxis = new Axis(100, 800, "example", 5.0, 500.0);
}

void draw(){
  exampleAxis.display();
}