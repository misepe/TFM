import numpy as np
import matplotlib.pyplot as plt

def generar_rampa(amplitud, duracion, fs=10e6):
    """
    Genera una señal de rampa lineal y escribe los datos en un archivo de texto.

    :param amplitud: Amplitud máxima de la rampa.
    :param duracion: Duración de la señal en segundos.
    :param fs: Frecuencia de muestreo en Hz (por defecto 4.6 MHz).
    """
    # Generar el tiempo discreto
    t = np.linspace(0, duracion, int(fs * duracion), endpoint=False)

    # Generar la señal de rampa
    rampa = amplitud * (t / duracion)

    # Escribir los datos de configuración en un archivo de texto
    with open("input_config.txt", "w") as f_config:
        f_config.write(f"{duracion:.15f}\n")
        f_config.write(f"{fs:.15f}\n")
        f_config.write(f"{amplitud:.15f}\n")

    # Escribir los datos en un archivo de texto
    with open("input.txt", "w") as f:
        #f.write(f"{amplitud:.15f}\t{duracion:.15f}\t{fs:.15f}\n")
        for tiempo, valor in zip(t, rampa):
            f.write(f"{tiempo:.15f}\t{valor:.15f}\n")

    print("Datos de la señal de rampa generados y guardados en 'input.txt'.")

    # Representar la señal de rampa en una gráfica
    plt.figure(figsize=(10, 4))
    plt.plot(t, rampa, label="Señal de Rampa")
    plt.title("Señal de Rampa Lineal")
    plt.xlabel("Tiempo (s)")
    plt.ylabel("Amplitud")
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.show()

# Ejemplo de uso: Generar una señal de rampa con amplitud 1.0 y duración de 0.001 segundos
generar_rampa(amplitud=0.2, duracion=0.0001)