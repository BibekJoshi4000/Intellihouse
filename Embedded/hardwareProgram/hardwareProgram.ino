#include <DHT.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include<string.h>
#include <Arduino_JSON.h>

#define led_1  22     //Relay 01
#define led_2  21     //Relay 02
#define led_3  19     //Relay 03
#define led_4  18     //Relay 04

#define DHTPIN 32     // DHT pin
#define DHTTYPE DHT11      //DHT type
DHT dht(DHTPIN, DHTTYPE);  //DHT object defined

// define wifi ssid and password
const char* ssid = "MSI 3448";
const char* password = "3{X45n05";

// defined time delays
unsigned long lastTime = 0;
unsigned long timerDelay = 5000;

// Variables to store sensor data
float temp;
float humi;

// server address to PUT values of dht-11 sensor
const char* dhtValues = "https://intellihouse.cyclic.app/api/v1/updateSensor";

// server address to GET values for relay
const char* relayPosition = "https://intellihouse.cyclic.app/api/v1/relayData";

void setup() {
  
  wifiinit(); // wifi function called
  
  dht.begin(); // dht object initialized

}

void loop() {
  
  humtep();  // Function to get the humidity and temperature and to PUT value to server

  Relay();

}

// Function for wifi connection and Serial monitor begin
void wifiinit(){
    Serial.begin(9600);

  WiFi.begin(ssid, password);
  Serial.println("Connecting");

  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");

  }
}

// function to check temperature and humidity (dataSending function is called here)
void humtep(){
   humi = dht.readHumidity();
   temp = dht.readTemperature();

  Serial.print(F("Humidity: "));
  Serial.print(humi);
  Serial.print(F("%  Temperature: "));
  Serial.print(temp);
  Serial.println(F("°C "));
  dataSending();
}

// function to update the value of dht sensor to the server
void dataSending(){
    if ((millis() - lastTime) > timerDelay) {
    
    if(WiFi.status()== WL_CONNECTED){

      HTTPClient http;
    

      http.begin(dhtValues);
      
   
      http.addHeader("Content-Type", "application/json");

      Serial.println("Inside data sending");

      Serial.println(temp); 
      Serial.println(humi);

      String t = String(temp);
      String h = String(humi);  

      int httpResponseCode = http.PUT("{\"temperature\":" + t + ",\"humidity\": "+ h +"}");

      Serial.println(t);
      Serial.println(h);


   
     
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
        
      http.end();
    }
    else {
      Serial.println("WiFi Disconnected");
    }
  }
}


// function to Check whether to switch the lights off or on
void Relay(){
  String payload = "{}";
    if(WiFi.status()== WL_CONNECTED){
      
      HTTPClient http1;

          
      // Your Domain name with URL path or IP address with path
      http1.begin(relayPosition);

 
      // Send HTTP GET request
      int httpResponseCode = http1.GET();
      
      if (httpResponseCode>0) {
        Serial.print("HTTP Response code: ");
        Serial.println(httpResponseCode);
         payload = http1.getString();
        Serial.println(payload);
      }
      else {
        Serial.print("Error code: ");
        Serial.println(httpResponseCode);
      }
      // Free resources
      http1.end();
    }
    
  JSONVar myObject = JSON.parse(payload);

  // JSON.typeof(jsonVar) can be used to get the type of the var
  if (JSON.typeof(myObject) == "undefined") {
    Serial.println("Parsing input failed!");
    return;
  }

  Serial.print("JSON object = ");
  Serial.println(myObject);
  JSONVar keys = myObject.keys();
  Serial.println("---------------------------------->");
  String demo  = myObject[keys[0]];
  Serial.println(myObject[keys[0]]);
  Serial.println(demo);


}