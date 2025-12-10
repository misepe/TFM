module sin_tb;

    string input_file = "./sin_input.txt";
    string output_file = "./sin_output.txt";

    int input_fd, output_fd;
    real t, x;
    real y;

    // Pequeño offset global en rango ±0.5%
    real offset;
    real offset_range = 0.005; // ±0.5%

    // Nivel de ruido relativo (recomendado 0.005 a 0.02)
    real noise_amp = 0.005; // 0.5% de ruido aprox

    int ret;

    // Generador de ruido uniforme -1 a +1
    function real rnd();
        rnd = ( ($urandom % 20001) / 10000.0 ) - 1.0;
    endfunction

    initial begin
        
        input_fd  = $fopen(input_file, "r");
        output_fd = $fopen(output_file, "w");

        if(!input_fd || !output_fd) begin
            $display("Error abriendo archivos");
            $finish;
        end

        // Offset fijo para toda la señal (simula error del DAC)
        offset = offset_range * rnd();

        $display("Offset aplicado: %f", offset);
        $display("Ruido relativo:  %f", noise_amp);

        do begin
            ret = $fscanf(input_fd,"%.10f %.10f\n",t,x);

            if(ret==2) begin
                // Señal original + offset fijo + ruido pequeño
                y = x + offset + noise_amp * rnd();

                $fwrite(output_fd,"%.10f %.10f\n",t,y);
            end

        end while(ret != -1);

        $fclose(input_fd);
        $fclose(output_fd);
        $display("Señal generada con offset y ruido moderado");
        $finish;
    end
endmodule
