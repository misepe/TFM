`timescale 1ps/1ps

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
    wire [6:0] databinout;     // Salida binaria
    wire [6:0] databinoutb;    // Salida binaria negada
    wire [16:0] datathermout;  // Salida termométrica
    wire [16:0] datathermoutb; // Salida termométrica negada

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
        #200;
        vddana_1p8 = 1.9;  // Fuera de los límites
        #200;
        vddana_0p8 = 0.7;vddana_1p8 = 1.8; // Fuera de los límites
        #200;
        vssana = -0.1; vddana_0p8 = 0.8; // Fuera de los límites
        #200;
        vddana_1p8 = 1.8; vddana_0p8 = 0.8; vssana = 0.0; // Restaurar valores válidos

        // Test 2: Estado apagado (pdb = 0)
        $display("Test 2: Estado apagado (pdb = 0)");
        pdb = 0;
        datain = 8'b10101010; datainb = ~datain;
        datatherm = 17'b10101010101010101; datathermb = ~datatherm;
        vddana_1p8 = 1.8; vddana_0p8 = 0.8; vssana = 0.0; // Alimentación válida
        #200;
        $display("databinout = %b, databinoutb = %b, datathermout = %b, datathermoutb = %b",
                 databinout, databinoutb, datathermout, datathermoutb);

        // Test 3: Estado encendido (pdb = 1)
        $display("Test 3: Estado encendido (pdb = 1)");
        pdb = 1;
        datain = 8'b11001100; datainb = ~datain;
        datatherm = 17'b11110000111100001; datathermb = ~datatherm;
        #200;
        $display("databinout = %b, databinoutb = %b, datathermout = %b, datathermoutb = %b",
                 databinout, databinoutb, datathermout, datathermoutb);
        datain = 8'b10101010; datainb = ~datain;
        datatherm = 17'b10101010101010101; datathermb = ~datatherm;
        #200;
        $display("databinout = %b, databinoutb = %b, datathermout = %b, datathermoutb = %b",
                 databinout, databinoutb, datathermout, datathermoutb);

        // Test 4: Propagación de datos binarios
        //$display("Test 4: Propagación de datos binarios");
        //datain = 8'b10101010; datainb = ~datain;
        //#200;
        //$display("databinout = %b, databinoutb = %b", databinout, databinoutb);

        // Test 5: Propagación de datos termométricos
        //$display("Test 5: Propagación de datos termométricos");
        //datatherm = 17'b10101010101010101; datathermb = ~datatherm;
        //#200;
        //$display("datathermout = %b, datathermoutb = %b", datathermout, datathermoutb);


        $display("Tests completados.");
        $finish;
    end

endmodule