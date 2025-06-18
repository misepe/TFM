//Módulo que convierte la tensión en corriente con una constante de escala (resistencia equivalente)
// Iout=Vin/R

`timescale 1ns/1ps

module v2i import cds_rnm_pkg::*; (
    input wreal1driver VIN,         // VIN es un valor de tensión real
    output wreal1driver IOUT        // IOUT es un valor de corriente real 
    //TODO: tengo que hacer que se enrieenda que es una corriente (dirección?)
    );	

  parameter real R=1000.0;         // Parámetro que define la relación V/I(ej. 1k Ohm)
  parameter real I_MIN = -10.0e-3; // Valor mínimo de corriente
  parameter real I_MAX = 10.0e-3;  // Valor máximo de corriente
  parameter real V_MIN = -5.0;    // Valor mínimo de tensión
  parameter real V_MAX = 5.0;     // Valor máximo de tensión

  real VIN_temp; // Variable temporal para VIN

  assign VIN_temp = (VIN < V_MIN) ? V_MIN : 
                (VIN > V_MAX) ? V_MAX : VIN; // Limitamos el rango de VIN

  assign IOUT = (VIN_temp/R > I_MAX) ? I_MAX : 
                (VIN_temp/R < I_MIN) ? I_MIN : VIN_temp/R; // Limitamos el rango de IOUT

endmodule


