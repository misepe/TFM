`timescale 1ps/1ps

module currentSterring import cds_rnm_pkg::*;(
    input real iref_500ua, // input reference current(analog signal)
    input pdb, //power down negate signal (digital signal)
    input [1:0] atb_ena, //stablish the output of the differential testbus (digital signal)
    input real vddana_1p8, //power supply for the block (vsupply)
    input real vddana_0p8, //power supply for the block (vsupply)
    input real Iout_them_16, //input current from the bias generator (analog current)
    input real Iout_them_15, //input current from the bias generator (analog current)
    input real Iout_them_14, //input current from the bias generator (analog current)
    input real Iout_them_13, //input current from the bias generator (analog current)
    input real Iout_them_12, //input current from the bias generator (analog current)
    input real Iout_them_11, //input current from the bias generator (analog current)
    input real Iout_them_10, //input current from the bias generator (analog current)
    input real Iout_them_9,  //input current from the bias generator (analog current)
    input real Iout_them_8,  //input current from the bias generator (analog current)
    input real Iout_them_7,  //input current from the bias generator (analog current)
    input real Iout_them_6,  //input current from the bias generator (analog current)
    input real Iout_them_5,  //input current from the bias generator (analog current)
    input real Iout_them_4,  //input current from the bias generator (analog current)
    input real Iout_them_3,  //input current from the bias generator (analog current)
    input real Iout_them_2,  //input current from the bias generator (analog current)
    input real Iout_them_1,  //input current from the bias generator (analog current)
    input real Iout_them_0,  //input current from the bias generator (analog current)
    input real Iout_binary_5, //input current MSB (analog current)
    input real Iout_binary_4, //input current MSB-1 (analog current)
    input real Iout_binary_3, //input current MSB-2 (analog current)
    input real Iout_binary_2, //input current MSB-3 (analog current)
    input real Iout_binary_1, //input current MSB-4 (analog current)
    input real Iout_binary_0, //input current LSB (analog current)
    input real Iout_binary_0_red, //input current redundancy (analog current)
    input [6:0] datain, //Digital binary control of the converter (digital signal)
    input [6:0] datainb, //Digital binary control of the converter negate (digital signal)
    input [16:0] datatherm , //Digital thermometrical control of the converter (digital signal)
    input [16:0] datathermb, //Digital thermometrical control of the converter negate (digital signal)
    input [4:0] dataical, //Determine which current goes to local output for calbibration (digital signal)
    input real Vcas, //gate cascode voltage (vsupply)
    input real vssana, //gound connection for the block (ground)
    output real Iout, // Output current of the IDAC(analog current)
    output real Ioutb, //Output current negate of the IDAC(analog current)
    output real Ical, //Output current that goes to the comparator for calibration(analog current)
    output real atb1, //analog testbus (analog voltage)
    output real atb0 //analog testbus (analog voltage)
);

    bit enable_funcionality; // Variable to enable the funcionality of the block 1: funcionality enabled, 0: funcionality disabled
    bit input_check; // Variable to check the inputs signals 1: all inputs are correct, 0: at least one input is incorrect
    bit iref_check = 1; // Variable to check the input current iref_500ua 1: correct, 0: incorrect
    bit vddana_1p8_check = 1; // Variable to check the input voltage vddana_1p8 1: correct, 0: incorrect
    bit vddana_0p8_check = 1; // Variable to check the input voltage vddana_0p8 1: correct, 0: incorrect
    bit vssana_check = 1; // Variable to check the input voltage vssana 1: correct, 0: incorrect
    bit vcas_check = 1;  //Variable to check the input voltage Vcas 1: correct, 0: incorrect
    bit Iout_them_check = 1; // Variable to check the input current from the bias generator 1: correct, 0: incorrect
    bit Iout_binary_5_check = 1; // Variable to check the input current MSB 1: correct, 0: incorrect
    bit Iout_binary_4_check = 1; // Variable to check the input current MSB-1 1: correct, 0: incorrect
    bit Iout_binary_3_check = 1; // Variable to check the input current MSB-2 1: correct, 0: incorrect
    bit Iout_binary_2_check = 1; // Variable to check the input current MSB-3 1: correct, 0: incorrect
    bit Iout_binary_1_check = 1; // Variable to check the input current MSB-4 1: correct, 0: incorrect
    bit Iout_binary_0_check = 1; // Variable to check the input current LSB 1: correct, 0: incorrect
    bit Iout_binary_0_red_check = 1; // Variable to check the input current redundancy 1: correct, 0: incorrect
    
    bit check_en =0; // Variable to enable the checks 1: enable, 0: disable

    initial begin
        #1; // Wait 1000ps to start the checks
        check_en =1; // Enable the checks after 1000ps
    end

    //to check that iref current is within the boundaries +/-10%
    parameter real IREF = 500e-6; // 500 µA
    always @(iref_500ua) begin
        if(!check_en || (iref_500ua >= IREF*0.9 && iref_500ua <= IREF*1.1)) begin
            iref_check = 1;
        end else begin
            iref_check = 0;
        end
        iref_ua_boundaries: assert (!check_en || (iref_500ua >= IREF*0.9 && iref_500ua <= IREF*1.1)) else $warning("Input current iref_500ua is out of bounds: %0.2f uA", iref_500ua*1e6);
    end

    //to check that vddana_1p8 voltage is within the boundaries +/-5%
    parameter real VDDANA_1P8_REF = 1.8; // 1.8 V
    always @(vddana_1p8) begin
        if(!check_en || (vddana_1p8 >= VDDANA_1P8_REF*0.95 && vddana_1p8 <= VDDANA_1P8_REF*1.05)) begin
            vddana_1p8_check = 1;
        end else begin
            vddana_1p8_check = 0;
        end
        vddana_1p8_boundaries: assert (!check_en || (vddana_1p8 >= VDDANA_1P8_REF*0.95 && vddana_1p8 <= VDDANA_1P8_REF*1.05)) else $warning("Input voltge vddana_1p8 is out of bounds: %0.2f V", vddana_1p8);
    end

    //to check that vddana_0p8 voltage is within the boundaries +/-5%
    parameter real VDDANA_0P8_REF = 0.8; // 0.8 V
    always @(vddana_0p8) begin
        if(!check_en || (vddana_0p8 >= VDDANA_0P8_REF*0.95 && vddana_0p8 <= VDDANA_0P8_REF*1.05)) begin
            vddana_0p8_check = 1;
        end else begin
            vddana_0p8_check = 0;
        end
        vddana_0p8_boundaries: assert (!check_en || (vddana_0p8 >= VDDANA_0P8_REF*0.95 && vddana_0p8 <= VDDANA_0P8_REF*1.05)) else $warning("Input voltge vddana_0p8 is out of bounds: %0.2f V", vddana_0p8);
    end

    //to check that cascode voltage is within the boundaries +/-5%
    parameter real VCAS_REF = 0.8; // 0.8 V
    always @(Vcas)begin
        if(!check_en || (Vcas >= VCAS_REF*0.95 && Vcas <= VCAS_REF*1.05)) begin
            vcas_check = 1;
        end else begin
            vcas_check = 0;
        end
        vcas_boundaries: assert (!check_en || (Vcas >= VCAS_REF*0.95 && Vcas <= VCAS_REF*1.05)) else $warning("Input voltage Vcas is out of bounds: %0.2f V", Vcas);
    end

    //to check that vssana voltage is within the boundaries +/-5%
    parameter real VSSANA_REF = 0.0; // 0.0 V
    parameter real VSSANA_MIN = VSSANA_REF -0.05; // -0.05 V
    parameter real VSSANA_MAX = VSSANA_REF +0.05; // 0.05 V
    always @(vssana) begin
        if(!check_en || (vssana >= VSSANA_MIN && vssana <= VSSANA_MAX)) begin
            vssana_check = 1;
        end else begin
            vssana_check = 0;
        end
        vssana_boundaries: assert (!check_en || (vssana >= VSSANA_MIN && vssana <= VSSANA_MAX)) else $warning("Input voltge vssana is out of bounds: %0.2f V", vssana);
    end

    //to check that Iout_them_x currents are iref/2.5 to enable funcionality
    parameter real IOUT_THEM_REF = IREF/2.5; // Reference current from the bias generator
    parameter real IOUT_THEM_REF_MAX = IOUT_THEM_REF+IOUT_THEM_REF*0.1; // Reference current from the bias generator
    parameter real IOUT_THEM_REF_MIN = IOUT_THEM_REF-IOUT_THEM_REF*0.1; // Reference current from the bias generator
    always @(Iout_them_16 or Iout_them_15 or Iout_them_14 or Iout_them_13 or Iout_them_12 or Iout_them_11 or Iout_them_10 or Iout_them_9 or Iout_them_8 or Iout_them_7 or Iout_them_6 or Iout_them_5 or Iout_them_4 or Iout_them_3 or Iout_them_2 or Iout_them_1 or Iout_them_0) begin
        if(!check_en || ((Iout_them_16 <= IOUT_THEM_REF_MAX && Iout_them_16 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_15 <= IOUT_THEM_REF_MAX && Iout_them_15 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_14 <= IOUT_THEM_REF_MAX && Iout_them_14 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_13 <= IOUT_THEM_REF_MAX && Iout_them_13 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_12 <= IOUT_THEM_REF_MAX && Iout_them_12 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_11 <= IOUT_THEM_REF_MAX && Iout_them_11 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_10 <= IOUT_THEM_REF_MAX && Iout_them_10 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_9 <= IOUT_THEM_REF_MAX && Iout_them_9 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_8 <= IOUT_THEM_REF_MAX && Iout_them_8 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_7 <= IOUT_THEM_REF_MAX && Iout_them_7 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_6 <= IOUT_THEM_REF_MAX && Iout_them_6 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_5 <= IOUT_THEM_REF_MAX && Iout_them_5 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_4 <= IOUT_THEM_REF_MAX && Iout_them_4 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_3 <= IOUT_THEM_REF_MAX && Iout_them_3 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_2 <= IOUT_THEM_REF_MAX && Iout_them_2 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_1 <= IOUT_THEM_REF_MAX && Iout_them_1 >= IOUT_THEM_REF_MIN) 
        && (Iout_them_0 <= IOUT_THEM_REF_MAX && Iout_them_0 >= IOUT_THEM_REF_MIN))) begin
            Iout_them_check = 1;
        end else begin
            Iout_them_check = 0;
        end
        iout_them_boundaries: assert (!check_en || (Iout_them_16 >= IOUT_THEM_REF_MIN && Iout_them_16 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_15 >= IOUT_THEM_REF_MIN && Iout_them_15 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_14 >= IOUT_THEM_REF_MIN && Iout_them_14 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_13 >= IOUT_THEM_REF_MIN && Iout_them_13 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_12 >= IOUT_THEM_REF_MIN && Iout_them_12 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_11 >= IOUT_THEM_REF_MIN && Iout_them_11 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_10 >= IOUT_THEM_REF_MIN && Iout_them_10 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_9 >= IOUT_THEM_REF_MIN && Iout_them_9 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_8 >= IOUT_THEM_REF_MIN && Iout_them_8 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_7 >= IOUT_THEM_REF_MIN && Iout_them_7 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_6 >= IOUT_THEM_REF_MIN && Iout_them_6 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_5 >= IOUT_THEM_REF_MIN && Iout_them_5 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_4 >= IOUT_THEM_REF_MIN && Iout_them_4 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_3 >= IOUT_THEM_REF_MIN && Iout_them_3 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_2 >= IOUT_THEM_REF_MIN && Iout_them_2 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_1 >= IOUT_THEM_REF_MIN && Iout_them_1 <= IOUT_THEM_REF_MAX) && 
            (Iout_them_0 >= IOUT_THEM_REF_MIN && Iout_them_0 <= IOUT_THEM_REF_MAX)) else $warning("Input currents from the bias generator are not correct: Iout_them_16=%0.5f uA, Iout_them_15=%0.5f uA, Iout_them_14=%0.5f uA, Iout_them_13=%0.5f uA, Iout_them_12=%0.5f uA, Iout_them_11=%0.5f uA, Iout_them_10=%0.5f uA, Iout_them_9=%0.5f uA, Iout_them_8=%0.5f uA, Iout_them_7=%0.5f uA, Iout_them_6=%0.5f uA, Iout_them_5=%0.5f uA, Iout_them_4=%0.5f uA, Iout_them_3=%0.5f uA, Iout_them_2=%0.5f uA, Iout_them_1=%0.5f uA, Iout_them_0=%0.5f uA", 
            Iout_them_16*1e6, Iout_them_15*1e6, Iout_them_14*1e6, Iout_them_13*1e6, Iout_them_12*1e6, Iout_them_11*1e6, Iout_them_10*1e6, 
            Iout_them_9*1e6, Iout_them_8*1e6, Iout_them_7*1e6, Iout_them_6*1e6, Iout_them_5*1e6, Iout_them_4*1e6, Iout_them_3*1e6, Iout_them_2*1e6, Iout_them_1*1e6, Iout_them_0*1e6);
    end

    //to check that Iout_binary_5 is iref/(2.5*2) to enable funcionality
    parameter real IOUT_BINARY_5_REF = IREF/(2.5*2); // Reference current MSB
    parameter real IOUT_BINARY_5_REF_MAX = IOUT_BINARY_5_REF+IOUT_BINARY_5_REF*0.1; // Reference current MSB
    parameter real IOUT_BINARY_5_REF_MIN = IOUT_BINARY_5_REF-IOUT_BINARY_5_REF*0.1; // Reference current MSB
    always @(Iout_binary_5) begin
        if(!check_en || (Iout_binary_5 >= IOUT_BINARY_5_REF_MIN && Iout_binary_5 <= IOUT_BINARY_5_REF_MAX)) begin
            Iout_binary_5_check = 1;
        end else begin
            Iout_binary_5_check = 0;
        end
        iout_binary_5_boundaries: assert (!check_en || (Iout_binary_5 >= IOUT_BINARY_5_REF_MIN && Iout_binary_5 <= IOUT_BINARY_5_REF_MAX)) else $warning("Input current MSB is not correct: Iout_binary_5=%0.5f uA", Iout_binary_5*1e6);
    end
    //to check that Iout_binary_4 is iref/(2.5*4) to enable funcionality
    parameter real IOUT_BINARY_4_REF = IREF/(2.5*4); // Reference current MSB-1
    parameter real IOUT_BINARY_4_REF_MAX = IOUT_BINARY_4_REF+IOUT_BINARY_4_REF*0.1; 
    parameter real IOUT_BINARY_4_REF_MIN = IOUT_BINARY_4_REF-IOUT_BINARY_4_REF*0.1; 
    always @(Iout_binary_4) begin
        if(!check_en || (Iout_binary_4 >= IOUT_BINARY_4_REF_MIN && Iout_binary_4 <= IOUT_BINARY_4_REF_MAX)) begin
            Iout_binary_4_check = 1;
        end else begin
            Iout_binary_4_check = 0;
        end
        iout_binary_4_boundaries: assert (!check_en || (Iout_binary_4 >= IOUT_BINARY_4_REF_MIN && Iout_binary_4 <= IOUT_BINARY_4_REF_MAX)) else $warning("Input current MSB-1 is not correct: Iout_binary_4=%0.5f uA", Iout_binary_4*1e6);
    end
    //to check that Iout_binary_3 is iref/(2.5*8) to enable funcionality
    parameter real IOUT_BINARY_3_REF = IREF/(2.5*8); // Reference current MSB-2
    parameter real IOUT_BINARY_3_REF_MAX = IOUT_BINARY_3_REF+IOUT_BINARY_3_REF*0.1; 
    parameter real IOUT_BINARY_3_REF_MIN = IOUT_BINARY_3_REF-IOUT_BINARY_3_REF*0.1; 
    always @(Iout_binary_3) begin
        if(!check_en || (Iout_binary_3 >= IOUT_BINARY_3_REF_MIN && Iout_binary_3 <= IOUT_BINARY_3_REF_MAX)) begin
            Iout_binary_3_check = 1;
        end else begin
            Iout_binary_3_check = 0;
        end
        iout_binary_3_boundaries: assert (!check_en || (Iout_binary_3 >= IOUT_BINARY_3_REF_MIN && Iout_binary_3 <= IOUT_BINARY_3_REF_MAX)) else $warning("Input current MSB-2 is not correct: Iout_binary_3=%0.5f uA", Iout_binary_3*1e6);
    end
    //to check that Iout_binary_2 is iref/(2.5*16) to enable funcionality
    parameter real IOUT_BINARY_2_REF = IREF/(2.5*16); // Reference current MSB-3
    parameter real IOUT_BINARY_2_REF_MAX = IOUT_BINARY_2_REF+IOUT_BINARY_2_REF*0.1; 
    parameter real IOUT_BINARY_2_REF_MIN = IOUT_BINARY_2_REF-IOUT_BINARY_2_REF*0.1; 
    always @(Iout_binary_2) begin
        if(!check_en || (Iout_binary_2 >= IOUT_BINARY_2_REF_MIN && Iout_binary_2 <= IOUT_BINARY_2_REF_MAX)) begin
            Iout_binary_2_check = 1;
        end else begin
            Iout_binary_2_check = 0;
        end
        iout_binary_2_boundaries: assert (!check_en || (Iout_binary_2 >= IOUT_BINARY_2_REF_MIN && Iout_binary_2 <= IOUT_BINARY_2_REF_MAX)) else $warning("Input current MSB-3 is not correct: Iout_binary_2=%0.5f uA", Iout_binary_2*1e6);
    end
    //to check that Iout_binary_1 is iref/(2.5*32) to enable funcionality
    parameter real IOUT_BINARY_1_REF = IREF/(2.5*32); // Reference current MSB-4
    parameter real IOUT_BINARY_1_REF_MAX = IOUT_BINARY_1_REF+IOUT_BINARY_1_REF*0.1; 
    parameter real IOUT_BINARY_1_REF_MIN = IOUT_BINARY_1_REF-IOUT_BINARY_1_REF*0.1; 
    always @(Iout_binary_1) begin
        if(!check_en || (Iout_binary_1 >= IOUT_BINARY_1_REF_MIN && Iout_binary_1 <= IOUT_BINARY_1_REF_MAX)) begin
            Iout_binary_1_check = 1;
        end else begin
            Iout_binary_1_check = 0;
        end
        iout_binary_1_boundaries: assert (!check_en || (Iout_binary_1 >= IOUT_BINARY_1_REF_MIN && Iout_binary_1 <= IOUT_BINARY_1_REF_MAX)) else $warning("Input current MSB-4 is not correct: Iout_binary_1=%0.5f uA", Iout_binary_1*1e6);
    end
    //to check that Iout_binary_0 is iref/(2.5*64) to enable funcionality 
    parameter real IOUT_BINARY_0_REF = IREF/(2.5*64); // Reference current LSB 
    parameter real IOUT_BINARY_0_REF_MAX = IOUT_BINARY_0_REF+IOUT_BINARY_0_REF*0.1; 
    parameter real IOUT_BINARY_0_REF_MIN = IOUT_BINARY_0_REF-IOUT_BINARY_0_REF*0.1; 
    always @(Iout_binary_0) begin
        if(!check_en || (Iout_binary_0 >= IOUT_BINARY_0_REF_MIN && Iout_binary_0 <= IOUT_BINARY_0_REF_MAX)) begin
            Iout_binary_0_check = 1;
        end else begin
            Iout_binary_0_check = 0;
        end
        iout_binary_0_boundaries: assert (!check_en || (Iout_binary_0 >= IOUT_BINARY_0_REF_MIN && Iout_binary_0 <= IOUT_BINARY_0_REF_MAX)) else $warning("Input current LSB is not correct: Iout_binary_0=%0.5f uA", Iout_binary_0*1e6);
    end
    //to check that Iout_binary_0_red is iref/(2.5*64) to enable funcionality
    parameter real IOUT_BINARY_0_RED_REF = IREF/(2.5*64); // Reference current redundancy
    parameter real IOUT_BINARY_0_RED_REF_MAX = IOUT_BINARY_0_RED_REF+IOUT_BINARY_0_RED_REF*0.1; 
    parameter real IOUT_BINARY_0_RED_REF_MIN = IOUT_BINARY_0_RED_REF-IOUT_BINARY_0_RED_REF*0.1; 
    always @(Iout_binary_0_red) begin
        if(!check_en || (Iout_binary_0_red >= IOUT_BINARY_0_RED_REF_MIN && Iout_binary_0_red <= IOUT_BINARY_0_RED_REF_MAX)) begin
            Iout_binary_0_red_check = 1;
        end else begin
            Iout_binary_0_red_check = 0;
        end
        iout_binary_0_red_boundaries: assert (!check_en || (Iout_binary_0_red >= IOUT_BINARY_0_RED_REF_MIN && Iout_binary_0_red <= IOUT_BINARY_0_RED_REF_MAX)) else $warning("Input current redundancy is not correct: Iout_binary_0_red=%0.5f uA", Iout_binary_0_red*1e6);
    end

    always_comb begin

        if(Iout_them_check && Iout_binary_5_check && Iout_binary_4_check && Iout_binary_3_check && Iout_binary_2_check && Iout_binary_1_check && Iout_binary_0_check && Iout_binary_0_red_check) begin
            enable_funcionality = 1; // Enable funcionality if all input checks are correct
        end else begin
            enable_funcionality = 0; // Disable funcionality if at least one input check is incorrect
            $warning("Input signals are not correct: Iout_them_check=%0d", Iout_them_check);
        end

        if (iref_check && vddana_1p8_check && vddana_0p8_check && vssana_check && vcas_check) begin
            input_check = 1; // All inputs are correct
        end else begin
            input_check = 0; // At least one input is incorrect
            $warning("Input signals boundaries are not correct: iref_check=%0d, vddana_1p8_check=%0d, vddana_0p8_check=%0d, vssana_check=%0d, vcas_check=%0d", iref_check, vddana_1p8_check, vddana_0p8_check, vssana_check, vcas_check);
        end

        if(input_check && enable_funcionality && pdb == 1) begin
            
            //to generate Iout and Ioutb
            Iout = 0;
            Ioutb = 0;
    
            if(datain[0] == 1'b0 && datainb[0] ==1'b1 && dataical != 5'b00001) begin
                //Ioutb += Iout_binary_0_red + Iout_binary_0;
                Ioutb +=  Iout_binary_0;
            end else if(datain[0] == 1'b1 && datainb[0] ==1'b0 && dataical != 5'b00001) begin
               // Iout += Iout_binary_0_red + Iout_binary_0; 
                Iout += Iout_binary_0; 
            end 

            if(datain[1] == 1'b0 && datainb[1] ==1'b1 && dataical != 5'b00010) begin
                Ioutb += Iout_binary_1;
            end else if(datain[1] == 1'b1 && datainb[1] ==1'b0 && dataical != 5'b00010) begin
                Iout += Iout_binary_1;
            end 

            if(datain[2] == 1'b0 && datainb[2] ==1'b1 && dataical != 5'b00011) begin
                Ioutb += Iout_binary_2;
            end else if(datain[2] == 1'b1 && datainb[2] ==1'b0 && dataical != 5'b00011) begin
                Iout += Iout_binary_2;
            end 

            if(datain[3] == 1'b0 && datainb[3] ==1'b1 && dataical != 5'b00100) begin
                Ioutb += Iout_binary_3;
            end else if(datain[3] == 1'b1 && datainb[3] ==1'b0 && dataical != 5'b00100) begin
                Iout += Iout_binary_3;
            end 

            if(datain[4] == 1'b0 && datainb[4] ==1'b1 && dataical != 5'b00101) begin
                Ioutb += Iout_binary_4;
            end else if(datain[4] == 1'b1 && datainb[4] ==1'b0 && dataical != 5'b00101) begin
                Iout += Iout_binary_4;
            end 

            if(datain[5] == 1'b0 && datainb[5] ==1'b1 && dataical != 5'b00110) begin
                Ioutb += Iout_binary_5;
            end else if(datain[5] == 1'b1 && datainb[5] ==1'b0 && dataical != 5'b00110) begin
                Iout += Iout_binary_5;
            end 

            if(datatherm[0] == 1'b0 && datathermb[0] == 1'b1 && dataical != 5'b00111)begin
                Ioutb += Iout_them_0;
            end if(datatherm[0] == 1'b1 && datathermb[0] == 1'b0 && dataical != 5'b00111) begin
                Iout += Iout_them_0;
            end 

            if(datatherm[1] == 1'b0 && datathermb[1] == 1'b1 && dataical != 5'b01000)begin
                Ioutb += Iout_them_1;
            end if(datatherm[1] == 1'b1 && datathermb[1] == 1'b0 && dataical != 5'b01000) begin
                Iout += Iout_them_1;
            end 

            if(datatherm[2] == 1'b0 && datathermb[2] == 1'b1 && dataical != 5'b01001)begin
                Ioutb += Iout_them_2;
            end if(datatherm[2] == 1'b1 && datathermb[2] == 1'b0 && dataical != 5'b01001) begin
                Iout += Iout_them_2;
            end 

            if(datatherm[3] == 1'b0 && datathermb[3] == 1'b1 && dataical != 5'b01010)begin
                Ioutb += Iout_them_3;
            end if(datatherm[3] == 1'b1 && datathermb[3] == 1'b0 && dataical != 5'b01010) begin
                Iout += Iout_them_3;
            end 

            if(datatherm[4] == 1'b0 && datathermb[4] == 1'b1 && dataical != 5'b01011)begin
                Ioutb += Iout_them_4;
            end if(datatherm[4] == 1'b1 && datathermb[4] == 1'b0 && dataical != 5'b01011) begin
                Iout += Iout_them_4;
            end 

            if(datatherm[5] == 1'b0 && datathermb[5] == 1'b1 && dataical != 5'b01100)begin
                Ioutb += Iout_them_5;
            end if(datatherm[5] == 1'b1 && datathermb[5] == 1'b0 && dataical != 5'b01100) begin
                Iout += Iout_them_5;
            end 

            if(datatherm[6] == 1'b0 && datathermb[6] == 1'b1 && dataical != 5'b01101)begin
                Ioutb += Iout_them_6;
            end if(datatherm[6] == 1'b1 && datathermb[6] == 1'b0 && dataical != 5'b01101) begin
                Iout += Iout_them_6;
            end 

            if(datatherm[7] == 1'b0 && datathermb[7] == 1'b1 && dataical != 5'b01110)begin
                Ioutb += Iout_them_7;
            end if(datatherm[7] == 1'b1 && datathermb[7] == 1'b0 && dataical != 5'b01110) begin
                Iout += Iout_them_7;
            end 

            if(datatherm[8] == 1'b0 && datathermb[8] == 1'b1 && dataical != 5'b01111)begin
                Ioutb += Iout_them_8;
            end if(datatherm[8] == 1'b1 && datathermb[8] == 1'b0 && dataical != 5'b01111) begin
                Iout += Iout_them_8;
            end 

            if(datatherm[9] == 1'b0 && datathermb[9] == 1'b1 && dataical != 5'b10000)begin
                Ioutb += Iout_them_9;
            end if(datatherm[9] == 1'b1 && datathermb[9] == 1'b0 && dataical != 5'b10000) begin
                Iout += Iout_them_9;
            end 

            if(datatherm[10] == 1'b0 && datathermb[10] == 1'b1 && dataical != 5'b10001)begin
                Ioutb += Iout_them_10;
            end if(datatherm[10] == 1'b1 && datathermb[10] == 1'b0 && dataical != 5'b10001) begin
                Iout += Iout_them_10;
            end 

            if(datatherm[11] == 1'b0 && datathermb[11] == 1'b1 && dataical != 5'b10010)begin
                Ioutb += Iout_them_11;
            end if(datatherm[11] == 1'b1 && datathermb[11] == 1'b0 && dataical != 5'b10010) begin
                Iout += Iout_them_11;
            end 

            if(datatherm[12] == 1'b0 && datathermb[12] == 1'b1 && dataical != 5'b10011)begin
                Ioutb += Iout_them_12;
            end if(datatherm[12] == 1'b1 && datathermb[12] == 1'b0 && dataical != 5'b10011) begin
                Iout += Iout_them_12;
            end 

            if(datatherm[13] == 1'b0 && datathermb[13] == 1'b1 && dataical != 5'b10100)begin
                Ioutb += Iout_them_13;
            end if(datatherm[13] == 1'b1 && datathermb[13] == 1'b0 && dataical != 5'b10100) begin
                Iout += Iout_them_13;
            end 

            if(datatherm[14] == 1'b0 && datathermb[14] == 1'b1 && dataical != 5'b10101)begin
                Ioutb += Iout_them_14;
            end if(datatherm[14] == 1'b1 && datathermb[14] == 1'b0 && dataical != 5'b10101) begin
                Iout += Iout_them_14;
            end 

            /*if(datatherm[15] == 1'b0 && datathermb[15] == 1'b1 && dataical != 5'b10110)begin
                Ioutb += Iout_them_15;
            end if(datatherm[15] == 1'b1 && datathermb[15] == 1'b0 && dataical != 5'b10110) begin
                Iout += Iout_them_15;
            end 

            if(datatherm[16] == 1'b0 && datathermb[16] == 1'b1 && dataical != 5'b10111)begin
                Ioutb += Iout_them_16;
            end if(datatherm[16] == 1'b1 && datathermb[16] == 1'b0 && dataical != 5'b10111) begin
                Iout += Iout_them_16;
            end */



            //to generate Ical
            case(dataical)
                5'b00000: begin Ical = `wrealZState; end //datacal = 0 
                5'b00001: begin Ical = Iout_binary_0_red; end  //datacal = 1 
                5'b00010: begin Ical = Iout_binary_1; end  //datacal = 2 
                5'b00011: begin Ical = Iout_binary_2; end  //datacal = 3 
                5'b00100: begin Ical = Iout_binary_3; end  //datacal = 4 
                5'b00101: begin Ical = Iout_binary_4; end  //datacal = 5 
                5'b00110: begin Ical = Iout_binary_5; end  //datacal = 6 
                5'b00111: begin Ical = Iout_them_0; end    //datacal = 7 
                5'b01000: begin Ical = Iout_them_1; end    //datacal = 8 
                5'b01001: begin Ical = Iout_them_2; end    //datacal = 9 
                5'b01010: begin Ical = Iout_them_3; end   //datacal = 10 
                5'b01011: begin Ical = Iout_them_4; end   //datacal = 11 
                5'b01100: begin Ical = Iout_them_5; end   //datacal = 12 
                5'b01101: begin Ical = Iout_them_6; end   //datacal = 13 
                5'b01110: begin Ical = Iout_them_7; end   //datacal = 14 
                5'b01111: begin Ical = Iout_them_8; end   //datacal = 15 
                5'b10000: begin Ical = Iout_them_9; end   //datacal = 16 
                5'b10001: begin Ical = Iout_them_10; end  //datacal = 17 
                5'b10010: begin Ical = Iout_them_11; end  //datacal = 18 
                5'b10011: begin Ical = Iout_them_12; end  //datacal = 19 
                5'b10100: begin Ical = Iout_them_13; end  //datacal = 20 
                5'b10101: begin Ical = Iout_them_14; end  //datacal = 21 
                5'b10110: begin Ical = Iout_them_15; end  //datacal = 22 
                5'b10111: begin Ical = Iout_them_16; end  //datacal = 23 
            endcase

            //to generate atb1 and atb0
            case(atb_ena)
                2'b00: begin
                    atb1 = `wrealZState; // High impedance state
                    atb0 = `wrealZState; // High impedance state
                end
                2'b01: begin
                    atb1 = vddana_1p8; // Analog testbus 1 connected to vddana_1p8
                    atb0 = vssana; // Analog testbus 0 connected to vssana
                end
                2'b10: begin
                    atb1 = vddana_0p8; // Analog testbus 1 connected to vddana_0p8
                    atb0 = Vcas; // Analog testbus 0 connected to vcas
                end
                2'b11: begin
                    atb1 = Ical; // Analog testbus 1 connected to Ical
                    atb0 = `wrealZState; // Analog testbus 0 connected to high impedance state
                end
            endcase


        end else if(input_check && enable_funcionality && pdb == 0) begin
            Iout = `wrealZState;
            Ioutb = `wrealZState;
            Ical = `wrealZState;
            atb1 = `wrealZState;
            atb0 = `wrealZState;
        end
    end

endmodule
