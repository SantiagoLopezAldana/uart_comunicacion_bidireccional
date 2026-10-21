clear
clc

PORT = "COM3"; % Cambiar por el puerto correspondiente al ESP32
BAUD = 9600;

s = serialport(PORT, BAUD);
pause(2);

disp("Esperando datos desde FPGA...");

while true
    if s.NumBytesAvailable > 0
        dato = read(s, 1, "uint8");
        disp(['Recibido: ', num2str(double(dato))]);
    end
end