module stimulus_processor;

  // Parámetros ajustados a tus requerimientos
  parameter int N_BITS     = 10;   // resolución entrada
  parameter int MSB_BITS   = 4;    // MSB en binario antes de thermometer
  parameter int THERM_BITS = 17;   // tamaño del bus termométrico final
  parameter int LSB_BITS   = 6;    // LSB binarios reales
  
  real VREF      = 1.0;

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

    r = $fscanf(fin_config,"%.15f\n",duracion);
    $fwrite(fout_config, "%.15f \n",duracion);
    r = $fscanf(fin_config,"%.15f\n",fs);
    $fwrite(fout_config, "%.15f \n",fs);
    /*try begin
      while(!$feof(fin_config)) begin
        r = $fscanf(fin_config,"%.15f %.15f\n",VREF,freq);
        $fwrite(fout_config, "%.15f %.15f \n",VREF,freq);
      end
    end
    catch begin*/
      r = $fscanf(fin_config,"%.15f\n",VREF);
      $fwrite(fout_config, "%.15f \n",VREF);
    //end


    while(!$feof(fin)) begin

      r = $fscanf(fin,"%.15f %.15f\n",t_sample,value_real);

      // cuantización a 10 bits
      //digital_10b = $rtoi((((value_real/ VREF) * ((1<<N_BITS)-1))));
      digital_10b = $rtoi(((((value_real+VREF)/ (2*VREF)) * ((1<<N_BITS)-1))));
      
      // separación MSB/LSB
      msb_bin = digital_10b[N_BITS-1 -: MSB_BITS];
      lsb_bin = digital_10b[LSB_BITS-1:0];

      // Construimos bus binario de 7 bits (1 redundante = 0)
      Datainbin = {lsb_bin,lsb_bin[0]};//]1'bx};       // [0]=extra , [6:1]=LSB
      Datainbinb = ~Datainbin;

      // Termómetro 17 bits
      Dataintherm  = to_therm(msb_bin);
      Datainthermb = ~Dataintherm;

      // Guardado en archivo
      //$fwrite(fout, "%.15f %.15f %.15f %b %b %b %b %b\n",t_sample, value_real, ((value_real)/ (VREF)), digital_10b, Datainbin, Datainbinb, Dataintherm, Datainthermb);
      $fwrite(fout, "%.15f %.15f %.15f %b %b %b %b %b\n",t_sample, value_real, ((value_real+VREF)/ (2*VREF)), digital_10b, Datainbin, Datainbinb, Dataintherm, Datainthermb);
      

    end

    $fclose(fin);
    $fclose(fout);
    $display("Archivo generado -> %s",file_out);
    $finish;
  end
endmodule
