

class Item {
  
  String nameKey;
  String nameValue;
  ArrayList<String> quantKeys;
  ArrayList<Float> quantValues;
  String catKey;
  String catValue;
  
  Item(String nameKey, String nameValue, ArrayList<String> quantKeys, ArrayList<Float> quantValues, String catKey, String catValue) {
    this.nameKey = nameKey;
    this.nameValue = nameValue;
    this.quantKeys = quantKeys;
    this.quantValues = quantValues;
    this.catKey = catKey;
    this.catValue = catValue;
  }
  
  String getNameKey() {
    return nameKey;
  }
 
  String getNameValue() {
    return nameValue;
  }
  
  ArrayList<String> getQuantKeys() {
    return quantKeys;
  }
  
  ArrayList<Float> getQuantValues() {
    return quantValues;
  }
  
  String getCatKey() {
    return catKey;
  }
  
  String getCatValue() {
    return catValue;
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
    for (int i = 0; i < quantValues.size(); i++) {
       sb.append(quantKeys.get(i));
       sb.append(" = ");
       sb.append(quantValues.get(i));
       sb.append(", ");
    }
    sb.deleteCharAt(sb.length() - 2);
    sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
  }
}