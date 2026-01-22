# Preguntar al usuario qué tipo de señal generar
echo "Seleccione el tipo de señal a generar:"
echo "1: Señal tipo rampa"
echo "2: Señal tipo barrido de los codigos input"
echo "3: Señal tipo seno"
read -p "Ingrese su elección (1, 2 o 3): " choice

if [ "$choice" -eq 1 ]; then
    echo "Generando señal tipo rampa analógica..."
    python3 rampa_generator.py
elif [ "$choice" -eq 2 ]; then
    echo "Generando señal tipo barrido de los codigos input..."
    python3 rampa_codigos_generator.py
elif [ "$choice" -eq 3 ]; then
    echo "Generando señal tipo seno..."
    python3 sin_generator.py
else
    echo "Opción no válida. Saliendo."
    exit 1
fi

# Se codifican los datos de entrada
xrun thermometer_decoder.sv

# Simulación del DAC
#xrun -f xrun_tb_dac.f

# Preguntar al usuario qué modelos quiere utilizar
echo "Seleccione el modelo de DAC a simular:"
echo "1: Modelo ideal"
echo "2: Modelos con mismatches"
echo "3: Modelos con jitter"
echo "4: Modelos con mismatches y jitter"
read -p "Ingrese su elección (1,2,3 o 4): " choice

if [ "$choice" -eq 1 ]; then
    echo "Ejecutando modelos ideales..."
    xrun -f xrun_tb_dac.f
elif [ "$choice" -eq 2 ]; then
    echo "Ejecutando modelos con mismatches..."
    xrun -f xrun_tb_dac_mismatches.f
elif [ "$choice" -eq 3 ]; then
    echo "Ejecutando modelos con jitter..."
    xrun -f xrun_tb_dac_jitter.f
elif [ "$choice" -eq 4 ]; then
    echo "Ejecutando modelos con mismatches y jitter..."
    xrun -f xrun_tb_dac_all_non_linearities.f
else
    echo "Opción no válida. Saliendo."
    exit 1
fi


# Post-procesado: FFT y gráficas
python3 fft_generator.py
