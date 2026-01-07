`timescale 1ps/1ps
import cds_rnm_pkg::*; // Importing the Cadence RNM package

module currentSourceUnits (
    input real iref_500ua, // input reference current(analog signal)
    input pdb, //power down negate signal (digital signal)
    input [1:0] atb_ena, //stablish the output of the differential testbus (digital signal)
    input real vddana_1p8, //power supply for the block (vsupply)
    input real vddana_0p8, //power supply for the block (vsupply)
    input real vssana, //gound connection for the block (ground)
    output real Iout_them_16, // Output current (analog current)
    output real Iout_them_15, // Output current (analog current)
    output real Iout_them_14, // Output current (analog current)
    output real Iout_them_13, // Output current (analog current)
    output real Iout_them_12, // Output current (analog current)
    output real Iout_them_11, // Output current (analog current)
    output real Iout_them_10, // Output current (analog current)
    output real Iout_them_9,  // Output current (analog current)
    output real Iout_them_8,  // Output current (analog current)
    output real Iout_them_7,  // Output current (analog current)
    output real Iout_them_6,  // Output current (analog current)
    output real Iout_them_5,  // Output current (analog current)
    output real Iout_them_4,  // Output current (analog current)
    output real Iout_them_3,  // Output current (analog current)
    output real Iout_them_2,  // Output current (analog current)
    output real Iout_them_1,  // Output current (analog current)
    output real Iout_them_0,  // Output current (analog current)
    output real Iout_binary_5, //output current MSB (analog current)
    output real Iout_binary_4, //output current MSB-1 (analog current)
    output real Iout_binary_3, //output current MSB-2 (analog current)
    output real Iout_binary_2, //output current MSB-3 (analog current)
    output real Iout_binary_1, //output current MSB-4 (analog current)
    output real Iout_binary_0, //output current LSB (analog current)
    output real Iout_binary_0_red, //output current redundancy (analog current)
    output real atb1, //analog testbus (analog voltage)
    output real atb0 //analog testbus (analog voltage)
);
    
    bit input_check; // Variable to check the inputs signals 1: all inputs are correct, 0: at least one input is incorrect
    bit iref_check = 1; // Variable to check the input current iref_500ua 1: correct, 0: incorrect
    bit vddana_1p8_check = 1; // Variable to check the input voltage vddana_1p8 1: correct, 0: incorrect
    bit vddana_0p8_check = 1; // Variable to check the input voltage vddana_0p8 1: correct, 0: incorrect
    bit vssana_check = 1; // Variable to check the input voltage vssana 1: correct, 0: incorrect

    //to check that iref current is within the boundaries +/-10%
    parameter real IREF = 500e-6; // 500 µA
    always @(iref_500ua) begin
        if(iref_500ua >= IREF*0.9 && iref_500ua <= IREF*1.1) begin
            iref_check = 1;
        end else begin
            iref_check = 0;
        end
        iref_ua_boundaries: assert (iref_500ua >= IREF*0.9 && iref_500ua <= IREF*1.1) else $warning("Input current iref_500ua is out of bounds: %0.2f uA", iref_500ua*1e6);
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
    real mismatch_iout_therm_16, mismatch_iout_therm_15, mismatch_iout_therm_14, mismatch_iout_therm_13;
    real mismatch_iout_therm_12, mismatch_iout_therm_11, mismatch_iout_therm_10, mismatch_iout_therm_9;
    real mismatch_iout_therm_8, mismatch_iout_therm_7, mismatch_iout_therm_6, mismatch_iout_therm_5;
    real mismatch_iout_therm_4, mismatch_iout_therm_3, mismatch_iout_therm_2, mismatch_iout_therm_1;
    real mismatch_iout_therm_0;
    real mismatch_iout_binary_5, mismatch_iout_binary_4, mismatch_iout_binary_3;
    real mismatch_iout_binary_2, mismatch_iout_binary_1, mismatch_iout_binary_0, mismatch_iout_binary_0_red;

    function real generate_mismatch();
        real temp;
        temp = $urandom()%4000;
        $display("Raw binary mismatch = %0d", temp);
        $display("Binary mismatch= %0.4f", ((temp)-2000) / 100000.0);
        return ((temp)-2000) / 100000.0;
    endfunction

    initial begin
        //generate mismatch for thermometer outputs
        mismatch_iout_therm_16 = generate_mismatch();
        mismatch_iout_therm_15 = generate_mismatch();
        mismatch_iout_therm_14 = generate_mismatch();
        mismatch_iout_therm_13 = generate_mismatch();
        mismatch_iout_therm_12 = generate_mismatch();
        mismatch_iout_therm_11 = generate_mismatch();
        mismatch_iout_therm_10 = generate_mismatch();
        mismatch_iout_therm_9  = generate_mismatch();
        mismatch_iout_therm_8  = generate_mismatch();
        mismatch_iout_therm_7  = generate_mismatch();
        mismatch_iout_therm_6  = generate_mismatch();
        mismatch_iout_therm_5  = generate_mismatch();
        mismatch_iout_therm_4  = generate_mismatch();
        mismatch_iout_therm_3  = generate_mismatch();
        mismatch_iout_therm_2  = generate_mismatch();
        mismatch_iout_therm_1  = generate_mismatch();
        mismatch_iout_therm_0  = generate_mismatch();
        //generate mismatch for binary outputs
        mismatch_iout_binary_5 = generate_mismatch();
        mismatch_iout_binary_4 = generate_mismatch();
        mismatch_iout_binary_3 = generate_mismatch();
        mismatch_iout_binary_2 = generate_mismatch();
        mismatch_iout_binary_1 = generate_mismatch();
        mismatch_iout_binary_0 = generate_mismatch();
        mismatch_iout_binary_0_red = generate_mismatch();
    end

    always_comb begin

        if (iref_check && vddana_1p8_check && vddana_0p8_check && vssana_check) begin
            input_check = 1; // All inputs are correct
        end else begin
            input_check = 0; // At least one input is incorrect
            $warning("Input signals are not correct: iref_check=%0d, vddana_1p8_check=%0d, vddana_0p8_check=%0d, vssana_check=%0d", iref_check, vddana_1p8_check, vddana_0p8_check, vssana_check);
        end

        if(pdb == 1 && input_check == 1) begin
            //Generate Iout_16..0: TODO no se muy bien como manejar el array y sus valores

            Iout_them_16 = (iref_500ua / 2.5) + (mismatch_iout_therm_16* (iref_500ua / 2.5));
            Iout_them_15 = (iref_500ua / 2.5) + (mismatch_iout_therm_15* (iref_500ua / 2.5));
            Iout_them_14 = (iref_500ua / 2.5) + (mismatch_iout_therm_14* (iref_500ua / 2.5));
            Iout_them_13 = (iref_500ua / 2.5) + (mismatch_iout_therm_13* (iref_500ua / 2.5));
            Iout_them_12 = (iref_500ua / 2.5) + (mismatch_iout_therm_12* (iref_500ua / 2.5));
            Iout_them_11 = (iref_500ua / 2.5) + (mismatch_iout_therm_11* (iref_500ua / 2.5));
            Iout_them_10 = (iref_500ua / 2.5) + (mismatch_iout_therm_10* (iref_500ua / 2.5));
            Iout_them_9  = (iref_500ua / 2.5) + (mismatch_iout_therm_9* (iref_500ua / 2.5));
            Iout_them_8  = (iref_500ua / 2.5) + (mismatch_iout_therm_8* (iref_500ua / 2.5));
            Iout_them_7  = (iref_500ua / 2.5) + (mismatch_iout_therm_7* (iref_500ua / 2.5));
            Iout_them_6  = (iref_500ua / 2.5) + (mismatch_iout_therm_6* (iref_500ua / 2.5));
            Iout_them_5  = (iref_500ua / 2.5) + (mismatch_iout_therm_5* (iref_500ua / 2.5));
            Iout_them_4  = (iref_500ua / 2.5) + (mismatch_iout_therm_4* (iref_500ua / 2.5));
            Iout_them_3  = (iref_500ua / 2.5) + (mismatch_iout_therm_3* (iref_500ua / 2.5));
            Iout_them_2  = (iref_500ua / 2.5) + (mismatch_iout_therm_2* (iref_500ua / 2.5));
            Iout_them_1  = (iref_500ua / 2.5) + (mismatch_iout_therm_1* (iref_500ua / 2.5));
            Iout_them_0  = (iref_500ua / 2.5) + (mismatch_iout_therm_0* (iref_500ua / 2.5));

            Iout_binary_5 = (iref_500ua / (2.5 * 2)) + (mismatch_iout_binary_5* (iref_500ua / (2.5 * 2)));
            Iout_binary_4 = (iref_500ua / (2.5 * 4)) + (mismatch_iout_binary_4* (iref_500ua / (2.5 * 4)));
            Iout_binary_3 = (iref_500ua / (2.5 * 8)) + (mismatch_iout_binary_3* (iref_500ua / (2.5 * 8)));
            Iout_binary_2 = (iref_500ua / (2.5 * 16)) + (mismatch_iout_binary_2* (iref_500ua / (2.5 * 16)));
            Iout_binary_1 = (iref_500ua / (2.5 * 32)) + (mismatch_iout_binary_1* (iref_500ua / (2.5 * 32)));
            Iout_binary_0 = (iref_500ua / (2.5 * 64)) + (mismatch_iout_binary_0* (iref_500ua / (2.5 * 64)));
            Iout_binary_0_red = (iref_500ua / (2.5 * 64)) + (mismatch_iout_binary_0_red* (iref_500ua / (2.5 * 64))); // Redundant output

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
                atb0 = Iout_them_16; // Analog testbus 0 connected to Iout_them_16
            end
            2'b11: begin
                atb1 = iref_500ua; // Analog testbus 1 connected to iref_500ua
                atb0 = Iout_binary_0_red; // Analog testbus 0 connected to Iout_binary_0_red
            end


        endcase
        end else if(pdb == 0 && input_check == 1) begin
            Iout_them_16 = `wrealZState; // High impedance state
            Iout_them_15 = `wrealZState; // High impedance state
            Iout_them_14 = `wrealZState; // High impedance state
            Iout_them_13 = `wrealZState; // High impedance state
            Iout_them_12 = `wrealZState; // High impedance state
            Iout_them_11 = `wrealZState; // High impedance state
            Iout_them_10 = `wrealZState; // High impedance state
            Iout_them_9  = `wrealZState; // High impedance state
            Iout_them_8  = `wrealZState; // High impedance state
            Iout_them_7  = `wrealZState; // High impedance state
            Iout_them_6  = `wrealZState; // High impedance state
            Iout_them_5  = `wrealZState; // High impedance state
            Iout_them_4  = `wrealZState; // High impedance state
            Iout_them_3  = `wrealZState; // High impedance state
            Iout_them_2  = `wrealZState; // High impedance state
            Iout_them_1  = `wrealZState; // High impedance state
            Iout_them_0  = `wrealZState; // High impedance state
            Iout_binary_5 = `wrealZState; // High impedance state
            Iout_binary_4 = `wrealZState; // High impedance state
            Iout_binary_3 = `wrealZState; // High impedance state
            Iout_binary_2 = `wrealZState; // High impedance state
            Iout_binary_1 = `wrealZState; // High impedance state
            Iout_binary_0 = `wrealZState; // High impedance state
            Iout_binary_0_red = `wrealZState; // High impedance state
            atb1 = `wrealZState; // High impedance state
            atb0 = `wrealZState; // High impedance state
        end 

    end

endmodule