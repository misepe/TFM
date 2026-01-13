`timescale 1ps/1ps
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
    parameter real IREF = 25e-6; // 25 µA
    always @(iref_25ua) begin
        if(iref_25ua >= IREF*0.9 && iref_25ua <= IREF*1.1) begin
            iref_check = 1;
        end else begin
            iref_check = 0;
        end
        iref_ua_boundaries: assert (iref_25ua >= IREF*0.9 && iref_25ua <= IREF*1.1) else $warning("Input current iref_25ua is out of bounds: %0.2f uA", iref_25ua*1e6);
    end

    //Generate non lineartinies: jitter and mismatch
    real jitter_therm[16:0];
    real jitter_thermb[16:0];
    real jitter_binary[5:0];
    real jitter_binaryb[5:0];
    real mismatch_therm[16:0];
    real mismatch_thermb[16:0];
    real mismatch_binary[5:0];
    real mismatch_binaryb[5:0];
    // Delay of 50ps and assign auxiliary signals to outputs
    int t_prop=50; //tiempo de propagación de las señales en el bloque

    function real generate_jitter_temp( int i, string type_jitter);
        // Variables
        int seed ;  // Semilla para el generador de números aleatorios
        int mean = 0;         // Promedio de la distribución
        int std_dev = 1;     // Desviación estándar, sigma
        real random_value;      // Valor aleatorio generado

        // Genera valor aleatorio
        seed = $urandom();
        random_value = $dist_normal(seed, mean, std_dev);
        `ifndef DEBUG_DISPLAY
        $display("jitter temporal %s [%0d] = %0d seed = %0d media =%0d sigma = %0d", type_jitter, i, random_value, seed, mean, std_dev);
        `endif
        return random_value;
    endfunction
    function real generate_mismatch_temp(int i, string type_mismatch);
        // Variables
        int seed ;  // Semilla para el generador de números aleatorios
        int mean = 0;         // Promedio de la distribución
        int std_dev = 10;     // Desviación estándar, sigma
        real random_value;      // Valor aleatorio generado

        // Genera valor aleatorio
        seed = $urandom();
        random_value = $dist_normal(seed, mean, std_dev);
        `ifndef DEBUG_DISPLAY
        $display("mismatch temporal %s [%0d] = %0d seed = %0d media =%0d sigma = %0d", type_mismatch, i, random_value, seed, mean, std_dev);
        `endif
        return random_value;
    endfunction

    initial begin
        // Thermometric part mismatch generation
        for (int i=0; i<17; i=i+1) begin
          mismatch_therm[i] = generate_mismatch_temp(i,"therm");
        end
        // Thermometric negated part mismatch generation
        for (int j=0; j<17; j=j+1) begin
          mismatch_thermb[j] = generate_mismatch_temp(j,"thermb");
        end

        // Binary part mismatch generation
        for (int k=0; k<6; k=k+1) begin
          mismatch_binary[k] = generate_mismatch_temp(k,"binary");
        end
        // Binary negated part mismatch generation
        for (int l=0; l<6; l=l+1) begin
          mismatch_binaryb[l] = generate_mismatch_temp(l,"binaryb");
        end
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
        if(pdb == 1) fork
            // Load clkin and clkinb into auxiliary signals
            jitter_therm[16] = generate_jitter_temp(16,"therm");
            jitter_therm[15] = generate_jitter_temp(15,"therm");
            jitter_therm[14] = generate_jitter_temp(14,"therm");
            jitter_therm[13] = generate_jitter_temp(13,"therm");
            jitter_therm[12] = generate_jitter_temp(12,"therm");
            jitter_therm[11] = generate_jitter_temp(11,"therm");
            jitter_therm[10] = generate_jitter_temp(10,"therm");
            jitter_therm[9] = generate_jitter_temp(9,"therm");
            jitter_therm[8] = generate_jitter_temp(8,"therm");
            jitter_therm[7] = generate_jitter_temp(7,"therm");
            jitter_therm[6] = generate_jitter_temp(6,"therm");
            jitter_therm[5] = generate_jitter_temp(5,"therm");
            jitter_therm[4] = generate_jitter_temp(4,"therm");
            jitter_therm[3] = generate_jitter_temp(3,"therm");
            jitter_therm[2] = generate_jitter_temp(2,"therm");
            jitter_therm[1] = generate_jitter_temp(1,"therm");
            jitter_therm[0] = generate_jitter_temp(0,"therm");
            jitter_thermb[16] = generate_jitter_temp(16,"thermb");
            jitter_thermb[15] = generate_jitter_temp(15,"thermb");
            jitter_thermb[14] = generate_jitter_temp(14,"thermb");
            jitter_thermb[13] = generate_jitter_temp(13,"thermb");
            jitter_thermb[12] = generate_jitter_temp(12,"thermb");
            jitter_thermb[11] = generate_jitter_temp(11,"thermb");
            jitter_thermb[10] = generate_jitter_temp(10,"thermb");
            jitter_thermb[9] = generate_jitter_temp(9,"thermb");
            jitter_thermb[8] = generate_jitter_temp(8,"thermb");
            jitter_thermb[7] = generate_jitter_temp(7,"thermb");
            jitter_thermb[6] = generate_jitter_temp(6,"thermb");
            jitter_thermb[5] = generate_jitter_temp(5,"thermb"); 
            jitter_thermb[4] = generate_jitter_temp(4,"thermb");
            jitter_thermb[3] = generate_jitter_temp(3,"thermb");
            jitter_thermb[2] = generate_jitter_temp(2,"thermb");
            jitter_thermb[1] = generate_jitter_temp(1,"thermb");
            jitter_thermb[0] = generate_jitter_temp(0,"thermb");
            jitter_binary[5] = generate_jitter_temp(5,"binary");
            jitter_binary[4] = generate_jitter_temp(4,"binary");
            jitter_binary[3] = generate_jitter_temp(3,"binary");
            jitter_binary[2] = generate_jitter_temp(2,"binary");
            jitter_binary[1] = generate_jitter_temp(1,"binary");
            jitter_binary[0] = generate_jitter_temp(0,"binary");
            jitter_binaryb[5] = generate_jitter_temp(5,"binaryb");
            jitter_binaryb[4] = generate_jitter_temp(4,"binaryb");
            jitter_binaryb[3] = generate_jitter_temp(3,"binaryb");
            jitter_binaryb[2] = generate_jitter_temp(2,"binaryb");
            jitter_binaryb[1] = generate_jitter_temp(1,"binaryb");
            jitter_binaryb[0] = generate_jitter_temp(0,"binaryb");

            
            clkout_therm_16 = #(t_prop+jitter_therm[16]+mismatch_therm[16]) clkin;
            clkout_therm_15 = #(t_prop+jitter_therm[15]+mismatch_therm[15]) clkin;
            clkout_therm_14 = #(t_prop+jitter_therm[14]+mismatch_therm[14]) clkin;
            clkout_therm_13 = #(t_prop+jitter_therm[13]+mismatch_therm[13]) clkin;
            clkout_therm_12 = #(t_prop+jitter_therm[12]+mismatch_therm[12]) clkin;
            clkout_therm_11 = #(t_prop+jitter_therm[11]+mismatch_therm[11]) clkin;
            clkout_therm_10 = #(t_prop+jitter_therm[10]+mismatch_therm[10]) clkin;
            clkout_therm_9 = #(t_prop+jitter_therm[9]+mismatch_therm[9]) clkin;
            clkout_therm_8 = #(t_prop+jitter_therm[8]+mismatch_therm[8]) clkin;
            clkout_therm_7 = #(t_prop+jitter_therm[7]+mismatch_therm[7]) clkin;
            clkout_therm_6 = #(t_prop+jitter_therm[6]+mismatch_therm[6]) clkin;
            clkout_therm_5 = #(t_prop+jitter_therm[5]+mismatch_therm[5]) clkin;
            clkout_therm_4 = #(t_prop+jitter_therm[4]+mismatch_therm[4]) clkin;
            clkout_therm_3 = #(t_prop+jitter_therm[3]+mismatch_therm[3]) clkin;
            clkout_therm_2 = #(t_prop+jitter_therm[2]+mismatch_therm[2]) clkin;
            clkout_therm_1 = #(t_prop+jitter_therm[1]+mismatch_therm[1]) clkin;
            clkout_therm_0 = #(t_prop+jitter_therm[0]+mismatch_therm[0]) clkin;
            clkoutb_therm_16 = #(t_prop+jitter_thermb[16]+mismatch_thermb[16]) clkinb;
            clkoutb_therm_15 = #(t_prop+jitter_thermb[15]+mismatch_thermb[15]) clkinb;
            clkoutb_therm_14 = #(t_prop+jitter_thermb[14]+mismatch_thermb[14]) clkinb;
            clkoutb_therm_13 = #(t_prop+jitter_thermb[13]+mismatch_thermb[13]) clkinb;
            clkoutb_therm_12 = #(t_prop+jitter_thermb[12]+mismatch_thermb[12]) clkinb;
            clkoutb_therm_11 = #(t_prop+jitter_thermb[11]+mismatch_thermb[11]) clkinb;
            clkoutb_therm_10 = #(t_prop+jitter_thermb[10]+mismatch_thermb[10]) clkinb;
            clkoutb_therm_9 = #(t_prop+jitter_thermb[9]+mismatch_thermb[9]) clkinb;
            clkoutb_therm_8 = #(t_prop+jitter_thermb[8]+mismatch_thermb[8]) clkinb;
            clkoutb_therm_7 = #(t_prop+jitter_thermb[7]+mismatch_thermb[7]) clkinb;
            clkoutb_therm_6 = #(t_prop+jitter_thermb[6]+mismatch_thermb[6]) clkinb;
            clkoutb_therm_5 = #(t_prop+jitter_thermb[5]+mismatch_thermb[5]) clkinb;
            clkoutb_therm_4 = #(t_prop+jitter_thermb[4]+mismatch_thermb[4]) clkinb;
            clkoutb_therm_3 = #(t_prop+jitter_thermb[3]+mismatch_thermb[3]) clkinb;
            clkoutb_therm_2 = #(t_prop+jitter_thermb[2]+mismatch_thermb[2]) clkinb;
            clkoutb_therm_1 = #(t_prop+jitter_thermb[1]+mismatch_thermb[1]) clkinb;
            clkoutb_therm_0 = #(t_prop+jitter_thermb[0]+mismatch_thermb[0]) clkinb;
            clkout_binary_5 = #(t_prop+jitter_binary[5]+mismatch_binary[5]) clkin;
            clkout_binary_4 = #(t_prop+jitter_binary[4]+mismatch_binary[4]) clkin;
            clkout_binary_3 = #(t_prop+jitter_binary[3]+mismatch_binary[3]) clkin;
            clkout_binary_2 = #(t_prop+jitter_binary[2]+mismatch_binary[2]) clkin;
            clkout_binary_1 = #(t_prop+jitter_binary[1]+mismatch_binary[1]) clkin;
            clkout_binary_0 = #(t_prop+jitter_binary[0]+mismatch_binary[0]) clkin;
            clkout_binary_0_red = #(t_prop+jitter_binary[0]+mismatch_binary[0]) clkin;
            clkoutb_binary_5 = #(t_prop+jitter_binaryb[5]+mismatch_binaryb[5]) clkinb;
            clkoutb_binary_4 = #(t_prop+jitter_binaryb[4]+mismatch_binaryb[4]) clkinb;
            clkoutb_binary_3 = #(t_prop+jitter_binaryb[3]+mismatch_binaryb[3]) clkinb;
            clkoutb_binary_2 = #(t_prop+jitter_binaryb[2]+mismatch_binaryb[2]) clkinb;
            clkoutb_binary_1 = #(t_prop+jitter_binaryb[1]+mismatch_binaryb[1]) clkinb;
            clkoutb_binary_0 = #(t_prop+jitter_binaryb[0]+mismatch_binaryb[0]) clkinb;
            clkoutb_binary_0_red = #(t_prop+jitter_binaryb[0]+mismatch_binaryb[0]) clkinb;
        
        join else if(pdb == 0)begin

            clkout_therm_16 = 0;
            clkout_therm_15 = 0;
            clkout_therm_14 = 0;
            clkout_therm_13 = 0;
            clkout_therm_12 = 0;
            clkout_therm_11 = 0;
            clkout_therm_10 = 0;
            clkout_therm_9 = 0;
            clkout_therm_8 = 0;
            clkout_therm_7 = 0;
            clkout_therm_6 = 0;
            clkout_therm_5 = 0;
            clkout_therm_4 = 0;
            clkout_therm_3 = 0;
            clkout_therm_2 = 0;
            clkout_therm_1 = 0;
            clkout_therm_0 = 0;
            clkoutb_therm_16 = 0;
            clkoutb_therm_15 = 0;
            clkoutb_therm_14 = 0;
            clkoutb_therm_13 = 0;
            clkoutb_therm_12 = 0;
            clkoutb_therm_11 = 0;
            clkoutb_therm_10 = 0;
            clkoutb_therm_9 = 0;
            clkoutb_therm_8 = 0;
            clkoutb_therm_7 = 0;
            clkoutb_therm_6 = 0;
            clkoutb_therm_5 = 0;
            clkoutb_therm_4 = 0;
            clkoutb_therm_3 = 0;
            clkoutb_therm_2 = 0;
            clkoutb_therm_1 = 0;
            clkoutb_therm_0 = 0;
            
            clkout_binary_5 = 0;
            clkout_binary_4 = 0;
            clkout_binary_3 = 0;
            clkout_binary_2 = 0;
            clkout_binary_1 = 0; 
            clkout_binary_0 = 0;
            clkout_binary_0_red = 0;
            clkoutb_binary_5 = 0;
            clkoutb_binary_4 = 0;
            clkoutb_binary_3 = 0;
            clkoutb_binary_2 = 0;
            clkoutb_binary_1 = 0;
            clkoutb_binary_0 = 0;
            clkoutb_binary_0_red = 0;

        end

    end

endmodule