module tb;

  // --- Tu función ---
   function real generate_noise();
        // Variables
        int seed ;  // Semilla para el generador de números aleatorios
        int mean = 0;         // Promedio de la distribución
        int std_dev = 1000;     // Desviación estándar, sigma
        real random_value;      // Valor aleatorio generado
    
        real scalar =1e-12;  //Para ajustar el peso del ruido (1000*1e-12 = 1nA, el ruido tiene magnitud de nA)

        $display("Probando $dist_normal con mean = %0.2f y std_dev = %0.2f", mean, std_dev);

        // Genera valor aleatorio
        seed = $urandom();
        random_value = $dist_normal(seed, mean, std_dev) * scalar;
        $display("noise = %0d seed = %0d media =%0d sigma = %0d", random_value, seed, mean, std_dev);
        return random_value;
    endfunction

  // --- Parámetros del histograma ---
  localparam int N_SAMPLES = 10000;
  localparam int N_BINS    = 50;

  // Rango del histograma: +/- 5 sigma (en unidades físicas)
  // sigma_fis = std_dev * scalar = 1000 * 1e-12 = 1e-9
  real sigma_fis = 1e-9;
  real xmin = -5.0 * sigma_fis;
  real xmax =  5.0 * sigma_fis;
  real binw = (xmax - xmin) / N_BINS;

  int hist [0:N_BINS-1];

  // Para estadísticos
  real sum, sum2;

  integer i;
  integer f;
  real mean_est, var_est, std_est;

  initial begin
    // Inicializar
    for (int b=0; b<N_BINS; b++) hist[b] = 0;
    sum  = 0.0;
    sum2 = 0.0;

    // (Opcional) volcar muestras a fichero para plotear fuera
    f = $fopen("noise_samples.txt", "w");
    if (f == 0) begin
      $display("ERROR: no puedo abrir noise_samples.txt");
      $finish;
    end

    // Generar muestras
    for (i=0; i<N_SAMPLES; i++) begin
      real x;
      int bin;

      x = generate_noise();

      sum  += x;
      sum2 += x*x;

      // Guardar muestra
      $fwrite(f, "%0d %e\n", i, x);

      // Bin index
      bin = int'((x - xmin) / binw);

      // Saturar a rango (por si cae fuera de +/-5sigma)
      if (bin < 0) bin = 0;
      if (bin >= N_BINS) bin = N_BINS-1;

      hist[bin]++;
    end

    $fclose(f);

    // Estadísticos
    
    mean_est = sum / N_SAMPLES;
    var_est  = (sum2 / N_SAMPLES) - mean_est*mean_est;
    if (var_est < 0.0) var_est = 0.0;
    std_est  = $sqrt(var_est);

    $display("Resultados (N=%0d):", N_SAMPLES);
    $display("  mean_est = %e", mean_est);
    $display("  std_est  = %e", std_est);

    // Imprimir histograma (centro del bin y conteo)
    $display("Histograma (%0d bins) en rango [%e, %e]:", N_BINS, xmin, xmax);
    for (int b=0; b<N_BINS; b++) begin
      real center;
      center = xmin + (b + 0.5)*binw;
      $display("  bin %0d center=%e count=%0d", b, center, hist[b]);
    end

    $finish;
  end

endmodule
