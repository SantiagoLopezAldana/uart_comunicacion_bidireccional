clear
clc

PORT = "COM3"; % Cambiar por el puerto correspondiente al ESP32
BAUD = 9600;

s = serialport(PORT, BAUD);
pause(2);

disp("Transmision iniciada");

while true
    valor = input('Ingrese un numero entre 0 y 255: ');
    if valor < 0 || valor > 255
        disp('Valor fuera de rango');
        continue;
    end
    write(s, uint8(valor), "uint8");
    disp(['Enviado: ', num2str(valor)]);
end