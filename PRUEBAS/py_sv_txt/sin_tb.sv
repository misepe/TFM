module sin_tb;

    // Parámetros
    string input_file = "./sin_input.txt";  // Archivo de entrada
    string output_file = "./sin_output.txt"; // Archivo de salida
    int input_fd, output_fd;  // Descriptores de archivo
    real time_val, signal_val;  // Variables para leer tiempo y señal
    real modified_signal;  // Señal modificada
    real scale_factor = 2.0;  // Factor de escala para modificar la señal

    int ret;

    initial begin
        // Abrir el archivo de entrada
        input_fd = $fopen(input_file, "r");
        if (input_fd == 0) begin
            $display("Error: No se pudo abrir el archivo de entrada '%s'. Verifica que el archivo exista y tenga permisos de lectura.", input_file);
            $finish;
        end else begin
            $display("Archivo de entrada '%s' abierto correctamente. Descriptor: %0d", input_file, input_fd);
        end

        // Abrir el archivo de salida
        output_fd = $fopen(output_file, "w");
        if (output_fd == 0) begin
            $display("Error: No se pudo abrir el archivo de salida '%s'. Verifica que el archivo tenga permisos de escritura.", output_file);
            $finish;
        end else begin
            $display("Archivo de salida '%s' abierto correctamente.", output_file);
        end

        $display("Leyendo datos de '%s' y escribiendo resultados en '%s'...", input_file, output_file);

        // Leer el archivo línea por línea
        
        do begin
            // Leer tiempo y valor de la señal
            ret = $fscanf(input_fd, "%f\t%f\n", time_val, signal_val);

            // Depuración: Mostrar el valor de `ret` y las variables leídas
            $display("DEBUG: Valor de ret = %0d, time_val = %f, signal_val = %f", ret, time_val, signal_val);

            if (ret == 2) begin
                // Modificar la señal (por ejemplo, escalarla)
                modified_signal = signal_val * scale_factor;

                // Escribir el tiempo y la señal modificada en el archivo de salida
                $fwrite(output_fd, "%f\t%f\n", time_val, modified_signal);
            end else if (ret != -1) begin
                $display("Advertencia: Línea malformada en el archivo de entrada.");
            end
        end while (ret != -1);  // Continuar mientras no se alcance el final del archivo

        // Cerrar los archivos
        $fclose(input_fd);
        $fclose(output_fd);

        $display("Procesamiento completado. Archivo de salida generado: '%s'", output_file);
        $finish;
    end

    /*initial begin
        
        int fd;

        fd = $fopen("./sin_input.txt", "r");
        if(fd)  $display("File was opened successfully: %0d", fd);
        else    $display("Error opening file: %0d", fd);

        $fclose(fd);

    end*/

endmodule