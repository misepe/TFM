module stimulus_processor;

  // Parámetros ajustados a tus requerimientos
  parameter int N_BITS     = 10;   // resolución entrada
  parameter int MSB_BITS   = 4;    // MSB en binario antes de thermometer
  parameter int THERM_BITS = 17;   // tamaño del bus termométrico final
  parameter int LSB_BITS   = 6;    // LSB binarios reales
  
  real VREF = 1.0;
  real amp_in;
  real VFS = 2.0; // Voltaje full scale (pico a pico)

  string file_in  = "input.txt";
  string file_in_config  = "input_config.txt";
  string file_out = "stimulus_input.txt";
  string file_out_config = "stimulus_input_config.txt";
  integer fin, fin_config, fout, fout_config, r;

  real t_sample, value_real;
  logic [N_BITS-1:0] digital_10b;
  logic [MSB_BITS-1:0] msb_bin;
  logic [LSB_BITS-1:0] lsb_bin;
  logic [6:0] Datainbin, Datainbinb;
  logic [THERM_BITS-1:0] Dataintherm, Datainthermb;

  real duracion, fs, freq;

  string tipo_senal;

  // Conversión a termómetro 17b
  function logic [THERM_BITS-1:0] to_therm(input logic [MSB_BITS-1:0] code);
    logic [THERM_BITS-1:0] t;
    for (int i=0; i<THERM_BITS; i++)
      t[i] = (i < code) ? 1'b1 : 1'b0;
    return t;
  endfunction

  initial begin
    fin = $fopen(file_in,"r");
    if(fin==0) begin $display("ERROR: no se pudo abrir input"); $finish; end
    fin_config = $fopen(file_in_config,"r");
    if(fin_config==0) begin $display("ERROR: no se pudo abrir input_config"); $finish; end

    fout = $fopen(file_out,"w");
    if(fout==0) begin $display("ERROR: no se pudo crear output"); $finish; end
    fout_config = $fopen(file_out_config,"w");
    if(fout_config==0) begin $display("ERROR: no se pudo crear output_config"); $finish; end

    //$fwrite(fout,"# tiempo value_real valor_ normalizado digital_10b Datainbin   Datainbinb   Dataintherm   Datainthermb\n");

    r = $fscanf(fin_config,"%s\n",tipo_senal);
    $fwrite(fout_config, "%s \n",tipo_senal);
    r = $fscanf(fin_config,"%.15f\n",duracion);
    $fwrite(fout_config, "%.15f \n",duracion);
    r = $fscanf(fin_config,"%.15f\n",fs);
    $fwrite(fout_config, "%.15f \n",fs);
    while(!$feof(fin_config)) begin
      r = $fscanf(fin_config,"%.15f %.15f\n",amp_in,freq);
      $fwrite(fout_config, "%.15f %.15f \n",amp_in,freq);
    end
    //end


    while(!$feof(fin)) begin

      r = $fscanf(fin,"%.15f %.15f\n",t_sample,value_real);

      // cuantización a 10 bits
      if(tipo_senal == "sinusoidal") begin
        VFS = 2.0*amp_in; // si A es amplitud pico a pico
        digital_10b = int'(((((value_real+amp_in)/ (VFS)) * ((1<<N_BITS)-1)))); //Subir la señal para que no hayan valores negativos
        //digital_10b = $rtoi(((((value_real+amp_in)/ (VFS)) * ((1<<N_BITS)-1)))); //Subir la señal para que no hayan valores negativos
        //digital_10b = $rtoi(((((value_real+VREF)/ (2*VREF)) * ((1<<N_BITS)-1)))); //Subir la señal para que no hayan valores negativos
      end else if (tipo_senal == "rampa_por_codigos") begin
        digital_10b = int'(value_real); // en rampa por códigos el valor ya está entre 0 y 1023
        //digital_10b = $rtoi((value_real)); // en rampa por códigos el valor ya está entre 0 y 1023
      end else begin
        VREF = amp_in;
        digital_10b = int'((((value_real/ VREF) * ((1<<N_BITS)-1)))); // si son rampa u otra señal sin negativos no hace falta subirla
        //digital_10b = $rtoi((((value_real/ VREF) * ((1<<N_BITS)-1)))); // si son rampa u otra señal sin negativos no hace falta subirla
      end

      if (digital_10b < 0) digital_10b = 0;
      if (digital_10b > ((1<<N_BITS)-1)) digital_10b = (1<<N_BITS)-1;

      
      // separación MSB/LSB
      msb_bin = digital_10b[N_BITS-1 -: MSB_BITS];
      lsb_bin = digital_10b[LSB_BITS-1:0];

      // Construimos bus binario de 7 bits (1 redundante = 0)
      Datainbin = {1'b0,lsb_bin};//lsb_bin[0]};       // [6]=extra , [5:0]=LSB
      Datainbinb = ~Datainbin;

      // Termómetro 17 bits
      Dataintherm  = to_therm(msb_bin);
      Dataintherm[16:15] = 2'b00; 
      Datainthermb = ~Dataintherm;

      // Guardado en archivo
      if(tipo_senal == "sinusoidal") begin
          $fwrite(fout, "%.15f %.15f %.15f %b %b %b %b %b\n",t_sample, value_real,(value_real + amp_in) / (2.0*amp_in), digital_10b, Datainbin, Datainbinb, Dataintherm, Datainthermb);
      end else if (tipo_senal == "rampa_por_codigos") begin
        $fwrite(fout, "%.15f %.15f %.15f %b %b %b %b %b\n",t_sample, value_real, value_real, digital_10b, Datainbin, Datainbinb, Dataintherm, Datainthermb);
      end else begin
          $fwrite(fout, "%.15f %.15f %.15f %b %b %b %b %b\n",t_sample, value_real, ((value_real)/ (VREF)), digital_10b, Datainbin, Datainbinb, Dataintherm, Datainthermb);
      end
      
      

    end

    $fclose(fin);
    $fclose(fout);
    $display("Archivo generado -> %s",file_out);
    $finish;
  end
endmodule
