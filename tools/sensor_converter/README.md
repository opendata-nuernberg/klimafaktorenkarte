
# sensor converter
This is a cli tool to fetch sensor data from the sensor.community and convert it into a structure optimized for our purposes.


## usage
Get data within a radius of 20km around nuremberg.

```
// binary
bin/sensor_converter fetch --lat 49.450 --long 11.079 --radius 20 convert > ../../ui/data.json

// dart file
dart bin/sensor_converter.dart fetch --lat 49.450 --long 11.079 --radius 20 convert > ../../ui/data.json
```

## build cli tool

```
dart compile exe bin/sensor_converter.dart -o bin/sensor_converter
```

## links
https://archive.sensor.community/2023-09-12/


## common sensors around nuernberg
The following sensors are particularly common in the nuremberg area (20km): 
- BME280: 65x
- DHT22: 111x
- SDS011: 265x

Currently we only support BME280 and DHT22. SDS011 doesn't provide any temperature data and is therefore useless for our purposes. There are more less common sensors in our area, that could be supported in the future.

The following code snippet documents the structure of the luftdatenApi (sensor.community) for the respective sensors:
''' 
    bool isIndoor() => map['location']['indoor'] == 0;
    String getLong() => map['location']['longitude'];
    String getLat() => map['location']['latitude'];

    dynamic getSensorValue(String sensorType, String valueType) {
        final type = map['sensor']['sensor_type']['name']
        if(type == sensorType) {
            for(final data in map['sensordatavalues']) {
                final type = data['value_type'];
                final value = data['value']
                if(type == valueType) {
                    return value;
                }
            }
        }
        throw Exception('invalid');
    }


    void fetch_BME280() {
        final temp = getSensorValue('BME280', 'temperature') as String;
        final hum = getSensorValue('BME280', 'humidity') as String;
        final pressure = getSensorValue('BME280', 'pressure') as String;
        final pressureSea = getSensorValue('BME280', 'pressure_at_sealevel') as double;
    }

    void fetch_DHT22() {
        final temp = getSensorValue('DHT22', 'temperature') as String;
        final hum = getSensorValue('DHT22', 'humidity') as String;
    }

    void fetch_SDS011() {
        // Ultrafine dust particles with a diameter of 0 – 2.5 micrometres (μm/m3). Output PM2.5
        // Fine dust particles with a diameter 2.5 – 10 micrometres (μm/m3). Output PM10
        final p1 = getSensorValue('SDS011', 'P1');
        final p2 = getSensorValue('SDS011', 'P2');
        final type = map['sensor']['sensor_type']['name']
    }
'''

## building h3lib
The h3_dart library expects a local build of the h3lib. The following commands should help to build the library for your platform. A MacOS build of h3lib is part of this repository.

```
cd $HOME/.pub-cache/hosted/pub.dev/h3_ffi-0.6.2/c/h3lib
mkdir build
cd build
cmake ..
make
```
