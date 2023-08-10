#include <DHT.h>

#define led_1  22     //Relay 01
#define led_2  21     //Relay 02
#define led_3  19     //Relay 03
#define led_4  18     //Relay 04

#define DHTPIN 32     // DHT pin
#define DHTTYPE DHT11      //DHT type

DHT dht(DHTPIN, DHTTYPE);   // defined dht object

void setup() {
  pinMode(led_1, OUTPUT);
  pinMode(led_2, OUTPUT);
  pinMode(led_3, OUTPUT);
  pinMode(led_4, OUTPUT);

  Serial.begin(115200);

  dht.begin();

}

void loop() {

humtep();

blink();

}

void blink(){
  digitalWrite(led_1, 0);
  digitalWrite(led_2, 0);
  digitalWrite(led_3, 0);
  digitalWrite(led_4, 0);
  
  delay(1000);
  
  digitalWrite(led_1, 1);
  digitalWrite(led_2, 1);
  digitalWrite(led_3, 1);
  digitalWrite(led_4, 1);
  
  delay(1000);
}


void humtep(){
   float humi = dht.readHumidity();
   float temp = dht.readTemperature();

  Serial.print(F("Humidity: "));
  Serial.print(humi);
  Serial.print(F("%  Temperature: "));
  Serial.print(temp);
  Serial.println(F("°C "));
}
