`timescale 1ns/1ps

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
    real amplitud, duracion, fs; //read form the txt file
    //real fs=4.6e6;//info from input generator
    //real duracion=0.0001;//info from input generator

    int delay = 0;


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
    string output_file = "./output.txt";

    int input_fd, output_fd, input_fd_config;
    real t, t_prev, value_real;
    logic valor_normalizado, digital_10b;
    
    int ret;


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

        if(!input_fd || !output_fd) begin
            $display("Error abriendo archivos");
            $finish;
        end

        // Leer y descartar la primera línea de encabezado
        //ret = $fscanf(input_fd_config,"%.15f %.15f %.15f \n",amplitud, duracion, fs);
        ret = $fscanf(input_fd_config,"%.15f\n",duracion);
        ret = $fscanf(input_fd_config,"%.15f\n",fs);
        ret = $fscanf(input_fd_config,"%.15f\n",amplitud);
        //$fwrite(output_fd,"%.15f %.15f %.15f \n",amplitud, duracion, fs);
        do begin
            ret = $fscanf(input_fd,"%.15f %.15f %.15f %b %b %b %b %b\n",t, value_real, valor_normalizado, digital_10b, datainbin, datainbinb, dataintherm, datainthermb);
            //$display("t=%f, value_real=%.15f, valor_normalizado=%.15f, digital_10b=%b", t, value_real, valor_normalizado, digital_10b);
            //$display("ret =%0d", ret);
            
            
            if(ret==8) begin
                // Introducir un delay basado en la diferencia de tiempo
                delay = int'(fs*duracion);
                #(delay);
                
                $fwrite(output_fd,"%.15f %.15f\n",t,Vout);
            end

        end while(ret != -1);

        $fclose(input_fd);
        $fclose(output_fd);
        $display("Señal generada");
        $finish;
    end

endmodule