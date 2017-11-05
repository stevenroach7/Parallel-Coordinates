

class TableReader {

  String path;

  TableReader(String tempPath) {
    path = tempPath;
  }

  ArrayList<Item> parseTable() {

    Table table = loadTable(path);

    if (table.getRowCount() < 3) { // Return null if table doesn't contain any valid entries
      return null;
    }
    TableRow headerRow = table.getRow(0); // First row should be header
    TableRow varTypes = table.getRow(1); // Second row should be labels of type of variable in column

    ArrayList<Item> items = new ArrayList();
    for (int i = 1; i < table.getRowCount(); i++) {

      TableRow row = table.getRow(i);
      
      String nameKey = "";
      String nameValue = "";
      ArrayList<String> quantKeys = new ArrayList();
      ArrayList<Float> quantValues = new ArrayList();
      String catKey = "";
      String catValue = "";
      
      for (int j = 0; j < row.getColumnCount(); j++) {

        switch(varTypes.getString(j).trim()) {
          case "name": 
            nameKey = headerRow.getString(j);
            nameValue = row.getString(j);
            break;
          case "quant":
            quantKeys.add(headerRow.getString(j));
            quantValues.add(row.getFloat(j));
            break;
          case "cat":  
            catKey = headerRow.getString(j);
            catValue = row.getString(j);
            break;
        }
      }
      if (!nameValue.isEmpty()) {
        items.add(new Item(nameKey, nameValue, quantKeys, quantValues, catKey, catValue));
      }
    }
    return items;
  }
  
}