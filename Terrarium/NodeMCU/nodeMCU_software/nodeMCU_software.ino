// todo create function to send temperature (execute every 30s)
// todo create function to send request for settings (execute every 5s)
// todo read temperature and modify lighting and heating (execute continuously)

// ----

// This program will send the temperature of the hot side and cold side of the terrarium to the ReptiC server.
// It will also pull the settings for the thermostat from the server (with failsafe temperature backup hardcoded), it
// will also receive the values for the lighting (when to enable).
//
// To use this programm, you'll have to modify a couple of values:
//    - modify the String 'httpDestination' declaration so that it uses the IP-address of your ReptiC server.
//    - modify "WiFi_SSID" and "WiFi_PASSWORD" so that it can connect to your WiFi.
//    - modify the backup settings that closely match your desired settings for the terrarium

//------------------------------------------------------------------------------------------------------------------

// Driver: https://kig.re/2014/12/31/how-to-use-arduino-nano-mini-pro-with-CH340G-on-mac-osx-yosemite.html

// Preferences --> additional board manager: http://arduino.esp8266.com/stable/package_esp8266com_index.json
// Tools -> Board -> Board Manager... -> Look for "esp8266" -> Install
// Sketch -> Include Library -> Manage Libraries.. search for DallasTemperature and install it.
// Sketch -> Include Library -> Manage Libraries.. search for OneWire and install it.
// Sketch -> Include Library -> Manage Libraries.. search for ArduinoJSON and install it.

// Board:         NodeMCU V1.0 (ESP-12E module)
// CPU freq:      80MHz
// Baudrate:      115200
// Flash size:    4M (3M SPIFFS)
// Programmer:    AVRISP mkII

//------------------------------------------------------------------------------------------------------------------

// HOW TO DEBUG THE SENT DATA
//
// First determine the IP address of your pc, connected on the same WiFi, e.g.: 192.168.1.100
// Change the code so that it sends data to this address on port 9999, e.g.: httpDestination = "http://192.168.1.100:9999";
// On your pc, open a terminal and execute this command: ncat -l 9999
// Start your program

//------------------------------------------------------------------------------------------------------------------

#include "ESP8266WiFi.h"
#include <ESP8266HTTPClient.h>

#include <ArduinoJson.h>

#include <OneWire.h>
#include <DallasTemperature.h>

//------------------------------------------------------------------------------------------------------------------

//WiFi authentication
char WiFi_SSID[] = "Wile E. Coyote";
char WiFi_PASSWORD[] = "password";

//HTTP POST parameters
String httpDestination = "http://192.168.1.103/datacatcher.php";

//Backup settings
float HOTSIDE_DAY = 30;
float HOTSIDE_NIGHT = 25;

float COLDSIDE_DAY= 28;
float COLDSIDE_NIGHT = 22;

float DELTA = 1;    // When the temperature drops x degrees, start heating again till the desired temperature

// TODO settings for lighting


//------------------------------------------------------------------------------------------------------------------

#define USE_SERIAL_DEBUGGING          // comment this line if you do not want to use serial debugging

#ifdef USE_SERIAL_DEBUGGING
    #define debugPrint(a) (Serial.println(a))
#else
    #define debugPrint(a)
#endif

//------------------------------------------------------------------------------------------------------------------

//The temperature sensor is one pin D4
#define ONE_WIRE_BUS D4

//Create the temperature sensor objet
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature DS18B20(&oneWire);

String httpContentTypeHeader = "application/x-www-form-urlencoded";

//------------------------------------------------------------------------------------------------------------------

//This will read the temperature from only 1 DS18B20 (one wire)
float getTemperature() {
  float temp;
  do {
    DS18B20.requestTemperatures(); 
    temp = DS18B20.getTempCByIndex(0);        //Use this index if you have more sensors on the bus
    delay(100);
  } while (temp == 85.0 || temp == (-127.0)); //Eliminate false readings
  return temp;
}

//------------------------------------------------------------------------------------------------------------------

void setup() {

  #ifdef USE_SERIAL_DEBUGGING
      Serial.begin(115200);
      Serial.println();
  #endif

  //WiFi connection
  WiFi.begin(WiFi_SSID, WiFi_PASSWORD);

  //Wait for a succesfull connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    debugPrint("Waiting for connection");
  }
  debugPrint("Connected");

  // Temperature sensors
  DS18B20.begin();
}

//------------------------------------------------------------------------------------------------------------------

void loop() {
  DynamicJsonBuffer sendBuffer;
  DynamicJsonBuffer receiveBuffer;
  String HttpBody = "";
  int httpCode = 0;
  String payload = "";

  debugPrint("--------------------------------------------");

  //Get the temperature
  float temperature = getTemperature();

  //Create the json content
  JsonObject& toSendJson = sendBuffer.createObject();
  toSendJson["reptile"] = "Diablo";
  toSendJson["temperature"] = temperature;
  toSendJson.printTo(HttpBody);

  debugPrint("\nThis is the body of our HTTP POST that we will send:");
  debugPrint(HttpBody);

 
 if(WiFi.status() == WL_CONNECTED){
   HTTPClient http;
   
   http.begin(httpDestination);
   http.addHeader("Content-Type", httpContentTypeHeader);

   //Send the request and get the response payload
   httpCode = http.POST(HttpBody);
   payload = http.getString();

   debugPrint("\nThis is the received data:");
   debugPrint(payload);

   //Close connection
   http.end();
 }else{
    debugPrint("Error in WiFi connection"); 
    delay(3000);
    return;  
 }

 if(httpCode != 200) {
    debugPrint("HTTP return code is not equal to 200..."); 
    delay(3000);
    return;
 }

 //Parse JSON data
 JsonObject& receivedJson = receiveBuffer.parseObject(payload);

 if (!receivedJson.success()) {
     debugPrint("Parsing failed");
     delay(3000);
     return;
 }
 
 float value1 = receivedJson["hotSide"];
 float value2 = receivedJson["coldSide"];
 debugPrint("\nThis is our received data parsed:");
 debugPrint(value1);
 debugPrint(value2);


   


 
  delay(3000);  //Send a request every 3 seconds
}
