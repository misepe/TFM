#Se genera la señal de entrada
#python3 rampa_generator.py
python3 sin_generator.py

#Se codifican los datos de entrada
xrun thermometer_decoder.sv

#Simulación del DAC
xrun -f xrun_tb_dac.f

#Post-procesado: FFT y gráficas
python3 fft_generator.py
