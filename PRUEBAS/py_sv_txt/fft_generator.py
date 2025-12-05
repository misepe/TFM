import numpy as np
import matplotlib.pyplot as plt

def procesar_archivo(archivo, titulo):
    # Leer los datos desde el archivo
    datos = np.loadtxt(archivo)

    # Separar las columnas en tiempo y valores de la señal
    t = datos[:, 0]  # Primera columna: tiempo
    señal = datos[:, 1]  # Segunda columna: valores de la señal

    # Frecuencia de muestreo (calculada a partir del tiempo)
    fs = 1 / (t[1] - t[0])  # Inversa del intervalo de muestreo

    # Calcular la FFT
    fft_result = np.fft.fft(señal)
    frecuencias = np.fft.fftfreq(len(fft_result), 1/fs)

    # Tomar la magnitud de la FFT
    magnitud = np.abs(fft_result)

    # Graficar la señal original
    plt.figure(figsize=(12, 6))

    plt.subplot(2, 1, 1)
    plt.plot(t, señal)
    plt.title(f"Señal sinusoidal ({titulo})")
    plt.xlabel("Tiempo (s)")
    plt.ylabel("Amplitud")
    plt.grid(True)

    # Graficar la FFT (solo frecuencias positivas)
    plt.subplot(2, 1, 2)
    plt.plot(frecuencias[:len(frecuencias)//2], magnitud[:len(magnitud)//2])
    plt.title(f"Transformada Rápida de Fourier (FFT) ({titulo})")
    plt.xlabel("Frecuencia (Hz)")
    plt.ylabel("Magnitud")
    plt.grid(True)

    plt.tight_layout()
    plt.show(block=False)  # Mostrar la gráfica sin bloquear la ejecución

# Procesar el archivo sin_input.txt
procesar_archivo("sin_input.txt", "sin_input.txt")

# Procesar el archivo sin_output.txt
procesar_archivo("sin_output.txt", "sin_output.txt")

# Mantener las ventanas abiertas hasta que el usuario las cierre
input("Presiona Enter para cerrar todas las ventanas...")