module tb_level_shifter;
    // Señales wreal
    real vin_tb;      // Señal de entrada
    real vcc_low_tb;  // Fuente de alimentación de nivel bajo
    real vcc_high_tb; // Fuente de alimentación de nivel alto
    real vout_tb;     // Señal de salida

    // Instancia del DUT (Device Under Test)
    level_shifter #(.THRESHOLD(0.5)) dut (
        .VIN(vin_tb),
        .VCC_LOW(vcc_low_tb),
        .VCC_HIGH(vcc_high_tb),
        .VOUT(vout_tb)
    );

     // Variables para el barrido
    real vin_start;   // Nivel inicial del barrido
    real vin_end;     // Nivel final del barrido
    real step;        // Incremento del barrido
    integer num_steps; // Número de pasos calculado dinámicamente

    initial begin
        // Configuración inicial
        vcc_low_tb = 0.0;   // Nivel bajo
        vcc_high_tb = 1.8;  // Nivel alto
        step = 0.01;         // Incremento del barrido

        // Barrido ascendente
        vin_start = -1.0;   // Nivel inicial del barrido ascendente
        vin_end = 1.0;      // Nivel final del barrido ascendente
        num_steps = $ceil((vin_end - vin_start) / step); // Calcular número de pasos
        vin_tb = vin_start;

        $display("Barrido ascendente:");
        repeat (num_steps) begin
            #10;
            vin_tb = vin_tb + step;
            $display("VIN = %0.2f, VOUT = %0.2f", vin_tb, vout_tb);
        end

        // Barrido descendente
        vin_start = 1.0;    // Nivel inicial del barrido descendente
        vin_end = -1.0;     // Nivel final del barrido descendente
        num_steps = $ceil((vin_start - vin_end) / step); // Calcular número de pasos
        vin_tb = vin_start;

        $display("Barrido descendente:");
        repeat (num_steps) begin
            #10;
            vin_tb = vin_tb - step;
            $display("VIN = %0.2f, VOUT = %0.2f", vin_tb, vout_tb);
        end

        // Barrido fuera de rango
        vin_start = -2.0;   // Nivel inicial del barrido fuera de rango
        vin_end = 2.0;      // Nivel final del barrido fuera de rango
        num_steps = $ceil((vin_end - vin_start) / step); // Calcular número de pasos
        vin_tb = vin_start;

        $display("Barrido fuera de rango:");
        repeat (num_steps) begin
            #10;
            vin_tb = vin_tb + step;
            $display("VIN = %0.2f, VOUT = %0.2f", vin_tb, vout_tb);
        end

        $finish;
    end
endmodule