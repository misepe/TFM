module stimulus_processor;

  // Parámetros ajustados a tus requerimientos
  parameter int N_BITS     = 10;   // resolución entrada
  parameter int MSB_BITS   = 4;    // MSB en binario antes de thermometer
  parameter int THERM_BITS = 17;   // tamaño del bus termométrico final
  parameter int LSB_BITS   = 6;    // LSB binarios reales
  parameter real VREF      = 1.0;

  string file_in  = "sin_input.txt";
  string file_out = "stimulus_input.txt";
  integer fin, fout, r;

  real t_sample, value_real;
  logic [N_BITS-1:0] digital_10b;
  logic [MSB_BITS-1:0] msb_bin;
  logic [LSB_BITS-1:0] lsb_bin;
  logic [6:0] Datainbin, Datainbinb;
  logic [THERM_BITS-1:0] Dataintherm, Datainthermb;

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

    fout = $fopen(file_out,"w");
    if(fout==0) begin $display("ERROR: no se pudo crear output"); $finish; end

    $fwrite(fout,"# Datainbin   Datainbinb   Dataintherm   Datainthermb\n");

    while(!$feof(fin)) begin

      r = $fscanf(fin,"%f %f\n",t_sample,value_real);

      // cuantización a 10 bits
      digital_10b = int'((value_real/VREF) * ((1<<N_BITS)-1));

      // separación MSB/LSB
      msb_bin = digital_10b[N_BITS-1 -: MSB_BITS];
      lsb_bin = digital_10b[LSB_BITS-1:0];

      // Construimos bus binario de 7 bits (1 redundante = 0)
      Datainbin = {1'bx, lsb_bin};       // [6]=extra , [5:0]=LSB
      Datainbinb = ~Datainbin;

      // Termómetro 17 bits
      Dataintherm  = to_therm(msb_bin);
      Datainthermb = ~Dataintherm;

      // Guardado en archivo
      $fwrite(fout, "%b %b %b %b\n", Datainbin, Datainbinb, Dataintherm, Datainthermb);

    end

    $fclose(fin);
    $fclose(fout);
    $display("Archivo generado -> %s",file_out);
    $finish;
  end
endmodule
