`timescale 1ps/1ps

module rsync_flip_flop_tb;

    // Señales de entrada
    logic [6:0] datainbin;
    logic [6:0] datainbinb;
    logic [16:0] dataintherm;
    logic [16:0] datainthermb;
    logic clkin_therm_0, clkin_therm_1, clkin_therm_2, clkin_therm_3;
    logic clkin_therm_4, clkin_therm_5, clkin_therm_6, clkin_therm_7;
    logic clkin_therm_8, clkin_therm_9, clkin_therm_10, clkin_therm_11;
    logic clkin_therm_12, clkin_therm_13, clkin_therm_14, clkin_therm_15;
    logic clkin_therm_16;
    logic clkinb_therm_0, clkinb_therm_1, clkinb_therm_2, clkinb_therm_3;
    logic clkinb_therm_4, clkinb_therm_5, clkinb_therm_6, clkinb_therm_7;
    logic clkinb_therm_8, clkinb_therm_9, clkinb_therm_10, clkinb_therm_11;
    logic clkinb_therm_12, clkinb_therm_13, clkinb_therm_14, clkinb_therm_15;
    logic clkinb_therm_16;
    logic clkin_binary_0, clkin_binary_1, clkin_binary_2, clkin_binary_3;
    logic clkin_binary_4, clkin_binary_5;
    logic clkinb_binary_0, clkinb_binary_1, clkinb_binary_2, clkinb_binary_3;
    logic clkinb_binary_4, clkinb_binary_5;
    logic clkin_binary_0_red, clkinb_binary_0_red;
    logic pdb; // Power-down signal
    real vddana_0p8, vssana;
    logic [1:0] atb_ena;
    real iref_25ua;

    // Señales de salida
    logic [16:0] dataouttherm;
    logic [16:0] dataoutthermb;
    logic [6:0] dataoutbin;
    logic [6:0] dataoutbinb;
    logic atb0, atb1;

    // Instancia del DUT (Device Under Test)
    rsync_flip_flop dut (
        .datainbin(datainbin),
        .datainbinb(datainbinb),
        .dataintherm(dataintherm),
        .datainthermb(datainthermb),
        .clkin_therm_0(clkin_therm_0),
        .clkin_therm_1(clkin_therm_1),
        .clkin_therm_2(clkin_therm_2),
        .clkin_therm_3(clkin_therm_3),
        .clkin_therm_4(clkin_therm_4),
        .clkin_therm_5(clkin_therm_5),
        .clkin_therm_6(clkin_therm_6),
        .clkin_therm_7(clkin_therm_7),
        .clkin_therm_8(clkin_therm_8),
        .clkin_therm_9(clkin_therm_9),
        .clkin_therm_10(clkin_therm_10),
        .clkin_therm_11(clkin_therm_11),
        .clkin_therm_12(clkin_therm_12),
        .clkin_therm_13(clkin_therm_13),
        .clkin_therm_14(clkin_therm_14),
        .clkin_therm_15(clkin_therm_15),
        .clkin_therm_16(clkin_therm_16),
        .clkinb_therm_0(clkinb_therm_0),
        .clkinb_therm_1(clkinb_therm_1),
        .clkinb_therm_2(clkinb_therm_2),
        .clkinb_therm_3(clkinb_therm_3),
        .clkinb_therm_4(clkinb_therm_4),
        .clkinb_therm_5(clkinb_therm_5),
        .clkinb_therm_6(clkinb_therm_6),
        .clkinb_therm_7(clkinb_therm_7),
        .clkinb_therm_8(clkinb_therm_8),
        .clkinb_therm_9(clkinb_therm_9),
        .clkinb_therm_10(clkinb_therm_10),
        .clkinb_therm_11(clkinb_therm_11),
        .clkinb_therm_12(clkinb_therm_12),
        .clkinb_therm_13(clkinb_therm_13),
        .clkinb_therm_14(clkinb_therm_14),
        .clkinb_therm_15(clkinb_therm_15),
        .clkinb_therm_16(clkinb_therm_16),
        .clkin_binary_0(clkin_binary_0),
        .clkin_binary_0_red(clkin_binary_0_red),
        .clkin_binary_1(clkin_binary_1),
        .clkin_binary_2(clkin_binary_2),
        .clkin_binary_3(clkin_binary_3),
        .clkin_binary_4(clkin_binary_4),
        .clkin_binary_5(clkin_binary_5),
        .clkinb_binary_0(clkinb_binary_0),
        .clkinb_binary_0_red(clkinb_binary_0_red),
        .clkinb_binary_1(clkinb_binary_1),
        .clkinb_binary_2(clkinb_binary_2),
        .clkinb_binary_3(clkinb_binary_3),
        .clkinb_binary_4(clkinb_binary_4),
        .clkinb_binary_5(clkinb_binary_5),
        .pdb(pdb),
        .vddana_0p8(vddana_0p8),
        .vssana(vssana),
        .atb_ena(atb_ena),
        .iref_25ua(iref_25ua),
        .dataouttherm(dataouttherm),
        .dataoutthermb(dataoutthermb),
        .dataoutbin(dataoutbin),
        .dataoutbinb(dataoutbinb),
        .atb0(atb0),
        .atb1(atb1)
    );

    // Inicialización de señales y generación de relojes
    initial begin
        // Inicialización de señales
        datainbin = 7'b0000000;
        datainbinb = ~datainbin;
        dataintherm = 17'b00000000000000000;
        datainthermb = ~dataintherm;
        pdb = 0; // Power-down desactivado inicialmente
        vddana_0p8 = 0.8;
        vssana = 0;
        atb_ena = 2'b00;
        iref_25ua = 25e-6;

        // Inicialización de relojes
        clkin_therm_0 = 0; clkinb_therm_0 = ~clkin_therm_0;
        clkin_therm_1 = 0; clkinb_therm_1 = ~clkin_therm_1;
        clkin_therm_2 = 0; clkinb_therm_2 = ~clkin_therm_2;
        clkin_therm_3 = 0; clkinb_therm_3 = ~clkin_therm_3;
        clkin_therm_4 = 0; clkinb_therm_4 = ~clkin_therm_4;
        clkin_therm_5 = 0; clkinb_therm_5 = ~clkin_therm_5;
        clkin_therm_6 = 0; clkinb_therm_6 = ~clkin_therm_6;
        clkin_therm_7 = 0; clkinb_therm_7 = ~clkin_therm_7;
        clkin_therm_8 = 0; clkinb_therm_8 = ~clkin_therm_8;
        clkin_therm_9 = 0; clkinb_therm_9 = ~clkin_therm_9;
        clkin_therm_10 = 0; clkinb_therm_10 = ~clkin_therm_10;
        clkin_therm_11 = 0; clkinb_therm_11 = ~clkin_therm_11;
        clkin_therm_12 = 0; clkinb_therm_12 = ~clkin_therm_12;
        clkin_therm_13 = 0; clkinb_therm_13 = ~clkin_therm_13;
        clkin_therm_14 = 0; clkinb_therm_14 = ~clkin_therm_14;
        clkin_therm_15 = 0; clkinb_therm_15 = ~clkin_therm_15;
        clkin_therm_16 = 0; clkinb_therm_16 = ~clkin_therm_16;
        clkin_binary_0_red = 0; clkinb_binary_0_red = ~clkin_binary_0_red;
        clkin_binary_0 = 0; clkinb_binary_0 = ~clkin_binary_0;
        clkin_binary_1 = 0; clkinb_binary_1 = ~clkin_binary_1;
        clkin_binary_2 = 0; clkinb_binary_2 = ~clkin_binary_2;
        clkin_binary_3 = 0; clkinb_binary_3 = ~clkin_binary_3;
        clkin_binary_4 = 0; clkinb_binary_4 = ~clkin_binary_4;
        clkin_binary_5 = 0; clkinb_binary_5 = ~clkin_binary_5;

    end
        // Generar relojes
    initial begin
        forever fork
            begin #100 clkin_therm_0 = ~clkin_therm_0; clkinb_therm_0 = ~clkinb_therm_0; end
            begin #100 clkin_therm_1 = ~clkin_therm_1; clkinb_therm_1 = ~clkinb_therm_1; end
            begin #100 clkin_therm_2 = ~clkin_therm_2; clkinb_therm_2 = ~clkinb_therm_2; end
            begin #100 clkin_therm_3 = ~clkin_therm_3; clkinb_therm_3 = ~clkinb_therm_3; end
            begin #100 clkin_therm_4 = ~clkin_therm_4; clkinb_therm_4 = ~clkinb_therm_4; end
            begin #100 clkin_therm_5 = ~clkin_therm_5; clkinb_therm_5 = ~clkinb_therm_5; end
            begin #100 clkin_therm_6 = ~clkin_therm_6; clkinb_therm_6 = ~clkinb_therm_6; end
            begin #100 clkin_therm_7 = ~clkin_therm_7; clkinb_therm_7 = ~clkinb_therm_7; end
            begin #100 clkin_therm_8 = ~clkin_therm_8; clkinb_therm_8 = ~clkinb_therm_8; end
            begin #100 clkin_therm_9 = ~clkin_therm_9; clkinb_therm_9 = ~clkinb_therm_9; end
            begin #100 clkin_therm_10 = ~clkin_therm_10; clkinb_therm_10 = ~clkinb_therm_10; end
            begin #100 clkin_therm_11 = ~clkin_therm_11; clkinb_therm_11 = ~clkinb_therm_11; end
            begin #100 clkin_therm_12 = ~clkin_therm_12; clkinb_therm_12 = ~clkinb_therm_12; end
            begin #100 clkin_therm_13 = ~clkin_therm_13; clkinb_therm_13 = ~clkinb_therm_13; end
            begin #100 clkin_therm_14 = ~clkin_therm_14; clkinb_therm_14 = ~clkinb_therm_14; end
            begin #100 clkin_therm_15 = ~clkin_therm_15; clkinb_therm_15 = ~clkinb_therm_15; end
            begin #100 clkin_therm_16 = ~clkin_therm_16; clkinb_therm_16 = ~clkinb_therm_16; end
            begin #100 clkin_binary_0_red = ~clkin_binary_0_red; clkinb_binary_0_red = ~clkinb_binary_0_red; end
            begin #100 clkin_binary_0 = ~clkin_binary_0; clkinb_binary_0 = ~clkinb_binary_0; end
            begin #100 clkin_binary_1 = ~clkin_binary_1; clkinb_binary_1 = ~clkinb_binary_1; end
            begin #100 clkin_binary_2 = ~clkin_binary_2; clkinb_binary_2 = ~clkinb_binary_2; end
            begin #100 clkin_binary_3 = ~clkin_binary_3; clkinb_binary_3 = ~clkinb_binary_3; end
            begin #100 clkin_binary_4 = ~clkin_binary_4; clkinb_binary_4 = ~clkinb_binary_4; end
            begin #100 clkin_binary_5 = ~clkin_binary_5; clkinb_binary_5 = ~clkinb_binary_5; end
        join
    end
    
    initial begin
        // Test 1: Verificar estado de apagado (Power-Down)
        $display("Test 1: Verificar estado de apagado (Power-Down)");
        pdb = 0;
        #200;

        // Test 2: Verificar funcionamiento normal
        $display("Test 2: Verificar funcionamiento normal");
        pdb = 1;
        datainbin = 7'b1010101;
        datainbinb = ~datainbin;
        dataintherm = 17'b11001100110011001;
        datainthermb = ~dataintherm;
        #200;
        datainbin = 7'b0101010;
        datainbinb = ~datainbin;
        dataintherm = 17'b01100110011001100;
        datainthermb = ~dataintherm;
        #200;

        // Test 3: Verificar comportamiento de atb_ena
        $display("Test 3: Verificar comportamiento de atb_ena");

        // Caso 1: atb_ena = 2'b00 (alta impedancia)
        atb_ena = 2'b00;
        #200;
        $display("Test 3.1: atb_ena = 2'b00 -> atb0 = %0.2f, atb1 = %0.2f", atb0, atb1);

        // Caso 2: atb_ena = 2'b01
        atb_ena = 2'b01;
        #200;
        $display("Test 3.2: atb_ena = 2'b01 -> atb0 = %0.2f, atb1 = %0.2f", atb0, atb1);

        // Caso 3: atb_ena = 2'b10
        atb_ena = 2'b10;
        #200;
        $display("Test 3.3: atb_ena = 2'b10 -> atb0 = %0.2f, atb1 = %0.2f", atb0, atb1);

        // Caso 4: atb_ena = 2'b11
        atb_ena = 2'b11;
        #200;
        $display("Test 3.4: atb_ena = 2'b11 -> atb0 = %0.2f, atb1 = %0.2f", atb0, atb1);

        //Final del test
        $display("Simulación completada.");
        $finish;
    end

endmodule