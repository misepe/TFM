`timescale 1ns/1ps
module local_bias import cds_rnm_pkg::*;(
    input logic pdb,               // Power down signal
    input real vddana_1p8,       // 1.8V power supply
    input real vddana_0p8,       // 0.8V power supply
    input real vssana,           // Ground connection
    input logic [0:1] atb_ena,        // Analog testbus enable 
    output real iclkdist_25ua, // 25µA clock distribution current
    output real isynclatch_25ua, // 25µA sync latch current
    output real icurrentsterring_500ua, // 500µA current steering bias current
    output real icurrentsource_500ua,   // 500µA current source bias current
    output real atb1,               // Analog testbus 1
    output real atb0                // Analog testbus 0
);

    bit input_check; // Variable to check the inputs signals 1: all inputs are correct, 0: at least one input is incorrect
    bit vddana_1p8_check = 1; // Variable to check the input voltage vddana_1p8 1: correct, 0: incorrect
    bit vddana_0p8_check = 1; // Variable to check the input voltage vddana_0p8 1: correct, 0: incorrect
    bit vssana_check = 1; // Variable to check the input voltage vssana 1: correct, 0: incorrect

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

    always_comb begin

        if (vddana_1p8_check && vddana_0p8_check && vssana_check) begin
            input_check = 1; // All inputs are correct
        end else begin
            input_check = 0; // At least one input is incorrect
            $warning("Input signals boundaries are not correct: vddana_1p8_check=%0d, vddana_0p8_check=%0d, vssana_check=%0d,", vddana_1p8_check, vddana_0p8_check, vssana_check);
        end

        if (input_check == 1 && pdb == 1) begin
            case(atb_ena)
                2'b00: begin
                    atb1 = `wrealZState;
                    atb0 = `wrealZState;
                end
                2'b01: begin
                    atb1 = vddana_1p8; 
                    atb0 = vddana_0p8; 
                end
                2'b10: begin
                    atb1 = vssana;
                    atb0 = vssana;
                end
                2'b11: begin
                    atb1 = iclkdist_25ua;
                    atb0 = icurrentsterring_500ua;
                end
            endcase

            iclkdist_25ua = 25e-6; // 25 µA
            isynclatch_25ua = 25e-6; // 25 µA
            icurrentsterring_500ua = 500e-6; // 500 µA
            icurrentsource_500ua = 500e-6;   // 500 µA
            
        end else if(pdb == 0) begin
            atb1 = `wrealZState;
            atb0 = `wrealZState;
            iclkdist_25ua = `wrealZState;
            isynclatch_25ua = `wrealZState;
            icurrentsterring_500ua = `wrealZState;
            icurrentsource_500ua = `wrealZState;
        end
    end


endmodule