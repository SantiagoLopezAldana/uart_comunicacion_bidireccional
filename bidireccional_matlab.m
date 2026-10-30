clear
clc
close all

PORT = "COM4"; % Cambiar por el puerto correspondiente al ESP32
BAUD = 9600;

s = serialport(PORT, BAUD);
pause(2);
flush(s);

disp("Comunicacion bidireccional iniciada");
disp("La FPGA regresara el valor de A^(7/2)");

while true
    valor = input('Ingrese un numero entre 0 y 255: ');
    if valor < 0 || valor > 255
        disp('Valor fuera de rango');
        continue;
    end

    write(s, uint8(valor), "uint8");
    disp(['Enviado: ', num2str(valor)]);
    pause(0.1); 
    if s.NumBytesAvailable >= 4
        respuesta = read(s, 4, "uint8");
        valor_entero = bitshift(uint32(respuesta(1)), 24) + ...
                       bitshift(uint32(respuesta(2)), 16) + ...
                       bitshift(uint32(respuesta(3)), 8) + ...
                       uint32(respuesta(4));        
       
        valor_decimal = double(valor_entero) / 10;%/10
        disp(['Respuesta de FPGA: ', num2str(valor_decimal)]);
        disp('--------------------------------------------------'); 
    elseif s.NumBytesAvailable > 0
        disp('Error: Se recibieron datos incompletos.');
        flush(s);
    else
        disp('No se recibio respuesta');
    end
end