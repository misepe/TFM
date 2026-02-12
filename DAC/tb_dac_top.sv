`timescale 1ps/1ps

module tb_dac_top ();

    //Inputs
    real  dataical, vddana_0p8, vddana_1p8, vssana;

    reg  clkin, clkinb, pdb; 
    
    reg [0:9]  atb_ena;

    //Outputs
    real  Ical, Vout, Voutb;

    reg [0:6]  datainbinb;
    reg [0:16]  datainthermb;
    reg [0:16]  dataintherm;
    reg [0:6]  datainbin;
    real atb [10];

    //Auxiliary variables
    real amplitud, duracion, fs, freq; //read form the txt file
    //real fs=4.6e6;//info from input generator
    //real duracion=0.0001;//info from input generator

    int delay = 0;
    string tipo_senal;


    top_level_schematic DUT (
        .Ical(Ical),
        .Vout(Vout),
        .Voutb(Voutb),
        .atb(atb),
        .atb_ena(atb_ena),
        .clkin(clkin),
        .clkinb(clkinb),
        .dataical(dataical),
        .datainbin(datainbin),
        .datainbinb(datainbinb),
        .dataintherm(dataintherm),
        .datainthermb(datainthermb),
        .pdb(pdb),
        .vddana_0p8(vddana_0p8),
        .vddana_1p8(vddana_1p8),
        .vssana(vssana)
    );


    string input_file = "./stimulus_input.txt";
    string input_config_file = "./stimulus_input_config.txt";
    string output_config_file = "./output_config.txt";
    string output_file = "./output.txt";
    string debug_file = "./debug.txt";

    int input_fd, output_fd, input_fd_config, output_fd_config,debug_fd;
    real t, t_prev, value_real;
    logic valor_normalizado;
    logic [0:9] digital_10b;
    
    int ret;

    real Vout_total;

    real Ts;
    longint delay_ps;

    //5GHz de reloj (perido de 200ps y medio ciclo de 100ps)
    //always #100 clkin = ~clkin;
    //always #100 clkinb = ~clkinb;
    //10GHz de reloj (perido de 100ps y medio ciclo de 50ps)
    //always #50 clkin = ~clkin;
    //always #50 clkinb = ~clkinb;
    //100GHz de reloj (perido de 10ps y medio ciclo de 5ps)
    always #5 clkin = ~clkin;
    always #5 clkinb = ~clkinb;

    initial begin
        
        clkin = 0;
        clkinb = 1;
        pdb = 1;
        vddana_1p8 = 1.8;
        vddana_0p8 = 0.8;
        vssana = 0.0;
        dataical = 0.0; 
        atb_ena = '0;

        input_fd  = $fopen(input_file, "r");
        input_fd_config  = $fopen(input_config_file, "r");
        output_fd = $fopen(output_file, "w");
        output_fd_config  = $fopen(output_config_file, "w");
        debug_fd = $fopen(debug_file, "w");

        if(!input_fd || !output_fd || !input_fd_config || !output_fd_config || !debug_fd) begin
            $display("Error abriendo archivos");
            $finish;
        end

        // Leer y descartar la primera línea de encabezado
        //ret = $fscanf(input_fd_config,"%.15f %.15f %.15f \n",amplitud, duracion, fs);
        ret = $fscanf(input_fd_config,"%s\n",tipo_senal);
        ret = $fscanf(input_fd_config,"%.15f\n",duracion);
        ret = $fscanf(input_fd_config,"%.15f\n",fs);
        ret = $fscanf(input_fd_config,"%.15f %.15f\n",amplitud,freq);
        if(tipo_senal == "rampa_por_codigos") begin
            $fwrite(output_fd_config,"%s \n","output_rampa_por_codigos");
        end else begin
            $fwrite(output_fd_config,"%s \n","output_dac");
        end
        $fwrite(output_fd_config,"%.15f \n",duracion);
        $fwrite(output_fd_config,"%.15f \n",fs);
        $fwrite(output_fd_config,"%.15f %.15f \n",amplitud,freq);
        //$fwrite(output_fd,"%.15f %.15f %.15f \n",amplitud, duracion, fs);

        `ifndef gui_on
            delay_ps = 500;
             $display("GUI OFF: less delay_ps = %0d ps", delay_ps);
        `else
            Ts = 1.0/fs;                 // segundos
            delay_ps = longint'(Ts * 1e12); //ps porque `timescale es 1ps
            $display("GUI OON: delay_ps = %0d ps", delay_ps);
        `endif

        do begin
            ret = $fscanf(input_fd,"%.15f %.15f %.15f %b %b %b %b %b\n",t, value_real, valor_normalizado, digital_10b, datainbin, datainbinb, dataintherm, datainthermb);
            //$display("t=%f, value_real=%.15f, valor_normalizado=%.15f, digital_10b=%b", t, value_real, valor_normalizado, digital_10b);
            //$display("ret =%0d", ret);
            
            
            if(ret==8) begin
                // Introducir un delay basado en la diferencia de tiempo
                //delay = int'(fs*duracion);
                #(delay_ps);
                Vout_total = Vout - Voutb;
                $fwrite(output_fd,"%.15f %.15f %.15f %.15f %b\n",t,Vout_total,Vout, Voutb,digital_10b);
                $fwrite(debug_fd,"%.15f %.15f %.15f %.15f\n",delay_ps, t,DUT.CurrentSourceUnits_inst.Iout_binary_0,DUT.currentSterring_inst.Iout_binary_0);
            end

        end while(ret != -1);

        $fclose(input_fd);
        $fclose(output_fd);
        $fclose(input_fd_config);
        $fclose(output_fd_config);
        $fclose(debug_fd);
        $display("Señal generada");
        $finish;
    end

endmodule