`timescale 1ps/1ps

module resistor_load_tb;

    real Iin;       // Corriente de entrada
    real Iinb;      // Corriente de entrada inversa
    real vssana;    // Conexión a tierra

    real vout;      // Voltaje de salida
    real voutb;     // Voltaje de salida inverso

    // Instancia del DUT (Device Under Test)
    resistor_load dut (
        .Iin(Iin),
        .Iinb(Iinb),
        .vssana(vssana),
        .vout(vout),
        .voutb(voutb)
    );

    // Parámetros de los límites
    parameter real IIN_MIN = -1e-3; // Límite inferior de Iin (-1 mA)
    parameter real IIN_MAX = 1e-3;  // Límite superior de Iin (1 mA)
    parameter real VSSANA_MIN = -0.05; // Límite inferior de vssana (-0.05 V)
    parameter real VSSANA_MAX = 0.05;  // Límite superior de vssana (0.05 V)

    // Bloque inicial para realizar el barrido
    initial begin
        $display("Iniciando barrido de señales...");

        // Barrido de Iin
        $display("Barrido de Iin e Iinb:");
        for (Iin = IIN_MIN; Iin <= IIN_MAX; Iin = Iin + 0.1e-3) begin
            for (Iinb = IIN_MIN; Iinb <= IIN_MAX; Iinb = Iinb + 0.1e-3) begin
                #10; // Esperar 10 unidades de tiempo
                $display("Iin = %0.6f A, Iinb = %0.6f A, vout = %0.6f V, voutb = %0.6f V", Iin, Iinb, vout, voutb);
            end
        end

        // Barrido de vssana
        $display("Barrido de vssana:");
        for (vssana = VSSANA_MIN; vssana <= VSSANA_MAX; vssana = vssana + 0.01) begin
            #10; // Esperar 10 unidades de tiempo
            $display("vssana = %0.2f V, vout = %0.6f V, voutb = %0.6f V", vssana, vout, voutb);
        end

        $display("Barrido completado.");
        $finish; // Finalizar la simulación
    end

endmodule