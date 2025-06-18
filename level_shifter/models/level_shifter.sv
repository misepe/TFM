//Modulo que permite convertir señales logicas de distintos niveles de tensión
//De momento esta versión no tiene entradas bididreccionales, pero se puede intentar(TODO)

`timescale 1ps/1ps

module level_shifter import cds_rnm_pkg::*;(
    input wreal1driver VIN, //señal de entrada 
    input wreal1driver VCC_LOW, //fuente de alimentación de nivel bajo
    input wreal1driver VCC_HIGH, //fuente de alimentación de nivel alto
    output real VOUT //señal de salida 

    );

    //TODO: pensar si VCC_LOW y VCC_HIGH irian mejor como parámetros

    // Parámetros para definir los límites de los niveles lógicos
    parameter real THRESHOLD = 1.8; // Umbral para decidir el nivel lógico


    //  Modelado de la salida en función de la entrada
    always_comb begin
        if (VIN > THRESHOLD) begin
            VOUT = VCC_HIGH; // Si la entrada supera el umbral, salida en nivel alto
        end else begin
            VOUT = VCC_LOW;  // Si la entrada está por debajo del umbral, salida en nivel bajo
        end
    end


endmodule