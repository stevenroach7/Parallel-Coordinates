

class QuantFilter {
  
  String label;
  float minValue;
  float maxValue;
  
  QuantFilter(String tempLabel, float tempMinValue, float tempMaxValue) {
    label = tempLabel;
    minValue = tempMinValue;
    maxValue = tempMaxValue;
  }
  
  String getLabel() {
    return label;
  }
  
  boolean isValueInRange(float value) {
    return (value >= minValue && value <= maxValue);
  }
  
}