`timescale 1ps/1ps

module clock_distribution_tb;

    // Señales de entrada
    reg clkin;
    reg clkinb;
    real iref_25ua;
    reg pdb;
    reg [1:0] atb_ena;
    real vddana_0p8;
    real vssana;

    // Señales de salida
    wire clkout_therm_16, clkout_therm_15, clkout_therm_14, clkout_therm_13, clkout_therm_12;
    wire clkout_therm_11, clkout_therm_10, clkout_therm_9, clkout_therm_8, clkout_therm_7;
    wire clkout_therm_6, clkout_therm_5, clkout_therm_4, clkout_therm_3, clkout_therm_2;
    wire clkout_therm_1, clkout_therm_0;
    wire clkoutb_therm_16, clkoutb_therm_15, clkoutb_therm_14, clkoutb_therm_13, clkoutb_therm_12;
    wire clkoutb_therm_11, clkoutb_therm_10, clkoutb_therm_9, clkoutb_therm_8, clkoutb_therm_7;
    wire clkoutb_therm_6, clkoutb_therm_5, clkoutb_therm_4, clkoutb_therm_3, clkoutb_therm_2;
    wire clkoutb_therm_1, clkoutb_therm_0;
    wire clkout_binary_5, clkout_binary_4, clkout_binary_3, clkout_binary_2, clkout_binary_1;
    wire clkout_binary_0, clkout_binary_0_red;
    wire clkoutb_binary_5, clkoutb_binary_4, clkoutb_binary_3, clkoutb_binary_2, clkoutb_binary_1;
    wire clkoutb_binary_0, clkoutb_binary_0_red;
    real atb1, atb0;

    // Instancia del DUT
    clock_distribution dut (
        .clkin(clkin),
        .clkinb(clkinb),
        .iref_25ua(iref_25ua),
        .pdb(pdb),
        .atb_ena(atb_ena),
        .vddana_0p8(vddana_0p8),
        .vssana(vssana),
        .clkout_therm_16(clkout_therm_16),
        .clkout_therm_15(clkout_therm_15),
        .clkout_therm_14(clkout_therm_14),
        .clkout_therm_13(clkout_therm_13),
        .clkout_therm_12(clkout_therm_12),
        .clkout_therm_11(clkout_therm_11),
        .clkout_therm_10(clkout_therm_10),
        .clkout_therm_9(clkout_therm_9),
        .clkout_therm_8(clkout_therm_8),
        .clkout_therm_7(clkout_therm_7),
        .clkout_therm_6(clkout_therm_6),
        .clkout_therm_5(clkout_therm_5),
        .clkout_therm_4(clkout_therm_4),
        .clkout_therm_3(clkout_therm_3),
        .clkout_therm_2(clkout_therm_2),
        .clkout_therm_1(clkout_therm_1),
        .clkout_therm_0(clkout_therm_0),
        .clkoutb_therm_16(clkoutb_therm_16),
        .clkoutb_therm_15(clkoutb_therm_15),
        .clkoutb_therm_14(clkoutb_therm_14),
        .clkoutb_therm_13(clkoutb_therm_13),
        .clkoutb_therm_12(clkoutb_therm_12),
        .clkoutb_therm_11(clkoutb_therm_11),
        .clkoutb_therm_10(clkoutb_therm_10),
        .clkoutb_therm_9(clkoutb_therm_9),
        .clkoutb_therm_8(clkoutb_therm_8),
        .clkoutb_therm_7(clkoutb_therm_7),
        .clkoutb_therm_6(clkoutb_therm_6),
        .clkoutb_therm_5(clkoutb_therm_5),
        .clkoutb_therm_4(clkoutb_therm_4),
        .clkoutb_therm_3(clkoutb_therm_3),
        .clkoutb_therm_2(clkoutb_therm_2),
        .clkoutb_therm_1(clkoutb_therm_1),
        .clkoutb_therm_0(clkoutb_therm_0),
        .clkout_binary_5(clkout_binary_5),
        .clkout_binary_4(clkout_binary_4),
        .clkout_binary_3(clkout_binary_3),
        .clkout_binary_2(clkout_binary_2),
        .clkout_binary_1(clkout_binary_1),
        .clkout_binary_0(clkout_binary_0),
        .clkout_binary_0_red(clkout_binary_0_red),
        .clkoutb_binary_5(clkoutb_binary_5),
        .clkoutb_binary_4(clkoutb_binary_4),
        .clkoutb_binary_3(clkoutb_binary_3),
        .clkoutb_binary_2(clkoutb_binary_2),
        .clkoutb_binary_1(clkoutb_binary_1),
        .clkoutb_binary_0(clkoutb_binary_0),
        .clkoutb_binary_0_red(clkoutb_binary_0_red),
        .atb1(atb1),
        .atb0(atb0)
    );

    // Generador de clkin y clkinb
    initial begin
        clkin = 1'b0;  // Inicializa clkin en 0
        clkinb = 1'b1; // Inicializa clkinb en 1 (complemento de clkin)
    end

    always #100 begin //5GHz de reloj (perido de 200ps y medio ciclo de 100ps)
        clkin = ~clkin;  // Invierte el valor de clkin cada 50 ps
        clkinb = ~clkinb; // Invierte el valor de clkinb cada 50 ps
    end

    // Bloque inicial para ejecutar los tests
    initial begin
        $display("Iniciando tests...");

        iref_25ua = 25e-6;

        // Test 1: Estado apagado
        $display("Test 1: Estado apagado");
        pdb = 0;
        vddana_0p8 = 0.8;
        vssana = 0.0;
        #300;
        $display("clkout_therm_16 = %b, clkoutb_therm_16 = %b", clkout_therm_16, clkoutb_therm_16);

        // Test 2: Estado encendido con atb_ena = 2'b00
        $display("Test 2: Estado encendido con atb_ena = 2'b00");
        pdb = 1;
        atb_ena = 2'b00;
        vddana_0p8 = 0.8;
        vssana = 0.0;
        #300;
        $display("atb1 = %0.2f, atb0 = %0.2f", atb1, atb0);

        // Test 3: Estado encendido con atb_ena = 2'b01
        $display("Test 3: Estado encendido con atb_ena = 2'b01");
        atb_ena = 2'b01;
        #300;
        $display("atb1 = %0.2f, atb0 = %0.2f", atb1, atb0);

        // Test 4: Estado encendido con atb_ena = 2'b10
        $display("Test 4: Estado encendido con atb_ena = 2'b10");
        atb_ena = 2'b10;
        #300;
        $display("atb1 = %0.2f, atb0 = %0.2f", atb1, atb0);

        // Test 5: Estado encendido con atb_ena = 2'b11
        $display("Test 5: Estado encendido con atb_ena = 2'b11");
        atb_ena = 2'b11;
        
        #1000;
        $display("atb1 = %0.2f, atb0 = %0.2f", atb1, atb0);

        $display("Tests completados.");
        $finish;
    end

endmodule