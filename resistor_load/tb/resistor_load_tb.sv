`timescale 1ps/1ps

module resistor_load_tb;

    real Iin;       // Corriente de entrada a rama Vout
    real Iinb;      // Corriente de entrada a rama Voutb
    real vssana;    // Referencia de masa

    real vout;      // Voltaje de salida
    real voutb;     // Voltaje de salida complementaria

    real v_sumada;
    real v_diff;
    real i_sumada;

    // Instancia del DUT
    resistor_load dut (
        .Iin(Iin),
        .Iinb(Iinb),
        .vssana(vssana),
        .vout(vout),
        .voutb(voutb)
    );

    // Parámetros
    parameter real IREF = 0.0005; // Corriente de referencia (A)
    parameter real IFS = 0.003196875;  // Corriente full-scale (A)
    parameter real VSSANA_MIN = -0.05;
    parameter real VSSANA_MAX =  0.05;

    // Paso de barrido (ajústalo si quieres más resolución)
    parameter real DI = IREF/(2.5*64.0);      // parecido a la corriente Iout_binary_0

    

    initial begin
        $display("=== Testbench resistor_load: modo diferencial steering ===");
        $display("IFS = %0.9f A, DI = %0.9f A", IFS, DI);

        // Inicialización
        vssana = 0.0;
        Iin    = 0.0;
        Iinb   = IFS;
        #10;

        // ------------------------------------------------------------
        // TEST 1: Barrido steering diferencial (Iin + Iinb = IFS)
        // ------------------------------------------------------------
        $display("\nTEST 1: Barrido steering (Iin + Iinb = IFS)");
        for (Iin = 0.0; Iin <= IFS + DI + 1e-18; Iin = Iin + DI) begin
            Iinb = IFS - Iin;
            i_sumada = Iin + Iinb;
            v_diff = vout - voutb;
            v_sumada = vout + voutb;
            #10;
            $display("Iin=%0.9f A, Iinb=%0.9f A, vout=%0.6f V, voutb=%0.6f V, vdiff=%0.6f V, Vsumado=%0.6f V",
                     Iin, Iinb, vout, voutb, v_diff, v_sumada);
        end

        /*for (int k = 0; k <= 1023; k++) begin
            Iin  <= k * DI;
            Iinb <= IFS - (k * DI);
            i_sumada <= Iin + Iinb;
            v_diff <= vout - voutb;
            v_sumada <= vout + voutb;
            #10;
            $display("Iin=%0.9f A, Iinb=%0.9f A, vout=%0.9f V, voutb=%0.9f V, vdiff=%0.6f V, Vsumado = %0.9f V",
                     Iin, Iinb, vout, voutb, v_diff, v_sumada);
        end*/


        /*// ------------------------------------------------------------
        // TEST 2: Barrido de vssana manteniendo steering a mitad
        // ------------------------------------------------------------
        $display("\nTEST 2: Barrido vssana con steering a mitad de escala");
        Iin  = IFS/2.0;
        Iinb = IFS/2.0;
        for (vssana = VSSANA_MIN; vssana <= VSSANA_MAX + 1e-18; vssana = vssana + 0.01) begin
            #10;
            $display("vssana=%0.3f V, vout=%0.6f V, voutb=%0.6f V, vdiff=%0.6f V",
                     vssana, vout, voutb, (vout - voutb));
        end

        // ------------------------------------------------------------
        // TEST 3: Extremos de steering (sanity check)
        // ------------------------------------------------------------
        $display("\nTEST 3: Extremos (sanity check)");
        vssana = 0.0;

        Iin = 0.0; Iinb = IFS; #10;
        $display("EXTREMO A: Iin=0, Iinb=IFS -> vout=%0.6f, voutb=%0.6f, vdiff=%0.6f",
                 vout, voutb, (vout - voutb));

        Iin = IFS; Iinb = 0.0; #10;
        $display("EXTREMO B: Iin=IFS, Iinb=0 -> vout=%0.6f, voutb=%0.6f, vdiff=%0.6f",
                 vout, voutb, (vout - voutb));*/

        $display("\n=== Fin de simulación ===");
        $finish;
    end

endmodule
