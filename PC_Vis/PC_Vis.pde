

ArrayList<Item> items;

void setup() {
  
  TableReader tableReader = new TableReader("../Data/cars-cleaned.tsv");
  items = tableReader.parseTable();
  
}