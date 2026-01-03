`timescale 1ns/1ps

module driver_cell_tb;

    // Señales de entrada
    reg [6:0] datain;      // Control binario
    reg [6:0] datainb;     // Control binario negado
    reg [16:0] datatherm;  // Control termométrico
    reg [16:0] datathermb; // Control termométrico negado
    reg pdb;               // Señal de power down
    real vddana_1p8;       // Fuente de alimentación de 1.8V
    real vddana_0p8;       // Fuente de alimentación de 0.8V
    real vssana;           // Conexión a tierra

    // Señales de salida
    real  databinout [6:0];     // Salida binaria
    real  databinoutb [6:0];    // Salida binaria negada
    real  datathermout [16:0];  // Salida termométrica
    real  datathermoutb [16:0]; // Salida termométrica negada

    // Instancia del DUT
    driver_cell dut (
        .datain(datain),
        .datainb(datainb),
        .datatherm(datatherm),
        .datathermb(datathermb),
        .pdb(pdb),
        .vddana_1p8(vddana_1p8),
        .vddana_0p8(vddana_0p8),
        .vssana(vssana),
        .databinout(databinout),
        .databinoutb(databinoutb),
        .datathermout(datathermout),
        .datathermoutb(datathermoutb)
    );

    // Bloque inicial para ejecutar los tests
    initial begin
        $display("Iniciando tests...");

        // Test 1: Verificación de límites de alimentación
        $display("Test 1: Verificación de límites de alimentación");
        vddana_1p8 = 1.8; vddana_0p8 = 0.8; vssana = 0.0; // Dentro de los límites
        #10;
        //vddana_1p8 = 1.9;  // Fuera de los límites
        #10;
        //vddana_0p8 = 0.7;vddana_1p8 = 1.8; // Fuera de los límites
        #10;
        //vssana = -0.1; vddana_0p8 = 0.8; // Fuera de los límites
        #10;

        // Test 2: Estado apagado (pdb = 0)
        $display("Test 2: Estado apagado (pdb = 0)");
        pdb = 0;
        datain = 8'b10101010; datainb = ~datain;
        datatherm = 17'b10101010101010101; datathermb = ~datatherm;
        vddana_1p8 = 1.8; vddana_0p8 = 0.8; vssana = 0.0; // Alimentación válida
        #10;
        $display("Valores de databinout:");
        for (int i = 0; i < 7; i++) begin
            $display("databinout[%0d] = %.4f, databinoutb[%0d] = %.4f", i, databinout[i], i, databinoutb[i]);
        end

        $display("Valores de datathermout:");
        for (int i = 0; i < 18; i++) begin
            $display("datathermout[%0d] = %.4f, datathermoutb[%0d] = %.4f", i, datathermout[i], i, datathermoutb[i]);
        end


        // Test 3: Estado encendido (pdb = 1)
        $display("Test 3: Estado encendido (pdb = 1)");
        pdb = 1;
        datain = 8'b11001100; datainb = ~datain;
        datatherm = 17'b11110000111100001; datathermb = ~datatherm;
        #10;
        $display("Valores de databinout:");
        for (int i = 0; i < 7; i++) begin
            $display("databinout[%0d] = %.4f, databinoutb[%0d] = %.4f", i, databinout[i], i, databinoutb[i]);
        end

        $display("Valores de datathermout:");
        for (int i = 0; i < 18; i++) begin
            $display("datathermout[%0d] = %.4f, datathermoutb[%0d] = %.4f", i, datathermout[i], i, datathermoutb[i]);
        end

        // Test 4: Propagación de datos binarios
        $display("Test 5: Propagación de datos binarios");
        datain = 8'b10101010; datainb = ~datain;
        #10;
        $display("Valores de databinout:");
        for (int i = 0; i < 7; i++) begin
            $display("databinout[%0d] = %.4f, databinoutb[%0d] = %.4f", i, databinout[i], i, databinoutb[i]);
        end

        // Test 5: Propagación de datos termométricos
        $display("Test 6: Propagación de datos termométricos");
        datatherm = 17'b10101010101010101; datathermb = ~datatherm;
        #10;
        $display("Valores de datathermout:");
        for (int i = 0; i < 18; i++) begin
            $display("datathermout[%0d] = %.4f, datathermoutb[%0d] = %.4f", i, datathermout[i], i, datathermoutb[i]);
        end


        $display("Tests completados.");
        $finish;
    end

endmodule