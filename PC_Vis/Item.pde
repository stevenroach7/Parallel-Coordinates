

class Item {
  
  String nameKey;
  String nameValue;
  HashMap<String, Float> quantMap;
  String catKey;
  String catValue;
  
  Item(String tempNameKey, String tempNameValue, HashMap<String, Float> tempQuantMap, String tempCatKey, String tempCatValue) {
    nameKey = tempNameKey;
    nameValue = tempNameValue;
    quantMap = tempQuantMap;
    catKey = tempCatKey;
    catValue = tempCatValue;
  }
  
  String toString() {
    
    StringBuilder sb = new StringBuilder();
    
    sb.append(nameKey);
    sb.append(" = ");
    sb.append(nameValue);
    sb.append(", ");
    
    sb.append(catKey);
    sb.append(" = ");
    sb.append(catValue);
    sb.append(", ");
    
    sb.append("quantValues = ");
    for (HashMap.Entry quantEntry: quantMap.entrySet()) {
       sb.append(quantEntry.getKey());
       sb.append(" = ");
       sb.append(quantEntry.getValue());
       sb.append(", ");
    }
    sb.deleteCharAt(sb.length() - 2);
    sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
  }
  
}