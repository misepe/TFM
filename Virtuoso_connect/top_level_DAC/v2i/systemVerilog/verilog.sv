//M?dulo que convierte la tensi?n en corriente con una constante de escala (resistencia equivalente)
// Iout=Vin/R


module v2i (
    input  VIN,         // VIN es un valor de tensi?n real
    output IOUT        // IOUT es un valor de corriente real 
    //TODO: tengo que hacer que se enrieenda que es una corriente (direcci?n?)
    );	

  parameter real R=1000.0;         // Par?metro que define la relaci?n V/I(ej. 1k Ohm)
  parameter real I_MIN = -10.0e-3; // Valor m?nimo de corriente
  parameter real I_MAX = 10.0e-3;  // Valor m?ximo de corriente
  parameter real V_MIN = -5.0;    // Valor m?nimo de tensi?n
  parameter real V_MAX = 5.0;     // Valor m?ximo de tensi?n

  real VIN_temp; // Variable temporal para VIN

  assign VIN_temp = (VIN < V_MIN) ? V_MIN : 
                (VIN > V_MAX) ? V_MAX : VIN; // Limitamos el rango de VIN

  assign IOUT = (VIN_temp/R > I_MAX) ? I_MAX : 
                (VIN_temp/R < I_MIN) ? I_MIN : VIN_temp/R; // Limitamos el rango de IOUT

endmodule


