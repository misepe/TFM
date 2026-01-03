`timescale 1ns/1ps
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
    /*output logic [6:0] databinout, //Resyncronized sata driving the current switches
    output logic [6:0] databinoutb, //Resyncronized sata driving the current switches negate
    output logic [16:0] datathermout, //Resyncronized sata driving the current switches
    output logic [16:0] datathermoutb //Resyncronized sata driving the current switches negate*/
    output real databinout [6:0], //Resyncronized sata driving the current switches
    output real databinoutb [6:0], //Resyncronized sata driving the current switches negate
    output real datathermout [16:0], //Resyncronized sata driving the current switches
    output real datathermoutb [16:0] //Resyncronized sata driving the current switches negate
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

     //Generate non lineartinies: mismatch
    real mismatch_databinout [0:6];
    real mismatch_databinoutb [0:6];
    real mismatch_datathermout [0:16];
    real mismatch_datathermoutb [0:16];

    function real generate_mismatch(int k);
        real temp;
        temp = $urandom()%4000;
        $display("Raw binary mismatch[%0d] = %0d", k, temp);
        $display("Binary mismatch[%0d]= %0.4f", k, ((temp)-2000) / 100000.0);
        return ((temp)-2000) / 100000.0;
    endfunction

    initial begin
        // Binary part mismatch generation
        for (int j = 0; j <= 6; j++) begin
          mismatch_databinout[j] = generate_mismatch(j);
        end
        // Binary negated part mismatch generation
        for (int j = 0; j <= 6; j++) begin
          mismatch_databinoutb[j] = generate_mismatch(j);
        end

        // Thermometric part mismatch generation
        for (int i = 0; i <= 16; i++) begin
          mismatch_datathermout[i] = generate_mismatch(i);
        end
        // Thermometric negated part mismatch generation
        for (int i = 0; i <= 16; i++) begin
          mismatch_datathermoutb[i] = generate_mismatch(i);
        end
    end

    always_comb begin

        if (vddana_1p8_check && vddana_0p8_check && vssana_check ) begin
            input_check = 1; // All inputs are correct
        end else begin
            input_check = 0; // At least one input is incorrect
            $warning("Input signals boundaries are not correct: vddana_1p8_check=%0d, vddana_0p8_check=%0d, vssana_check=%0d,", vddana_1p8_check, vddana_0p8_check, vssana_check);
        end

        if(input_check == 1 && pdb == 1) begin
            for (int j = 0; j <= 6; j++) begin
                databinout[j] = datain[j] + (datain[j] * mismatch_databinout[j]);
                databinoutb[j] = datainb[j] + (datainb[j] * mismatch_databinoutb[j]);
            end
            for (int i = 0; i <= 16; i++) begin
                datathermout[i] = datatherm[i] + (datatherm[i] * mismatch_datathermout[i]);
                datathermoutb[i] = datathermb[i] + (datathermb[i] * mismatch_datathermoutb[i]);
            end
        end else if(input_check == 1 && pdb ==0) begin
            for (int j = 0; j <= 6; j++) begin
                databinout[j] = `wrealZState;
                databinoutb[j] = `wrealZState;
            end
            for (int i = 0; i <= 16; i++) begin
                datathermout[i] = `wrealZState;
                datathermoutb[i] = `wrealZState;
            end
        end
    end

endmodule