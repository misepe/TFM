`timescale 1ps/1ps

module currentSterring_tb;

    // Señales de entrada
    real iref_500ua;       // Corriente de referencia
    bit pdb;               // Señal de power down
    bit [1:0] atb_ena;     // Señal de habilitación del testbus
    real vddana_1p8;       // Fuente de alimentación de 1.8V
    real vddana_0p8;       // Fuente de alimentación de 0.8V
    real vssana;           // Conexión a tierra
    real Vcas;             // Voltaje cascode
    bit [6:0] datain;      // Control binario
    bit [6:0] datainb;     // Control binario negado
    bit [16:0] datatherm;  // Control termométrico
    bit [16:0] datathermb; // Control termométrico negado
    bit [4:0] dataical;    // Control de calibración

    // Señales de entrada adicionales
    real Iout_them[16:0];  // Corrientes de entrada del generador de bias
    real Iout_binary[5:0]; // Corrientes binarias
    real Iout_binary_0_red; // Corriente redundante

    // Señales de salida
    real Iout;             // Corriente de salida
    real Ioutb;            // Corriente de salida negada
    real Ical;             // Corriente de calibración
    real atb1, atb0;       // Testbus analógico

    parameter real VDDANA_1P8_MIN = 1.8 * 0.95; // Límite inferior de vddana_1p8
    parameter real VDDANA_1P8_MAX = 1.8 * 1.05; // Límite superior de vddana_1p8
    parameter real VDDANA_0P8_MIN = 0.8 * 0.95; // Límite inferior de vddana_0p8
    parameter real VDDANA_0P8_MAX = 0.8 * 1.05; // Límite superior de vddana_0p8

    // Instancia del DUT (Device Under Test)
    currentSterring dut (
        .iref_500ua(iref_500ua),
        .pdb(pdb),
        .atb_ena(atb_ena),
        .vddana_1p8(vddana_1p8),
        .vddana_0p8(vddana_0p8),
        .vssana(vssana),
        .Vcas(Vcas),
        .datain(datain),
        .datainb(datainb),
        .datatherm(datatherm),
        .datathermb(datathermb),
        .dataical(dataical),
        .Iout_them_16(Iout_them[16]),
        .Iout_them_15(Iout_them[15]),
        .Iout_them_14(Iout_them[14]),
        .Iout_them_13(Iout_them[13]),
        .Iout_them_12(Iout_them[12]),
        .Iout_them_11(Iout_them[11]),
        .Iout_them_10(Iout_them[10]),
        .Iout_them_9(Iout_them[9]),
        .Iout_them_8(Iout_them[8]),
        .Iout_them_7(Iout_them[7]),
        .Iout_them_6(Iout_them[6]),
        .Iout_them_5(Iout_them[5]),
        .Iout_them_4(Iout_them[4]),
        .Iout_them_3(Iout_them[3]),
        .Iout_them_2(Iout_them[2]),
        .Iout_them_1(Iout_them[1]),
        .Iout_them_0(Iout_them[0]),
        .Iout_binary_5(Iout_binary[5]),
        .Iout_binary_4(Iout_binary[4]),
        .Iout_binary_3(Iout_binary[3]),
        .Iout_binary_2(Iout_binary[2]),
        .Iout_binary_1(Iout_binary[1]),
        .Iout_binary_0(Iout_binary[0]),
        .Iout_binary_0_red(Iout_binary_0_red),
        .Iout(Iout),
        .Ioutb(Ioutb),
        .Ical(Ical),
        .atb1(atb1),
        .atb0(atb0)
    );

    // Bloque inicial para realizar los tests
    initial begin
        $display("Iniciando tests...");

        // Configuración inicial
        vddana_1p8 = 1.8;
        vddana_0p8 = 0.8;
        vssana = 0.0;
        Vcas = 0.8;
        iref_500ua = 500e-6;
        atb_ena = 0;

        // Inicializar valores de Iout_binary y Iout_them
       
        Iout_binary_0_red = iref_500ua / (2.5 * 64); // Corriente redundante igual a iref_500ua / (2.5 * 64)
        Iout_binary[0] = iref_500ua / (2.5 * 64); // Corriente binaria 0 igual a iref_500ua / (2.5 * 64)
        Iout_binary[1] = iref_500ua / (2.5 * 32); // Corriente binaria 1 igual a iref_500ua / (2.5 * 32)
        Iout_binary[2] = iref_500ua / (2.5 * 16); // Corriente binaria 2 igual a iref_500ua / (2.5 * 16)
        Iout_binary[3] = iref_500ua / (2.5 * 8);  // Corriente binaria 3 igual a iref_500ua / (2.5 * 8)
        Iout_binary[4] = iref_500ua / (2.5 * 4);  // Corriente binaria 4 igual a iref_500ua / (2.5 * 4)
        Iout_binary[5] = iref_500ua / (2.5 * 2);  // Corriente binaria 5 igual a iref_500ua / (2.5 * 2)
        for (int i = 0; i < 17; i++) begin
            Iout_them[i] = iref_500ua / 2.5; // Corrientes termométricas iguales a iref_500ua / 2.5
        end

        // Test 1: Estado apagado (Power-Down)
        $display("Test 1: Estado apagado (Power-Down)");
        pdb = 0;
        datain = 7'b1010101;
        datainb = ~datain;
        datatherm = 17'b10101010101010101;
        datathermb = ~datatherm;
        #10;
        $display("Iout = %0.6f A, Ioutb = %0.6f A, Ical = %0.6f A, atb0 = %0.6f V, atb1 = %0.6f V", Iout, Ioutb, Ical, atb0, atb1);

        pdb = 1;
        datain = 7'b0000000;
        datainb = ~datain;
        datatherm = 17'b00000000000000000;
        datathermb = ~datatherm;

        // Test 2: Complementariedad (iout vs ioutb)
        $display("Test 2: Complementariedad (iout vs ioutb)");
        for (int i = 0; i < 128; i++) begin
            datain = i;
            datainb = ~i;
            #10;
            $display("datain = %b, Iout = %0.6f A, Ioutb = %0.6f A, Iout + Ioutb = %0.6f A", datain, Iout, Ioutb, Iout + Ioutb);
        end

        // Test 3: Modo térmico (thermometer code)
        $display("Test 3: Modo térmico (thermometer code)");
        for (int i = 0; i <= 17; i++) begin
            datatherm = (1 << i) - 1; // Patrón térmico
            datathermb = ~datatherm;
            #10;
            $display("datatherm = %b, Iout = %0.6f A", datatherm, Iout);
        end

        // Test 4: Calibrador (Ical y dataical)
        $display("Test 4: Calibrador (Ical y dataical)");
        for (int i = 0; i <= 23; i++) begin
            dataical = i;
            #10;
            $display("dataical = %b, Ical = %0.6f A", dataical, Ical);
        end
        dataical =0;

        // Test 5: Señales de test (atb_ena, atb0, atb1)
        $display("Test 5: Señales de test (atb_ena, atb0, atb1)");
        for (int i = 0; i < 4; i++) begin
            atb_ena = i;
            #10;
            $display("atb_ena = %b, atb0 = %0.6f V, atb1 = %0.6f V", atb_ena, atb0, atb1);
        end

        // Test 6: Condiciones de alimentación
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

        $display("Tests completados.");
        $finish;
    end

endmodule