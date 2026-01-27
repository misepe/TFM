# Preguntar al usuario qué tipo de señal generar
echo "Seleccione el tipo de señal a generar:"
echo "1: Señal tipo barrido de los codigos input"
echo "2: Señal tipo seno"
echo "3: Señal tipo rampa"
read -p "Ingrese su elección (1, 2 o 3): " choice




################################SEÑAL TIPO BARRIDO DE CODIGOS INPUT##############################
if [ "$choice" -eq 1 ]; then
    echo "Generando señal tipo barrido de los codigos input..."
    python3 rampa_codigos_generator.py

    # Se codifican los datos de entrada
    xrun thermometer_decoder.sv

    # Preguntar al usuario qué modelos quiere utilizar
    echo "Seleccione el modelo de DAC a simular:"
    echo "1: Modelo ideal"
    echo "2: Modelos con mismatches"
    echo "3: Modelos con jitter"
    echo "4: Modelos con noise"
    echo "5: Modelos con todas las no linealidades"
    read -p "Ingrese su elección (1,2,3,4 o 5): " choice

    if [ "$choice" -eq 1 ]; then
        echo "Ejecutando modelos ideales..."
        xrun -f xrun_tb_dac.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 2 ]; then
        echo "Ejecutando modelos con mismatches..."
        xrun -f xrun_tb_dac_mismatch.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 3 ]; then
        echo "Ejecutando modelos con jitter..."
        xrun -f xrun_tb_dac_jitter.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 4 ]; then
        echo "Ejecutando modelos con noise..."
        xrun -f xrun_tb_dac_noise.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 5 ]; then
        echo "Ejecutando modelos con todas las no linealidades..."
        xrun -f xrun_tb_dac_all_non_linearities.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    else
        echo "Opción no válida. Saliendo."
        exit 1
    fi






################################SEÑAL TIPO SENO##################################################
elif [ "$choice" -eq 2 ]; then
    echo "Generando señal tipo seno..."
    python3 sin_generator.py

    # Se codifican los datos de entrada
    xrun thermometer_decoder.sv

    # Preguntar al usuario qué modelos quiere utilizar
    echo "Seleccione el modelo de DAC a simular:"
    echo "1: Modelo ideal"
    echo "2: Modelos con mismatches"
    echo "3: Modelos con jitter"
    echo "4: Modelos con noise"
    echo "5: Modelos con todas las no linealidades"
    read -p "Ingrese su elección (1,2,3,4 o 5): " choice

    if [ "$choice" -eq 1 ]; then
        echo "Ejecutando modelos ideales..."
        read -p "Quiere simular 32 veces para obtener mejores estadísticas? (y/n)" choice
        if [ "$choice" = "y" ]; then
            xrun -f xrun_tb_dac_mean.f
            # Post-procesado: FFT y gráficas
            python3 fft_generator_mean.py
        else
            xrun -f xrun_tb_dac.f
            # Post-procesado: FFT y gráficas
            python3 fft_generator.py
        fi

    elif [ "$choice" -eq 2 ]; then
        echo "Ejecutando modelos con mismatches..."
        xrun -f xrun_tb_dac_mismatch.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 3 ]; then
        echo "Ejecutando modelos con jitter..."
        xrun -f xrun_tb_dac_jitter.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

     elif [ "$choice" -eq 4 ]; then
        echo "Ejecutando modelos con noise..."
        xrun -f xrun_tb_dac_noise.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 5 ]; then
        echo "Ejecutando modelos con todas las no linealidades..."
        read -p "Quiere simular 32 veces para obtener mejores estadísticas? (y/n)" choice
        if [ "$choice" = "y" ]; then
            xrun -f xrun_tb_dac_all_non_linearities_mean.f
            # Post-procesado: FFT y gráficas
            python3 fft_generator_mean.py
        else
            xrun -f xrun_tb_dac_all_non_linearities.f
            # Post-procesado: FFT y gráficas
            python3 fft_generator.py
        fi
    else
        echo "Opción no válida. Saliendo."
        exit 1
    fi




##################################SEÑAL TIPO RAMPA##############################################
elif [ "$choice" -eq 3 ]; then
    echo "Generando señal tipo rampa analógica..."
    python3 rampa_generator.py

    # Se codifican los datos de entrada
    xrun thermometer_decoder.sv

    # Preguntar al usuario qué modelos quiere utilizar
    echo "Seleccione el modelo de DAC a simular:"
    echo "1: Modelo ideal"
    echo "2: Modelos con mismatches"
    echo "3: Modelos con jitter"
    echo "4: Modelos con noise"
    echo "5: Modelos con todas las no linealidades"
    read -p "Ingrese su elección (1,2,3,4 o 5): " choice

    if [ "$choice" -eq 1 ]; then
        echo "Ejecutando modelos ideales..."
        xrun -f xrun_tb_dac.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 2 ]; then
        echo "Ejecutando modelos con mismatches..."
        xrun -f xrun_tb_dac_mismatch.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 3 ]; then
        echo "Ejecutando modelos con jitter..."
        xrun -f xrun_tb_dac_jitter.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

     elif [ "$choice" -eq 4 ]; then
        echo "Ejecutando modelos con noise..."
        xrun -f xrun_tb_dac_noise.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    elif [ "$choice" -eq 5 ]; then
        echo "Ejecutando modelos con todas las no linealidades..."
        xrun -f xrun_tb_dac_all_non_linearities.f
        # Post-procesado: FFT y gráficas
        python3 fft_generator.py

    else
        echo "Opción no válida. Saliendo."
        exit 1
    fi




else
    echo "Opción no válida. Saliendo."
    exit 1
fi



####################################################################################################
####################################################################################################
####################################################################################################
# Se codifican los datos de entrada
#xrun thermometer_decoder.sv

# Simulación del DAC
#xrun -f xrun_tb_dac.f

# Preguntar al usuario qué modelos quiere utilizar
#echo "Seleccione el modelo de DAC a simular:"
#echo "1: Modelo ideal"
#echo "2: Modelos con mismatches"
#echo "3: Modelos con jitter"
#echo "4: Modelos con todas las no linealidades"
#read -p "Ingrese su elección (1,2,3 o 4): " choice
#
#if [ "$choice" -eq 1 ]; then
#    echo "Ejecutando modelos ideales..."
#    read -p "Quiere simular 32 veces para obtener mejores estadísticas? (y/n)" choice
#    if [ "$choice" = "y" ]; then
#        xrun -f xrun_tb_dac_mean.f
#        # Post-procesado: FFT y gráficas
#        python3 fft_generator_mean.py
#    else
#        xrun -f xrun_tb_dac.f
#        # Post-procesado: FFT y gráficas
#        python3 fft_generator.py
#    fi
#
#elif [ "$choice" -eq 2 ]; then
#    echo "Ejecutando modelos con mismatches..."
#    xrun -f xrun_tb_dac_mismatches.f
#    # Post-procesado: FFT y gráficas
#    python3 fft_generator.py
#
#elif [ "$choice" -eq 3 ]; then
#    echo "Ejecutando modelos con jitter..."
#    xrun -f xrun_tb_dac_jitter.f
#    # Post-procesado: FFT y gráficas
#    python3 fft_generator.py
#
#elif [ "$choice" -eq 4 ]; then
#    echo "Ejecutando modelos con mismatches y jitter..."
#    read -p "Quiere simular 32 veces para obtener mejores estadísticas? (y/n)" choice
#    if [ "$choice" = "y" ]; then
#        xrun -f xrun_tb_dac_all_non_linearities_mean.f
#        # Post-procesado: FFT y gráficas
#        python3 fft_generator_mean.py
#    else
#        xrun -f xrun_tb_dac_all_non_linearities.f
#        # Post-procesado: FFT y gráficas
#        python3 fft_generator.py
#    fi
#else
#    echo "Opción no válida. Saliendo."
#    exit 1
#fi

