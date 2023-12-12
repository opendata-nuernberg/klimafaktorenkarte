# Hardware

The board uses the ESP32-C3 microcontroller, which provides both WiFi and Bluetooth connectivity, as well as an integrated USB-JTAG adapter.

![Photo of the assembled PCB](IMG_0758.jpg)

The system is powered from a USB Type-C port. The TLV62568DBV buck converter is used to supply the system with 3.3V.

As far as sensors are concerned, the SHT40 is used to measure temperature and humidity, and the DPS310 is used to measure the atmospheric pressure.

JLCPCB was used to manufacture and assemble the board. The jlcpcb folder contains the ordering files.