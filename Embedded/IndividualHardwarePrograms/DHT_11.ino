#include <DHT.h>
DHT dht(32, DHT11);

void setup() {
  Serial.begin(115200);

  dht.begin();

}

void loop() {
   float t = dht.readTemperature();
   float h = dht.readHumidity();
   Serial.print("Temp : ");
   Serial.print(t);
   Serial.println();
   Serial.print("Humidity : ");
   Serial.print(h);

}
