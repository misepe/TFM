`timescale 1ns/1ps

module local_bias_tb;

    // Señales de entrada
    logic pdb;
    real vddana_1p8;
    real vddana_0p8;
    real vssana;
    logic [1:0] atb_ena;

    // Señales de salida
    real iclkdist_25ua;
    real isynclatch_25ua;
    real icurrentsterring_500ua;
    real icurrentsource_500ua;
    real atb1;
    real atb0;

    // Instancia del DUT (Device Under Test)
    local_bias dut (
        .pdb(pdb),
        .vddana_1p8(vddana_1p8),
        .vddana_0p8(vddana_0p8),
        .vssana(vssana),
        .atb_ena(atb_ena),
        .iclkdist_25ua(iclkdist_25ua),
        .isynclatch_25ua(isynclatch_25ua),
        .icurrentsterring_500ua(icurrentsterring_500ua),
        .icurrentsource_500ua(icurrentsource_500ua),
        .atb1(atb1),
        .atb0(atb0)
    );

    
    initial begin
        // Test 1: Barrido de entradas con checkers
        $display("Test 1: Barrido de entradas con checkers");

        // Barrido de vddana_1p8
        vddana_0p8 = 0.8;
        vssana = 0.0;
        pdb = 1;
        atb_ena = 2'b00;
        $display("Barrido de vddana_1p8:");
        vddana_1p8 = 1.7; #10; // Fuera de rango
        vddana_1p8 = 1.8; #10; // Dentro de rango
        vddana_1p8 = 1.9; #10; // Fuera de rango

        // Barrido de vddana_0p8
        vddana_1p8 = 1.8;
        $display("Barrido de vddana_0p8:");
        vddana_0p8 = 0.75; #10; // Fuera de rango
        vddana_0p8 = 0.8;  #10; // Dentro de rango
        vddana_0p8 = 0.85; #10; // Fuera de rango

        // Barrido de vssana
        $display("Barrido de vssana:");
        vssana = -0.1; #10; // Fuera de rango
        vssana = 0.0;  #10; // Dentro de rango
        vssana = 0.1;  #10; // Fuera de rango

        // Test 2: Verificar salidas de los testbus (atb_ena)
        $display("Test 2: Verificar salidas de los testbus (atb_ena)");
        vddana_1p8 = 1.8;
        vddana_0p8 = 0.8;
        vssana = 0.0;
        pdb = 1;

        // Caso 1: atb_ena = 2'b00
        atb_ena = 2'b00; #10;
        $display("atb_ena = 2'b00 -> atb1 = %0.2f, atb0 = %0.2f", atb1, atb0);

        // Caso 2: atb_ena = 2'b01
        atb_ena = 2'b01; #10;
        $display("atb_ena = 2'b01 -> atb1 = %0.2f, atb0 = %0.2f", atb1, atb0);

        // Caso 3: atb_ena = 2'b10
        atb_ena = 2'b10; #10;
        $display("atb_ena = 2'b10 -> atb1 = %0.2f, atb0 = %0.2f", atb1, atb0);

        // Caso 4: atb_ena = 2'b11
        atb_ena = 2'b11; #10;
        $display("atb_ena = 2'b11 -> atb1 = %0.2f, atb0 = %0.2f", atb1, atb0);

        // Test 3: Verificar funcionamiento de pdb
        $display("Test 3: Verificar funcionamiento de pdb");
        vddana_1p8 = 1.8;
        vddana_0p8 = 0.8;
        vssana = 0.0;
        atb_ena = 2'b11;

        // Caso 1: pdb = 0
        pdb = 0; #10;
        $display("pdb = 0 -> atb1 = %0.2f, atb0 = %0.2f, iclkdist_25ua = %0.2f", atb1, atb0, iclkdist_25ua);

        // Caso 2: pdb = 1
        pdb = 1; #10;
        $display("pdb = 1 -> atb1 = %0.2f, atb0 = %0.2f, iclkdist_25ua = %0.2f", atb1, atb0, iclkdist_25ua);
    end

    // Finalizar simulación
    initial begin
        #200;
        $display("Simulación completada.");
        $finish;
    end

endmodule