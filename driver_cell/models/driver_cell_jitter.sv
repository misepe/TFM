`timescale 1ps/1ps
import cds_rnm_pkg::*; // Importing the Cadence RNM package
module driver_cell (
    input [6:0] datain,      // Digital binary control of the converter
    input [6:0] datainb,      // Digital binary control of the converter negate
    input [16:0] datatherm,      // Digital thermometrical control of the converter
    input [16:0] datathermb,      // Digital thermometrical control of the converter negate
    input pdb, //power down negate signal
    input real vddana_1p8,       // 1.8V power supply
    input real vddana_0p8,       // 0.8V power supply
    input real vssana,           // ground
    output logic [6:0] databinout, //Resyncronized sata driving the current switches
    output logic [6:0] databinoutb, //Resyncronized sata driving the current switches negate
    output logic [16:0] datathermout, //Resyncronized sata driving the current switches
    output logic [16:0] datathermoutb //Resyncronized sata driving the current switches negate
);
    
    bit input_check; // Variable to check the inputs signals 1: all inputs are correct, 0: at least one input is incorrect
    bit vddana_1p8_check = 1; // Variable to check the input voltage vddana_1p8 1: correct, 0: incorrect
    bit vddana_0p8_check = 1; // Variable to check the input voltage vddana_0p8 1: correct, 0: incorrect
    bit vssana_check = 1; // Variable to check the input voltage vssana 1: correct, 0: incorrect

    //to check that vddana_1p8 voltage is within the boundaries +/-5%
    parameter real VDDANA_1P8_REF = 1.8; // 1.8 V
    always @(vddana_1p8) begin
        if(vddana_1p8 >= VDDANA_1P8_REF*0.95 && vddana_1p8 <= VDDANA_1P8_REF*1.05) begin
            vddana_1p8_check = 1;
        end else begin
            vddana_1p8_check = 0;
        end
        vddana_1p8_boundaries: assert (vddana_1p8 >= VDDANA_1P8_REF*0.95 && vddana_1p8 <= VDDANA_1P8_REF*1.05) else $warning("Input voltge vddana_1p8 is out of bounds: %0.2f V", vddana_1p8);
    end

    //to check that vddana_0p8 voltage is within the boundaries +/-5%
    parameter real VDDANA_0P8_REF = 0.8; // 0.8 V
    always @(vddana_0p8) begin
        if(vddana_0p8 >= VDDANA_0P8_REF*0.95 && vddana_0p8 <= VDDANA_0P8_REF*1.05) begin
            vddana_0p8_check = 1;
        end else begin
            vddana_0p8_check = 0;
        end
        vddana_0p8_boundaries: assert (vddana_0p8 >= VDDANA_0P8_REF*0.95 && vddana_0p8 <= VDDANA_0P8_REF*1.05) else $warning("Input voltge vddana_0p8 is out of bounds: %0.2f V", vddana_0p8);
    end

    //to check that vssana voltage is within the boundaries +/-5%
    parameter real VSSANA_REF = 0.0; // 0.0 V
    parameter real VSSANA_MIN = VSSANA_REF -0.05; // -0.05 V
    parameter real VSSANA_MAX = VSSANA_REF +0.05; // 0.05 V
    always @(vssana) begin
        if(vssana >= VSSANA_MIN && vssana <= VSSANA_MAX) begin
            vssana_check = 1;
        end else begin
            vssana_check = 0;
        end
        vssana_boundaries: assert (vssana >= VSSANA_MIN && vssana <= VSSANA_MAX) else $warning("Input voltge vssana is out of bounds: %0.2f V", vssana);
    end

     //Generate non lineartinies: jitter
    real jitter_databinout;
    real jitter_databinoutb;
    real jitter_datathermout;
    real jitter_datathermoutb;
    int t_prop=10; //tiempo de propagación de las señales en el bloque

    /*
    //Distribución uniforme
    function real generate_jitter_temp();
        real temp;
        temp = $urandom()%20;
        $display("Raw binary jitter = %0d", temp);
        $display("Binary jitter= %0.4f", ((temp)-10));
        return ((temp)-10);
    endfunction*/

    function real generate_jitter_temp();
        // Variables
        int seed ;  // Semilla para el generador de números aleatorios
        int mean = 0;         // Promedio de la distribución
        int std_dev = 1;     // Desviación estándar, sigma =1ps
        real random_value;      // Valor aleatorio generado

        // Genera valor aleatorio
        seed = $urandom();
        random_value = $dist_normal(seed, mean, std_dev);
        `ifndef DEBUG_DISPLAY
        $display("jitter temporal = %0d seed = %0d media =%0d sigma = %0d", random_value, seed, mean, std_dev);
        `endif
        return random_value;
    endfunction

    /*initial begin
        // Binary part jitter generation
          jitter_databinout = generate_jitter_temp();
        // Binary negated part jitter generation
          jitter_databinoutb = generate_jitter_temp();
        // Thermometric part jitter generation
          jitter_datathermout = generate_jitter_temp();
        // Thermometric negated part jitter generation
          jitter_datathermoutb = generate_jitter_temp();
    end*/

    always_comb begin

        if (vddana_1p8_check && vddana_0p8_check && vssana_check ) begin
            input_check = 1; // All inputs are correct
        end else begin
            input_check = 0; // At least one input is incorrect
            $warning("Input signals boundaries are not correct: vddana_1p8_check=%0d, vddana_0p8_check=%0d, vssana_check=%0d,", vddana_1p8_check, vddana_0p8_check, vssana_check);
        end

    end

    always@(datain,input_check,pdb)begin
        if(input_check == 1 && pdb == 1) begin
            jitter_databinout = generate_jitter_temp();
            databinout = #(t_prop+jitter_databinout) datain;
        end else if(input_check == 1 && pdb ==0) begin
            jitter_databinout = generate_jitter_temp();
            databinout =#(t_prop+jitter_databinout) 'z;
        end
    end
    always@(datainb,input_check,pdb)begin
        if(input_check == 1 && pdb == 1) begin
            jitter_databinoutb = generate_jitter_temp();
            databinoutb =#(t_prop+jitter_databinoutb) datainb;
        end else if(input_check == 1 && pdb ==0) begin
            jitter_databinoutb = generate_jitter_temp();
            databinoutb =#(t_prop+jitter_databinoutb) 'z;
        end
    end
    always@(datatherm,input_check,pdb)begin
        if(input_check == 1 && pdb == 1) begin
            jitter_datathermout = generate_jitter_temp();
            datathermout =#(t_prop+jitter_datathermout) datatherm;
        end else if(input_check == 1 && pdb ==0) begin
            jitter_datathermout = generate_jitter_temp();
            datathermout =#(t_prop+jitter_datathermout) 'z;
        end
    end
    always@(datathermb,input_check,pdb)begin
        if(input_check == 1 && pdb == 1) begin
            jitter_datathermoutb = generate_jitter_temp();
            datathermoutb =#(t_prop+jitter_datathermoutb) datathermb;
        end else if(input_check == 1 && pdb ==0) begin
            jitter_datathermoutb = generate_jitter_temp();
            datathermoutb =#(t_prop+jitter_datathermoutb) 'z;
        end
    end

endmodule