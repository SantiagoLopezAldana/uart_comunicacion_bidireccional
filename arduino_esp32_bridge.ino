#include <Arduino.h>
static const int FPGA_RX_PIN = 16; // RX del ESP32 recibe desde TX de FPGA
static const int FPGA_TX_PIN = 17; // TX del ESP32 transmite hacia RX de FPGA
static const uint32_t PC_BAUD = 9600;
static const uint32_t FPGA_BAUD = 9600;
HardwareSerial FPGA_Serial(2);

void setup(){
  Serial.begin(PC_BAUD);
  delay(500);
  FPGA_Serial.begin(FPGA_BAUD, SERIAL_8N1, FPGA_RX_PIN, FPGA_TX_PIN);
  Serial.println("ESP32 listo: puente PC <-> FPGA");
}
void loop(){
  if(Serial.available()){
    long valor = Serial.parseInt();

    while(Serial.available()){
      Serial.read();
    }
    if(valor > 0 || Serial.peek()=='0'){
      FPGA_Serial.write((uint8_t)valor);
      Serial.print("Enviando a FPGA: ");
      Serial.println(valor);
    }
  }

  if(FPGA_Serial.available()){
    uint8_t respuesta = FPGA_Serial.read();
    Serial.print("Respuesta: ");
    Serial.println(respuesta);
  }
}
