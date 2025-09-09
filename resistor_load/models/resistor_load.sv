`timescale 1ps/1ps

module resistor_load import cds_rnm_pkg::*;(
    input real Iin, //Input current comming from the switching pairs (analog current)
    input real Iinb, //Input current comming from the switching pairs (analog current)
    input real vssana, //gound connection for the block (ground)
    output real vout, //output voltage (analog voltage)
    output real voutb //output voltage (analog voltage)
    );
    parameter real Rload = 100; //Resistance load of 1k ohm

    bit vssana_check = 1; // Variable to check the input voltage vssana 1: correct, 0: incorrect

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
        vssana_boundaries: assert (vssana >= VSSANA_MIN && vssana <= VSSANA_MAX) else $error("Input voltge vssana is out of bounds: %0.2f V", vssana);
    end

    assign vout = (Iin * Rload);
    assign voutb = (Iinb * Rload);
endmodule