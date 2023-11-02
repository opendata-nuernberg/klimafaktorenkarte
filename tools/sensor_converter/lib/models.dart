class ComulativeTemperatureData {
  List<SensorArea> res1Hexagons;
  List<SensorArea> res2Hexagons;
  List<SensorArea> res3Hexagons;
  List<SensorArea> res4Hexagons;
  List<SensorArea> res5Hexagons;
  List<SensorArea> res6Hexagons;
  List<SensorArea> res7Hexagons;
  List<SensorArea> res8Hexagons;
  List<SensorArea> res9Hexagons;
  List<SensorArea> res10Hexagons;
  List<SensorArea> res11Hexagons;
  List<SensorArea> res12Hexagons;
  List<SensorArea> res13Hexagons;
  List<SensorArea> res14Hexagons;
  List<SensorArea> res15Hexagons;

  ComulativeTemperatureData(
      this.res1Hexagons,
      this.res2Hexagons,
      this.res3Hexagons,
      this.res4Hexagons,
      this.res5Hexagons,
      this.res6Hexagons,
      this.res7Hexagons,
      this.res8Hexagons,
      this.res9Hexagons,
      this.res10Hexagons,
      this.res11Hexagons,
      this.res12Hexagons,
      this.res13Hexagons,
      this.res14Hexagons,
      this.res15Hexagons);

  Map<String, dynamic> toJson() {
    return {
      'res1': res1Hexagons.map((e) => e.toJson()).toList(),
      'res2': res2Hexagons.map((e) => e.toJson()).toList(),
      'res3': res3Hexagons.map((e) => e.toJson()).toList(),
      'res4': res4Hexagons.map((e) => e.toJson()).toList(),
      'res5': res5Hexagons.map((e) => e.toJson()).toList(),
      'res6': res6Hexagons.map((e) => e.toJson()).toList(),
      'res7': res7Hexagons.map((e) => e.toJson()).toList(),
      'res8': res8Hexagons.map((e) => e.toJson()).toList(),
      'res9': res9Hexagons.map((e) => e.toJson()).toList(),
      'res10': res10Hexagons.map((e) => e.toJson()).toList(),
      'res11': res11Hexagons.map((e) => e.toJson()).toList(),
      'res12': res12Hexagons.map((e) => e.toJson()).toList(),
      'res13': res13Hexagons.map((e) => e.toJson()).toList(),
      'res14': res14Hexagons.map((e) => e.toJson()).toList(),
      'res15': res15Hexagons.map((e) => e.toJson()).toList(),
    };
  }
}

class SensorArea {
  BigInt h3Index;
  double temperature;
  double humidity;
  int numberOfSensors;
  SensorArea(
      this.h3Index, this.temperature, this.humidity, this.numberOfSensors);

  Map<String, dynamic> toJson() {
    return {
      'index': h3Index.toRadixString(16),
      'temperature': temperature,
      'humidity': humidity,
      'numberOfSensors': numberOfSensors,
    };
  }
}
