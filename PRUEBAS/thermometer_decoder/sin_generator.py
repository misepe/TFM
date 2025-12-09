import numpy as np
import matplotlib.pyplot as plt

def generar_tonos(frecuencias, amplitudes, duracion, fs=44100):
    """
    Genera una señal combinada de tonos sinusoidales y escribe los datos en un archivo de texto.

    :param frecuencias: Lista de frecuencias.
    :param amplitudes: Lista de amplitudes.
    :param duracion: Duración de la señal en segundos.
    :param fs: Frecuencia de muestreo en Hz (por defecto 44.1 kHz).
    """
    if len(frecuencias) != len(amplitudes):
        raise ValueError("Las listas de frecuencias y amplitudes deben tener la misma longitud.")

    # Generar el tiempo discreto
    t = np.linspace(0, duracion, int(fs * duracion), endpoint=False)

    # Generar la señal combinada
    señal_combinada = np.zeros_like(t)
    for frecuencia, amplitud in zip(frecuencias, amplitudes):
        señal_combinada += amplitud * np.sin(2 * np.pi * frecuencia * t)

    # Escribir los datos en un archivo de texto
    with open("sin_input.txt", "w") as f:
        for tiempo, valor in zip(t, señal_combinada):
            f.write(f"{tiempo:.6f}\t{valor:.6f}\n")

    print("Datos de la señal combinada generados y guardados en 'sin_input.txt'.")

    # Representar la señal combinada en una gráfica
    plt.figure(figsize=(10, 4))
    plt.plot(t, señal_combinada, label="Señal Combinada")
    plt.title("Señal Combinada de Tonos")  
    plt.xlabel("Tiempo (s)")
    plt.ylabel("Amplitud")
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.show()

# Ejemplo de uso: Generar una señal combinada de uno o más tonos
generar_tonos(frecuencias=[1000, 2000, 4000], amplitudes=[1.0, 0.5, 0.25], duracion=1)