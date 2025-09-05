`timescale 1ps/1ps

module currentSourceUnits_tb;

    // Señales de entrada
    real iref_500ua;       // Corriente de referencia
    bit pdb = 1;                // Señal de power down
    bit [1:0] atb_ena;      // Señal de habilitación del testbus
    real vddana_1p8;       // Fuente de alimentación de 1.8V
    real vddana_0p8;       // Fuente de alimentación de 0.8V
    real vssana;           // Conexión a tierra

    // Señales de salida
    real Iout_them_16, Iout_them_15, Iout_them_14, Iout_them_13, Iout_them_12;
    real Iout_them_11, Iout_them_10, Iout_them_9, Iout_them_8, Iout_them_7;
    real Iout_them_6, Iout_them_5, Iout_them_4, Iout_them_3, Iout_them_2;
    real Iout_them_1, Iout_them_0;
    real Iout_binary_5, Iout_binary_4, Iout_binary_3, Iout_binary_2;
    real Iout_binary_1, Iout_binary_0, Iout_binary_0_red;
    real atb1, atb0;

    // Instancia del DUT (Device Under Test)
    currentSourceUnits dut (
        .iref_500ua(iref_500ua),
        .pdb(pdb),
        .atb_ena(atb_ena),
        .vddana_1p8(vddana_1p8),
        .vddana_0p8(vddana_0p8),
        .vssana(vssana),
        .Iout_them_16(Iout_them_16),
        .Iout_them_15(Iout_them_15),
        .Iout_them_14(Iout_them_14),
        .Iout_them_13(Iout_them_13),
        .Iout_them_12(Iout_them_12),
        .Iout_them_11(Iout_them_11),
        .Iout_them_10(Iout_them_10),
        .Iout_them_9(Iout_them_9),
        .Iout_them_8(Iout_them_8),
        .Iout_them_7(Iout_them_7),
        .Iout_them_6(Iout_them_6),
        .Iout_them_5(Iout_them_5),
        .Iout_them_4(Iout_them_4),
        .Iout_them_3(Iout_them_3),
        .Iout_them_2(Iout_them_2),
        .Iout_them_1(Iout_them_1),
        .Iout_them_0(Iout_them_0),
        .Iout_binary_5(Iout_binary_5), .Iout_binary_4(Iout_binary_4), .Iout_binary_3(Iout_binary_3),
        .Iout_binary_2(Iout_binary_2), .Iout_binary_1(Iout_binary_1), .Iout_binary_0(Iout_binary_0),
        .Iout_binary_0_red(Iout_binary_0_red),
        .atb1(atb1),
        .atb0(atb0)
    );

    // Parámetros de los límites
    parameter real IREF_MIN = 500e-6 * 0.9; // Límite inferior de iref_500ua
    parameter real IREF_MAX = 500e-6 * 1.1; // Límite superior de iref_500ua
    parameter real VDDANA_1P8_MIN = 1.8 * 0.95; // Límite inferior de vddana_1p8
    parameter real VDDANA_1P8_MAX = 1.8 * 1.05; // Límite superior de vddana_1p8
    parameter real VDDANA_0P8_MIN = 0.8 * 0.95; // Límite inferior de vddana_0p8
    parameter real VDDANA_0P8_MAX = 0.8 * 1.05; // Límite superior de vddana_0p8
    parameter real VSSANA_MIN = 0.0 * 0.95; // Límite inferior de vssana
    parameter real VSSANA_MAX = 0.0 * 1.05; // Límite superior de vssana (siempre 0.0)


    // Bloque inicial para asignar valores iniciales
    initial begin
        // Asignar valores iniciales a las señales de entrada
        iref_500ua = 500e-6;  // 500 µA
        pdb = 1'b1;           // Power down desactivado
        atb_ena = 2'b01;      // Habilitar un testbus
        vddana_1p8 = 1.8;     // Fuente de alimentación de 1.8V
        vddana_0p8 = 0.8;     // Fuente de alimentación de 0.8V
        vssana = 0.0;         // Conexión a tierra
        atb_ena = 2'b01;      // Habilitar un testbus

        // Esperar un tiempo para la simulación

        // Barrido de iref_500ua
        $display("Barrido de iref_500ua:");
        for (iref_500ua = IREF_MIN; iref_500ua <= IREF_MAX; iref_500ua = iref_500ua + 100e-6) begin
            #10; // Esperar 10 unidades de tiempo
            $display("iref_500ua = %0.6f A", iref_500ua);
        end
        iref_500ua = 500e-6;
        #10;

        // Barrido de vddana_1p8
        $display("Barrido de vddana_1p8:");
        for (vddana_1p8 = VDDANA_1P8_MIN; vddana_1p8 <= VDDANA_1P8_MAX; vddana_1p8 = vddana_1p8 + 0.01) begin
            #10; // Esperar 10 unidades de tiempo
            $display("vddana_1p8 = %0.2f V", vddana_1p8);
        end
        vddana_1p8 = 1.8;
        #10;

        // Barrido de vddana_0p8
        $display("Barrido de vddana_0p8:");
        for (vddana_0p8 = VDDANA_0P8_MIN; vddana_0p8 <= VDDANA_0P8_MAX; vddana_0p8 = vddana_0p8 + 0.01) begin
            #10; // Esperar 10 unidades de tiempo
            $display("vddana_0p8 = %0.2f V", vddana_0p8);
        end
        vddana_0p8 = 0.8;  
        #10;

        // Barrido de atb_ena
        $display("Barrido de atb_ena:");
        atb_ena = 2'b00;
        #10; // Esperar 10 unidades de tiempo
        $display("atb_ena = %b", atb_ena);
        atb_ena = 2'b01;
        #10; // Esperar 10 unidades de tiempo
        $display("atb_ena = %b", atb_ena);
        atb_ena = 2'b10;
        #10; // Esperar 10 unidades de tiempo
        $display("atb_ena = %b", atb_ena);
        atb_ena = 2'b11;
        #10; // Esperar 10 unidades de tiempo
        $display("atb_ena = %b", atb_ena);
        atb_ena = 2'b01; 
        #10;

        // Barrido de pdb (activado/desactivado)
        $display("Barrido de pdb:");
        pdb = 1'b0;
        #10; // Esperar 10 unidades de tiempo
        $display("pdb = %0d", pdb);
        pdb = 1'b1;
        #10; // Esperar 10 unidades de tiempo
        $display("pdb = %0d", pdb);

        #100;

        // Finalizar la simulación
        $finish;
    end

endmodule