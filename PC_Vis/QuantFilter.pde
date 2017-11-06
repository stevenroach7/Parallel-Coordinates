

class QuantFilter {
  
  float fixedValue;
  float movingValue;
  
  QuantFilter(float tempMinValue, float tempMaxValue) {
    fixedValue = tempMinValue;
    movingValue = tempMaxValue;
  }
  
  boolean isValueInRange(float value) {
    float minValue = min(fixedValue, movingValue);
    float maxValue = max(fixedValue, movingValue);
    return (value >= minValue && value <= maxValue);
  }
  
  float getFixedValue() {
    return fixedValue;
  }
  
  void setFixedValue(float tempFixedValue) {
    fixedValue = tempFixedValue;
  }
  
  float getMovingValue() {
    return movingValue;
  }
  
  void setMovingValue(float tempMovingValue) {
    movingValue = tempMovingValue;
  }
  
}