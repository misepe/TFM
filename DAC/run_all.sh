# Preguntar al usuario qué tipo de señal generar
echo "Seleccione el tipo de señal a generar:"
echo "1: Señal tipo rampa"
echo "2: Señal tipo seno"
read -p "Ingrese su elección (1 o 2): " choice

if [ "$choice" -eq 1 ]; then
    echo "Generando señal tipo rampa..."
    python3 rampa_generator.py
elif [ "$choice" -eq 2 ]; then
    echo "Generando señal tipo seno..."
    python3 sin_generator.py
else
    echo "Opción no válida. Saliendo."
    exit 1
fi

# Se codifican los datos de entrada
xrun thermometer_decoder.sv

# Simulación del DAC
xrun -f xrun_tb_dac.f

# Post-procesado: FFT y gráficas
python3 fft_generator.py
