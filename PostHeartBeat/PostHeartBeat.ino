#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

WiFiClient client;
HTTPClient httpClient;

#define sensorPin A0 
#define ledPin 13

const char *WIFI_SSID = "HackaTruckIoT";
const char *WIFI_PASSWORD = "iothacka";
const char *URL = "http://192.168.128.87:1880/postHeartBeat1";

int output_value ;
int LeituraSensor;
int Pulso = 550;
 
void setup(){
    Serial.begin(9600); 
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("Connected");
    delay(2000);
    pinMode(ledPin, OUTPUT);
}

float readHeartBeat(void)
{
    LeituraSensor = analogRead(sensorPin);
    if (LeituraSensor > 30) {
      Serial.println(LeituraSensor); 
    }

     return LeituraSensor;
}

void loop(){
  float heartBeat = readHeartBeat();
  String data = "heartBeat="+String(heartBeat);
  if (heartBeat > 30) {
    httpClient.begin(client, URL);
    httpClient.addHeader("Content-Type", "application/x-www-form-urlencoded");
    httpClient.POST(data);
    String content = httpClient.getString();
    httpClient.end();
  }

    delay(1000);
}