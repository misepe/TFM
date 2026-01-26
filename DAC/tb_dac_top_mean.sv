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

    int run;
    string output_file_run;
    string output_config_file_run;
    string output_dir = "./output";

    int input_fd, output_fd, input_fd_config, output_fd_config;
    real t, t_prev, value_real;
    logic valor_normalizado;
    logic [0:9] digital_10b;
    
    int ret;

    real Vout_total;

    real Ts;
    longint delay_ps;


    always #5 clkin = ~clkin;
    always #5 clkinb = ~clkinb;

    initial begin

        //crear carpeta de output
        void'($system($sformatf("mkdir -p %s", output_dir)));
        
        clkin = 0;
        clkinb = 1;
        pdb = 1;
        vddana_1p8 = 1.8;
        vddana_0p8 = 0.8;
        vssana = 0.0;
        dataical = 0.0; 
        atb_ena = '0;

        //input_fd  = $fopen(input_file, "r");
        input_fd_config  = $fopen(input_config_file, "r");
        //output_fd = $fopen(output_file, "w");
        //output_fd_config  = $fopen(output_config_file, "w");

        if(!input_fd_config) begin
            $display("Error abriendo archivos");
            $finish;
        end

        // Leer y descartar la primera línea de encabezado
        //ret = $fscanf(input_fd_config,"%.15f %.15f %.15f \n",amplitud, duracion, fs);
        ret = $fscanf(input_fd_config,"%s\n",tipo_senal);
        ret = $fscanf(input_fd_config,"%.15f\n",duracion);
        ret = $fscanf(input_fd_config,"%.15f\n",fs);
        ret = $fscanf(input_fd_config,"%.15f %.15f\n",amplitud,freq);
       
        //$fwrite(output_fd,"%.15f %.15f %.15f \n",amplitud, duracion, fs);

        $fclose(input_fd_config);
        

        `ifndef gui_on
            delay_ps = 500;
             $display("GUI OFF: less delay_ps = %0d ps", delay_ps);
        `else
            Ts = 1.0/fs;                 // segundos
            delay_ps = longint'(Ts * 1e12); //ps porque `timescale es 1ps
            $display("GUI OON: delay_ps = %0d ps", delay_ps);
        `endif

        for(run=1; run<=32; run++) begin

            //Nombre de los archivos de output para cada run
            output_file_run = {output_dir, $sformatf("/output_run_%0d.txt", run)};
            output_config_file_run = {output_dir, $sformatf("/output_config_run_%0d.txt", run)};

            output_fd_config  = $fopen(output_config_file_run, "w");
            if(!output_fd_config) begin
                $display("Error abriendo archivos");
                $finish;
            end

            if(tipo_senal == "rampa_por_codigos") begin
                $fwrite(output_fd_config,"%s \n","output_rampa_por_codigos");
            end else begin
                $fwrite(output_fd_config,"%s \n","output_dac");
            end
            $fwrite(output_fd_config,"%.15f \n",duracion);
            $fwrite(output_fd_config,"%.15f \n",fs);
            $fwrite(output_fd_config,"%.15f %.15f \n",amplitud,freq);

            $fclose(output_fd_config);

            //Abrir de nuevo los input  y output files para cada run
            input_fd  = $fopen(input_file, "r");
            output_fd = $fopen(output_file_run, "w");
            if(!output_fd || !input_fd) begin
                $display("Error abriendo archivos");
                $finish;
            end

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
                end

            end while(ret != -1);

            $fclose(input_fd);
            $fclose(output_fd);
            $display("Run %0d completado", run);

        end //for run
        $display("Los %0d runs se han completado", run-1);
        $finish;
    end

endmodule