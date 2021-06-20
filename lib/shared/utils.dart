class Utils {
  /// Removes empty keys from the map
  static Map<String, dynamic> removeEmptyKeys(Map<String, dynamic> object) {
    Map<String, dynamic> cleanedMap = Map<String, dynamic>();

    object.keys.forEach((String key) {
      if (object[key] != null) {
        cleanedMap.addAll({key: object[key]});
      }
    });

    return cleanedMap;
  }

  /// Returns the lowest number in the list
  static double getLowestNumber(List<double> values) {
    double value = double.infinity;

    values.forEach((element) => (element < value) ? value = element : null);

    return (value == double.infinity) ? 0.0 : value;
  }

  /// Returns the lowest number in the list
  static double getGreatestNumber(List<double> values) {
    double value = -double.infinity;

    values.forEach((element) => (element > value) ? value = element : null);

    return (value == -double.infinity) ? 0.0 : value;
  }

  /// Smoothes list of doubles to a list with a given number of values
  /// If list is smaller than n, the list is returned
  static List<double> smoothList(List<double> values, int n) {
    if (n > values.length) return values;

    List<double> averages = [];
    double sectorSize = values.length / n;

    int i = 0;
    for (int si = 0; si < n; si++) {
      double n1 = si * sectorSize;
      double n2 = (si + 1) * sectorSize;
      double sum = 0;

      if (i > 0) {
        sum += values[i] * (i - n1 + 1);
        i = i + 1;
      }

      while (i < n2 - 1) {
        sum += values[i];
        i = i + 1;
      }

      if (i < values.length) {
        sum += values[i] * (n2 - i);
      }

      averages.add(sum / sectorSize);
    }

    return averages;
  }
}
