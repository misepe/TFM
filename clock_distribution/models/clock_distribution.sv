`timescale 1ns/1ps
module clock_distribution import cds_rnm_pkg::*;(
    input logic clkin, //digital input current comming from the switching pairs
    input logic clkinb, // digital input negate current comming from the switching pairs 
    input real iref_25ua, //analog input reference current
    input logic pdb, //power down negate signal
    input logic [1:0] atb_ena, //stablish the output of the differential testbus
    input real vddana_0p8, //0.8V power supply for the block
    input real vssana, //ground connection for the block
    output logic clkout_therm_16, //output block for thermomethric IDAC
    output logic clkout_therm_15, //output block for thermomethric IDAC
    output logic clkout_therm_14, //output block for thermomethric IDAC
    output logic clkout_therm_13, //output block for thermomethric IDAC
    output logic clkout_therm_12, //output block for thermomethric IDAC
    output logic clkout_therm_11, //output block for thermomethric IDAC
    output logic clkout_therm_10, //output block for thermomethric IDAC
    output logic clkout_therm_9, //output block for thermomethric IDAC
    output logic clkout_therm_8, //output block for thermomethric IDAC
    output logic clkout_therm_7, //output block for thermomethric IDAC
    output logic clkout_therm_6, //output block for thermomethric IDAC
    output logic clkout_therm_5, //output block for thermomethric IDAC
    output logic clkout_therm_4, //output block for thermomethric IDAC
    output logic clkout_therm_3, //output block for thermomethric IDAC
    output logic clkout_therm_2, //output block for thermomethric IDAC
    output logic clkout_therm_1, //output block for thermomethric IDAC
    output logic clkout_therm_0, //output block for thermomethric IDAC
    output logic clkoutb_therm_16, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_15, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_14, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_13, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_12, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_11, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_10, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_9, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_8, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_7, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_6, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_5, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_4, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_3, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_2, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_1, //output block for thermomethric IDAC negate
    output logic clkoutb_therm_0, //output block for thermomethric IDAC negate
    output logic clkout_binary_5, //output block for binary part IDAC
    output logic clkout_binary_4, //output block for binary part IDAC
    output logic clkout_binary_3, //output block for binary part IDAC
    output logic clkout_binary_2, //output block for binary part IDAC
    output logic clkout_binary_1, //output block for binary part IDAC
    output logic clkout_binary_0, //output block for binary part IDAC
    output logic clkout_binary_0_red, //output block for binary part IDAC redundant
    output logic clkoutb_binary_5, //output block for binary part IDAC negate
    output logic clkoutb_binary_4, //output block for binary part IDAC negate
    output logic clkoutb_binary_3, //output block for binary part IDAC negate
    output logic clkoutb_binary_2, //output block for binary part IDAC negate
    output logic clkoutb_binary_1, //output block for binary part IDAC negate
    output logic clkoutb_binary_0, //output block for binary part IDAC negate
    output logic clkoutb_binary_0_red, //output block for binary part IDAC redundant negate
    output real atb1, //testbus outbus 1
    output real atb0  //testbus outbus 0

);

    bit input_check; // Variable to check the inputs signals 1: all inputs are correct, 0: at least one input is incorrect
    bit vddana_0p8_check = 1; // Variable to check the input voltage vddana_0p8 1: correct, 0: incorrect
    bit vssana_check = 1; // Variable to check the input voltage vssana 1: correct, 0: incorrect
    bit iref_check = 1; // Variable to check the input current iref_500ua 1: correct, 0: incorrect

    parameter Tdel = 50ps; //delay for clk output signals

    //to check that vddana_0p8 voltage is within the boundaries +/-5%
    parameter real VDDANA_0P8_REF = 0.8; // 0.8 V
    always @(vddana_0p8) begin
        if(vddana_0p8 >= VDDANA_0P8_REF*0.95 && vddana_0p8 <= VDDANA_0P8_REF*1.05) begin
            vddana_0p8_check = 1;
        end else begin
            vddana_0p8_check = 0;
        end
        vddana_0p8_boundaries: assert (vddana_0p8 >= VDDANA_0P8_REF*0.95 && vddana_0p8 <= VDDANA_0P8_REF*1.05) else $error("Input voltge vddana_0p8 is out of bounds: %0.2f V", vddana_0p8);
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
        vssana_boundaries: assert (vssana >= VSSANA_MIN && vssana <= VSSANA_MAX) else $error("Input voltge vssana is out of bounds: %0.2f V", vssana);
    end

    //to check that iref current is within the boundaries +/-10%
    parameter real IREF = 25e-6; // 25 µA
    always @(iref_25ua) begin
        if(iref_25ua >= IREF*0.9 && iref_25ua <= IREF*1.1) begin
            iref_check = 1;
        end else begin
            iref_check = 0;
        end
        iref_ua_boundaries: assert (iref_25ua >= IREF*0.9 && iref_25ua <= IREF*1.1) else $error("Input current iref_25ua is out of bounds: %0.2f uA", iref_25ua*1e6);
    end

    always_comb begin

        if (vddana_0p8_check && vssana_check && iref_check) begin
            input_check = 1; // All inputs are correct
        end else begin
            input_check = 0; // At least one input is incorrect
            $error("Input signals boundaries are not correct: vddana_0p8_check=%0d, vssana_check=%0d,", vddana_0p8_check, vssana_check);
        end

        if (input_check == 1 && pdb == 1) begin
            case(atb_ena)
                2'b00: begin
                    atb1 = `wrealZState;
                    atb0 = `wrealZState;
                end
                2'b01: begin
                    atb1 = vddana_0p8;
                    atb0 = vssana;
                end
                2'b10: begin
                    atb1 = vddana_0p8;
                    atb0 = vssana;
                end
                2'b11: begin
                    atb1 = iref_25ua;
                    atb0 = vssana;
                end
            endcase
        end else if(pdb == 0) begin
            atb1 = `wrealZState;
            atb0 = `wrealZState;
        end
    end

    logic clkout_therm_16_aux, clkout_therm_15_aux, clkout_therm_14_aux, clkout_therm_13_aux, clkout_therm_12_aux, clkout_therm_11_aux;
    logic clkout_therm_10_aux, clkout_therm_9_aux, clkout_therm_8_aux, clkout_therm_7_aux, clkout_therm_6_aux, clkout_therm_5_aux;
    logic clkout_therm_4_aux, clkout_therm_3_aux, clkout_therm_2_aux, clkout_therm_1_aux, clkout_therm_0_aux;
    logic clkoutb_therm_16_aux, clkoutb_therm_15_aux, clkoutb_therm_14_aux, clkoutb_therm_13_aux, clkoutb_therm_12_aux, clkoutb_therm_11_aux;
    logic clkoutb_therm_10_aux, clkoutb_therm_9_aux, clkoutb_therm_8_aux, clkoutb_therm_7_aux, clkoutb_therm_6_aux, clkoutb_therm_5_aux;
    logic clkoutb_therm_4_aux, clkoutb_therm_3_aux, clkoutb_therm_2_aux, clkoutb_therm_1_aux, clkoutb_therm_0_aux;
    
    logic clkout_binary_5_aux, clkout_binary_4_aux, clkout_binary_3_aux, clkout_binary_2_aux, clkout_binary_1_aux, clkout_binary_0_aux, clkout_binary_0_red_aux;
    logic clkoutb_binary_5_aux, clkoutb_binary_4_aux, clkoutb_binary_3_aux, clkoutb_binary_2_aux, clkoutb_binary_1_aux, clkoutb_binary_0_aux, clkoutb_binary_0_red_aux;

    always@(clkin, clkinb,pdb) begin
        if(pdb == 1) begin
            // Load clkin and clkinb into auxiliary signals
            fork
                begin
            
            clkout_therm_16_aux = clkin;
            clkout_therm_15_aux = clkin;
            clkout_therm_14_aux = clkin;
            clkout_therm_13_aux = clkin;
            clkout_therm_12_aux = clkin;
            clkout_therm_11_aux = clkin;
            clkout_therm_10_aux = clkin;
            clkout_therm_9_aux = clkin;
            clkout_therm_8_aux = clkin;
            clkout_therm_7_aux = clkin;
            clkout_therm_6_aux = clkin;
            clkout_therm_5_aux = clkin;
            clkout_therm_4_aux = clkin;
            clkout_therm_3_aux = clkin;
            clkout_therm_2_aux = clkin;
            clkout_therm_1_aux = clkin;
            clkout_therm_0_aux = clkin;
            clkoutb_therm_16_aux = clkinb;
            clkoutb_therm_15_aux = clkinb;
            clkoutb_therm_14_aux = clkinb;
            clkoutb_therm_13_aux = clkinb;
            clkoutb_therm_12_aux = clkinb;
            clkoutb_therm_11_aux = clkinb;
            clkoutb_therm_10_aux = clkinb;
            clkoutb_therm_9_aux = clkinb;
            clkoutb_therm_8_aux = clkinb;
            clkoutb_therm_7_aux = clkinb;
            clkoutb_therm_6_aux = clkinb;
            clkoutb_therm_5_aux = clkinb;
            clkoutb_therm_4_aux = clkinb;
            clkoutb_therm_3_aux = clkinb;
            clkoutb_therm_2_aux = clkinb;
            clkoutb_therm_1_aux = clkinb;
            clkoutb_therm_0_aux = clkinb;
            clkout_binary_5_aux = clkin;
            clkout_binary_4_aux = clkin;
            clkout_binary_3_aux = clkin;
            clkout_binary_2_aux = clkin;
            clkout_binary_1_aux = clkin;
            clkout_binary_0_aux = clkin;
            clkout_binary_0_red_aux = clkin;
            clkoutb_binary_5_aux = clkinb;
            clkoutb_binary_4_aux = clkinb;
            clkoutb_binary_3_aux = clkinb;
            clkoutb_binary_2_aux = clkinb;
            clkoutb_binary_1_aux = clkinb;
            clkoutb_binary_0_aux = clkinb;
            clkoutb_binary_0_red_aux = clkinb;
                end
            
            begin
            // Delay of 50ps and assign auxiliary signals to outputs
            #50;
            clkout_therm_16 = clkout_therm_16_aux;
            clkout_therm_15 = clkout_therm_15_aux;
            clkout_therm_14 = clkout_therm_14_aux;
            clkout_therm_13 = clkout_therm_13_aux;
            clkout_therm_12 = clkout_therm_12_aux;
            clkout_therm_11 = clkout_therm_11_aux;
            clkout_therm_10 = clkout_therm_10_aux;
            clkout_therm_9 = clkout_therm_9_aux;
            clkout_therm_8 = clkout_therm_8_aux;
            clkout_therm_7 = clkout_therm_7_aux;
            clkout_therm_6 = clkout_therm_6_aux;
            clkout_therm_5 = clkout_therm_5_aux;
            clkout_therm_4 = clkout_therm_4_aux;
            clkout_therm_3 = clkout_therm_3_aux;
            clkout_therm_2 = clkout_therm_2_aux;
            clkout_therm_1 = clkout_therm_1_aux;
            clkout_therm_0 = clkout_therm_0_aux;
            clkoutb_therm_16 = clkoutb_therm_16_aux;
            clkoutb_therm_15 = clkoutb_therm_15_aux;
            clkoutb_therm_14 = clkoutb_therm_14_aux;
            clkoutb_therm_13 = clkoutb_therm_13_aux;
            clkoutb_therm_12 = clkoutb_therm_12_aux;
            clkoutb_therm_11 = clkoutb_therm_11_aux;
            clkoutb_therm_10 = clkoutb_therm_10_aux;
            clkoutb_therm_9 = clkoutb_therm_9_aux;
            clkoutb_therm_8 = clkoutb_therm_8_aux;
            clkoutb_therm_7 = clkoutb_therm_7_aux;
            clkoutb_therm_6 = clkoutb_therm_6_aux;
            clkoutb_therm_5 = clkoutb_therm_5_aux;
            clkoutb_therm_4 = clkoutb_therm_4_aux;
            clkoutb_therm_3 = clkoutb_therm_3_aux;
            clkoutb_therm_2 = clkoutb_therm_2_aux;
            clkoutb_therm_1 = clkoutb_therm_1_aux;
            clkoutb_therm_0 = clkoutb_therm_0_aux;
            clkout_binary_5 = clkout_binary_5_aux;
            clkout_binary_4 = clkout_binary_4_aux;
            clkout_binary_3 = clkout_binary_3_aux;
            clkout_binary_2 = clkout_binary_2_aux;
            clkout_binary_1 = clkout_binary_1_aux;
            clkout_binary_0 = clkout_binary_0_aux;
            clkout_binary_0_red = clkout_binary_0_red_aux;
            clkoutb_binary_5 = clkoutb_binary_5_aux;
            clkoutb_binary_4 = clkoutb_binary_4_aux;
            clkoutb_binary_3 = clkoutb_binary_3_aux;
            clkoutb_binary_2 = clkoutb_binary_2_aux;
            clkoutb_binary_1 = clkoutb_binary_1_aux;
            clkoutb_binary_0 = clkoutb_binary_0_aux;
            clkoutb_binary_0_red = clkoutb_binary_0_red_aux;
            end
            join_none
        
        end else if(pdb == 0)begin

            clkout_therm_16 = 1'bz;
            clkout_therm_15 = 1'bz;
            clkout_therm_14 = 1'bz;
            clkout_therm_13 = 1'bz;
            clkout_therm_12 = 1'bz;
            clkout_therm_11 = 1'bz;
            clkout_therm_10 = 1'bz;
            clkout_therm_9 = 1'bz;
            clkout_therm_8 = 1'bz;
            clkout_therm_7 = 1'bz;
            clkout_therm_6 = 1'bz;
            clkout_therm_5 = 1'bz;
            clkout_therm_4 = 1'bz;
            clkout_therm_3 = 1'bz;
            clkout_therm_2 = 1'bz;
            clkout_therm_1 = 1'bz;
            clkout_therm_0 = 1'bz;
            clkoutb_therm_16 = 1'bz;
            clkoutb_therm_15 = 1'bz;
            clkoutb_therm_14 = 1'bz;
            clkoutb_therm_13 = 1'bz;
            clkoutb_therm_12 = 1'bz;
            clkoutb_therm_11 = 1'bz;
            clkoutb_therm_10 = 1'bz;
            clkoutb_therm_9 = 1'bz;
            clkoutb_therm_8 = 1'bz;
            clkoutb_therm_7 = 1'bz;
            clkoutb_therm_6 = 1'bz;
            clkoutb_therm_5 = 1'bz;
            clkoutb_therm_4 = 1'bz;
            clkoutb_therm_3 = 1'bz;
            clkoutb_therm_2 = 1'bz;
            clkoutb_therm_1 = 1'bz;
            clkoutb_therm_0 = 1'bz;
            
            clkout_binary_5 = 1'bz;
            clkout_binary_4 = 1'bz;
            clkout_binary_3 = 1'bz;
            clkout_binary_2 = 1'bz;
            clkout_binary_1 = 1'bz; 
            clkout_binary_0 = 1'bz;
            clkout_binary_0_red = 1'bz;
            clkoutb_binary_5 = 1'bz;
            clkoutb_binary_4 = 1'bz;
            clkoutb_binary_3 = 1'bz;
            clkoutb_binary_2 = 1'bz;
            clkoutb_binary_1 = 1'bz;
            clkoutb_binary_0 = 1'bz;
            clkoutb_binary_0_red = 1'bz;

        end

    end

endmodule