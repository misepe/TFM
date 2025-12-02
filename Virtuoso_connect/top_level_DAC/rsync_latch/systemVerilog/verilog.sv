

module rsync_latch(
    input logic [6:0] datainbin,      // Input data for thermomethic IDAC
    input logic [6:0] datainbinb,     // Input negate data for thermomethic IDAC 
    input logic [16:0] dataintherm,  // Input data for thermomethic IDAC
    input logic [16:0] datainthermb, // Input negate data for thermomethic IDAC
    input logic clkin_therm_0,    //Input clock for thermometric 0 IDAC
    input logic clkin_therm_1,    //Input clock for thermometric 1 IDAC
    input logic clkin_therm_2,    //Input clock for thermometric 2 IDAC
    input logic clkin_therm_3,    //Input clock for thermometric 3 IDAC
    input logic clkin_therm_4,    //Input clock for thermometric 4 IDAC
    input logic clkin_therm_5,    //Input clock for thermometric 5 IDAC
    input logic clkin_therm_6,    //Input clock for thermometric 6 IDAC
    input logic clkin_therm_7,    //Input clock for thermometric 7 IDAC
    input logic clkin_therm_8,    //Input clock for thermometric 8 IDAC
    input logic clkin_therm_9,    //Input clock for thermometric 9 IDAC
    input logic clkin_therm_10,   //Input clock for thermometric 10 IDAC
    input logic clkin_therm_11,   //Input clock for thermometric 11 IDAC
    input logic clkin_therm_12,   //Input clock for thermometric 12 IDAC
    input logic clkin_therm_13,   //Input clock for thermometric 13 IDAC
    input logic clkin_therm_14,   //Input clock for thermometric 14 IDAC
    input logic clkin_therm_15,   //Input clock for thermometric 15 IDAC
    input logic clkin_therm_16,   //Input clock for thermometric 16 IDAC    
    input logic clkinb_therm_0,  //Input negate clock for thermometric 0 IDAC
    input logic clkinb_therm_1,  //Input negate clock for thermometric 1 IDAC
    input logic clkinb_therm_2,  //Input negate clock for thermometric 2 IDAC
    input logic clkinb_therm_3,  //Input negate clock for thermometric 3 IDAC
    input logic clkinb_therm_4,  //Input negate clock for thermometric 4 IDAC
    input logic clkinb_therm_5,  //Input negate clock for thermometric 5 IDAC
    input logic clkinb_therm_6,  //Input negate clock for thermometric 6 IDAC
    input logic clkinb_therm_7,  //Input negate clock for thermometric 7 IDAC
    input logic clkinb_therm_8,  //Input negate clock for thermometric 8 IDAC
    input logic clkinb_therm_9,  //Input negate clock for thermometric 9 IDAC
    input logic clkinb_therm_10, //Input negate clock for thermometric 10 IDAC
    input logic clkinb_therm_11, //Input negate clock for thermometric 11 IDAC
    input logic clkinb_therm_12, //Input negate clock for thermometric 12 IDAC
    input logic clkinb_therm_13, //Input negate clock for thermometric 13 IDAC
    input logic clkinb_therm_14, //Input negate clock for thermometric 14 IDAC
    input logic clkinb_therm_15, //Input negate clock for thermometric 15 IDAC
    input logic clkinb_therm_16, //Input negate clock for thermometric 16 IDAC
    input logic clkin_binary_0,   //Input clock for binary 0 IDAC
    input logic clkin_binary_1,   //Input clock for binary 1 IDAC
    input logic clkin_binary_2,   //Input clock for binary 2 IDAC
    input logic clkin_binary_3,   //Input clock for binary 3 IDAC
    input logic clkin_binary_4,   //Input clock for binary 4 IDAC
    input logic clkin_binary_5,   //Input clock for binary 5 IDAC
    input logic clkinb_binary_0, //Input negate clock for binary 0 IDAC
    input logic clkinb_binary_1, //Input negate clock for binary 1 IDAC
    input logic clkinb_binary_2, //Input negate clock for binary 2 IDAC
    input logic clkinb_binary_3, //Input negate clock for binary 3 IDAC
    input logic clkinb_binary_4, //Input negate clock for binary 4 IDAC
    input logic clkinb_binary_5, //Input negate clock for binary 5 IDAC
    input logic clkin_binary_0_red, //Input clock for binary 0 redundant IDAC
    input logic clkinb_binary_0_red, //Input negate clock for binary 0 redundant IDAC
    input logic pdb, //power down negate signal
    input real vddana_0p8, //0.8V power supply for the block
    input real vssana, //ground connection for the block
    input real iref_25ua, //input reference current 25uA
    input logic [0:1] atb_ena, //stablish the output of the differential testbus
    output logic [6:0] dataoutbin, //Resyncronized data driving the current switches rising edge del reloj
    output logic [6:0] dataoutbinb, //Resyncronized negate data driving the current switches rising edge del reloj
    output logic [16:0] dataouttherm, //Resyncronized data driving the current switches rising edge del reloj
    output logic [16:0] dataoutthermb, //Resyncronized negate data driving the current switches rising edge del reloj
    output real atb1, //analog testbus
    output real atb0 //analog testbus
);

    bit input_check; // Variable to check the inputs signals 1: all inputs are correct, 0: at least one input is incorrect
    bit vddana_0p8_check = 1; // Variable to check the input voltage vddana_0p8 1: correct, 0: incorrect
    bit vssana_check = 1; // Variable to check the input voltage vssana 1: correct, 0: incorrect
    bit iref_check = 1; // Variable to check the input current iref_500ua 1: correct, 0: incorrect

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

    //to check that iref current is within the boundaries +/-10%
    parameter real IREF = 25e-6; // 25 ?A
    always @(iref_25ua) begin
        if(iref_25ua >= IREF*0.9 && iref_25ua <= IREF*1.1) begin
            iref_check = 1;
        end else begin
            iref_check = 0;
        end
        iref_ua_boundaries: assert (iref_25ua >= IREF*0.9 && iref_25ua <= IREF*1.1) else $warning("Input current iref_25ua is out of bounds: %0.2f uA", iref_25ua*1e6);
    end

    always_comb begin

        if (vddana_0p8_check && vssana_check && iref_check) begin
            input_check = 1; // All inputs are correct
        end else begin
            input_check = 0; // At least one input is incorrect
            $warning("Input signals boundaries are not correct: vddana_0p8_check=%0d, vssana_check=%0d,", vddana_0p8_check, vssana_check);
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
                    atb0 = iref_25ua;
                end
            endcase
        end else if(pdb == 0) begin
            atb1 = `wrealZState;
            atb0 = `wrealZState;
        end
    end

    always @(posedge clkin_therm_0 or negedge clkinb_therm_0) begin
        if(clkin_therm_0 && !clkinb_therm_0) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[0] <= dataintherm[0];
                dataoutthermb[0] <= datainthermb[0];
            end else if (pdb == 0) begin
                dataouttherm[0] <= 'z;
                dataoutthermb[0] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_0 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_0, clkinb_therm_0);
        end
    end

    always @(posedge clkin_therm_1 or negedge clkinb_therm_1) begin
        if(clkin_therm_1 && !clkinb_therm_1) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[1] <= dataintherm[1];
                dataoutthermb[1] <= datainthermb[1];
            end else if (pdb == 0) begin
                dataouttherm[1] <= 'z;
                dataoutthermb[1] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_1 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_1, clkinb_therm_1);
        end
    end

    always @(posedge clkin_therm_2 or negedge clkinb_therm_2) begin
        if(clkin_therm_2 && !clkinb_therm_2) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[2] <= dataintherm[2];
                dataoutthermb[2] <= datainthermb[2];
            end else if (pdb == 0) begin
                dataouttherm[2] <= 'z;
                dataoutthermb[2] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_2 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_2, clkinb_therm_2);
        end
    end

    always @(posedge clkin_therm_3 or negedge clkinb_therm_3) begin
        if(clkin_therm_3 && !clkinb_therm_3) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[3] <= dataintherm[3];
                dataoutthermb[3] <= datainthermb[3];
            end else if (pdb == 0) begin
                dataouttherm[3] <= 'z;
                dataoutthermb[3] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_3 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_3, clkinb_therm_3);
        end
    end

    always @(posedge clkin_therm_4 or negedge clkinb_therm_4) begin
        if(clkin_therm_4 && !clkinb_therm_4) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[4] <= dataintherm[4];
                dataoutthermb[4] <= datainthermb[4];
            end else if (pdb == 0) begin
                dataouttherm[4] <= 'z;
                dataoutthermb[4] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_4 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_4, clkinb_therm_4);
        end
    end

    always @(posedge clkin_therm_5 or negedge clkinb_therm_5) begin
        if(clkin_therm_5 && !clkinb_therm_5) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[5] <= dataintherm[5];
                dataoutthermb[5] <= datainthermb[5];
            end else if (pdb == 0) begin
                dataouttherm[5] <= 'z;
                dataoutthermb[5] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_5 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_5, clkinb_therm_5);
        end
    end

    always @(posedge clkin_therm_6 or negedge clkinb_therm_6) begin
        if(clkin_therm_6 && !clkinb_therm_6) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[6] <= dataintherm[6];
                dataoutthermb[6] <= datainthermb[6];
            end else if (pdb == 0) begin
                dataouttherm[6] <= 'z;
                dataoutthermb[6] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_6 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_6, clkinb_therm_6);
        end
    end

    always @(posedge clkin_therm_7 or negedge clkinb_therm_7) begin
        if(clkin_therm_7 && !clkinb_therm_7) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[7] <= dataintherm[7];
                dataoutthermb[7] <= datainthermb[7];
            end else if (pdb == 0) begin
                dataouttherm[7] <= 'z;
                dataoutthermb[7] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_7 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_7, clkinb_therm_7);
        end
    end

    always @(posedge clkin_therm_8 or negedge clkinb_therm_8) begin
        if(clkin_therm_8 && !clkinb_therm_8) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[8] <= dataintherm[8];
                dataoutthermb[8] <= datainthermb[8];
            end else if (pdb == 0) begin
                dataouttherm[8] <= 'z;
                dataoutthermb[8] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_8 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_8, clkinb_therm_8);
        end
    end

    always @(posedge clkin_therm_9 or negedge clkinb_therm_9) begin
        if(clkin_therm_9 && !clkinb_therm_9) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[9] <= dataintherm[9];
                dataoutthermb[9] <= datainthermb[9];
            end else if (pdb == 0) begin
                dataouttherm[9] <= 'z;
                dataoutthermb[9] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_9 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_9, clkinb_therm_9);
        end
    end

    always @(posedge clkin_therm_10 or negedge clkinb_therm_10) begin
        if(clkin_therm_10 && !clkinb_therm_10) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[10] <= dataintherm[10];
                dataoutthermb[10] <= datainthermb[10];
            end else if (pdb == 0) begin
                dataouttherm[10] <= 'z;
                dataoutthermb[10] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_10 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_10, clkinb_therm_10);
        end
    end

    always @(posedge clkin_therm_11 or negedge clkinb_therm_11) begin
        if(clkin_therm_11 && !clkinb_therm_11) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[11] <= dataintherm[11];
                dataoutthermb[11] <= datainthermb[11];
            end else if (pdb == 0) begin
                dataouttherm[11] <= 'z;
                dataoutthermb[11] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_11 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_11, clkinb_therm_11);
        end
    end

    always @(posedge clkin_therm_12 or negedge clkinb_therm_12) begin
        if(clkin_therm_12 && !clkinb_therm_12) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[12] <= dataintherm[12];
                dataoutthermb[12] <= datainthermb[12];
            end else if (pdb == 0) begin
                dataouttherm[12] <= 'z;
                dataoutthermb[12] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_12 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_12, clkinb_therm_12);
        end
    end

    always @(posedge clkin_therm_13 or negedge clkinb_therm_13) begin
        if(clkin_therm_13 && !clkinb_therm_13) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[13] <= dataintherm[13];
                dataoutthermb[13] <= datainthermb[13];
            end else if (pdb == 0) begin
                dataouttherm[13] <= 'z;
                dataoutthermb[13] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_13 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_13, clkinb_therm_13);
        end
    end

    always @(posedge clkin_therm_14 or negedge clkinb_therm_14) begin
        if(clkin_therm_14 && !clkinb_therm_14) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[14] <= dataintherm[14];
                dataoutthermb[14] <= datainthermb[14];
            end else if (pdb == 0) begin
                dataouttherm[14] <= 'z;
                dataoutthermb[14] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_14 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_14, clkinb_therm_14);
        end
    end

    always @(posedge clkin_therm_15 or negedge clkinb_therm_15) begin
        if(clkin_therm_15 && !clkinb_therm_15) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[15] <= dataintherm[15];
                dataoutthermb[15] <= datainthermb[15];
            end else if (pdb == 0) begin
                dataouttherm[15] <= 'z;
                dataoutthermb[15] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_15 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_15, clkinb_therm_15);
        end
    end

    always @(posedge clkin_therm_16 or negedge clkinb_therm_16) begin
        if(clkin_therm_16 && !clkinb_therm_16) begin
            if (input_check == 1 && pdb == 1) begin
                dataouttherm[16] <= dataintherm[16];
                dataoutthermb[16] <= datainthermb[16];
            end else if (pdb == 0) begin
                dataouttherm[16] <= 'z;
                dataoutthermb[16] <= 'z;
            end
        end else begin
            $warning("Clock signals for therm_16 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_therm_16, clkinb_therm_16);
        end
    end

    //El bit redundante va en la posicion 0 del vector dataoutbin y datainbin
    always @(posedge clkin_binary_0_red or negedge clkinb_binary_0_red) begin
        if(clkin_binary_0_red && !clkinb_binary_0_red) begin
        if (input_check == 1 && pdb == 1) begin
            dataoutbin[0] <= datainbin[0];
            dataoutbinb[0] <= datainbinb[0];
        end else if (pdb == 0) begin
            dataoutbin[0] <= 'z;
            dataoutbinb[0] <= 'z;
        end
        end else begin
        $warning("Clock signals for bin_0_red are not in the correct state: clkin= %0d, clkinb= %0d", clkin_binary_0_red, clkinb_binary_0_red);
        end
    end

    always @(posedge clkin_binary_0 or negedge clkinb_binary_0) begin
        if(clkin_binary_0 && !clkinb_binary_0) begin
        if (input_check == 1 && pdb == 1) begin
            dataoutbin[1] <= datainbin[1];
            dataoutbinb[1] <= datainbinb[1];
        end else if (pdb == 0) begin
            dataoutbin[1] <= 'z;
            dataoutbinb[1] <= 'z;
        end
        end else begin
        $warning("Clock signals for bin_0 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_binary_0, clkinb_binary_0);
        end
    end

    always @(posedge clkin_binary_1 or negedge clkinb_binary_1) begin
        if(clkin_binary_1 && !clkinb_binary_1) begin
        if (input_check == 1 && pdb == 1) begin
            dataoutbin[2] <= datainbin[2];
            dataoutbinb[2] <= datainbinb[2];
        end else if (pdb == 0) begin
            dataoutbin[2] <= 'z;
            dataoutbinb[2] <= 'z;
        end
        end else begin
        $warning("Clock signals for bin_1 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_binary_1, clkinb_binary_1);
        end
    end

    always @(posedge clkin_binary_2 or negedge clkinb_binary_2) begin
        if(clkin_binary_2 && !clkinb_binary_2) begin
        if (input_check == 1 && pdb == 1) begin
            dataoutbin[3] <= datainbin[3];
            dataoutbinb[3] <= datainbinb[3];
        end else if (pdb == 0) begin
            dataoutbin[3] <= 'z;
            dataoutbinb[3] <= 'z;
        end
        end else begin
        $warning("Clock signals for bin_2 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_binary_2, clkinb_binary_2);
        end
    end

    always @(posedge clkin_binary_3 or negedge clkinb_binary_3) begin
        if(clkin_binary_3 && !clkinb_binary_3) begin
        if (input_check == 1 && pdb == 1) begin
            dataoutbin[4] <= datainbin[4];
            dataoutbinb[4] <= datainbinb[4];
        end else if (pdb == 0) begin
            dataoutbin[4] <= 'z;
            dataoutbinb[4] <= 'z;
        end
        end else begin
        $warning("Clock signals for bin_3 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_binary_3, clkinb_binary_3);
        end
    end

    always @(posedge clkin_binary_4 or negedge clkinb_binary_4) begin
        if(clkin_binary_4 && !clkinb_binary_4) begin
        if (input_check == 1 && pdb == 1) begin
            dataoutbin[5] <= datainbin[5];
            dataoutbinb[5] <= datainbinb[5];
        end else if (pdb == 0) begin
            dataoutbin[5] <= 'z;
            dataoutbinb[5] <= 'z;
        end
        end else begin
        $warning("Clock signals for bin_4 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_binary_4, clkinb_binary_4);
        end
    end

    always @(posedge clkin_binary_5 or negedge clkinb_binary_5) begin
        if(clkin_binary_5 && !clkinb_binary_5) begin
        if (input_check == 1 && pdb == 1) begin
            dataoutbin[6] <= datainbin[6];
            dataoutbinb[6] <= datainbinb[6];
        end else if (pdb == 0) begin
            dataoutbin[6] <= 'z;
            dataoutbinb[6] <= 'z;
        end
        end else begin
        $warning("Clock signals for bin_5 are not in the correct state: clkin= %0d, clkinb= %0d", clkin_binary_5, clkinb_binary_5);
        end
    end

    


endmodule