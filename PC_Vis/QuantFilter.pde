

class QuantFilter {
  
  float fixedValue;
  float movingValue;
  boolean isFilterOn;
  
  QuantFilter(float tempMinValue, float tempMaxValue) {
    fixedValue = tempMinValue;
    movingValue = tempMaxValue;
    isFilterOn = false; // Initialize filter on to false and set to true when mouse is dragged
  }
  
  boolean isValueInRange(float value) {
    if (!isFilterOn) {
      return true;
    }
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
  
  boolean getIsFilterOn() {
    return isFilterOn;
  }
  
  void setFilterOn(boolean tempIsFilterOn) {
    isFilterOn = tempIsFilterOn;
  }
}