import numpy as np
import matplotlib.pyplot as plt

def generar_rampa_por_codigos(n_codigos=1024, duracion=0.001, fs=8.192e6):
    """
    Genera una señal de rampa que barre por todos los códigos de entrada del DAC.

    :param n_codigos: Número de códigos del DAC (por defecto 1024).
    :param duracion: Duración de la señal en segundos.
    :param fs: Frecuencia de muestreo en Hz (por defecto 8.192 MHz).
    """
    # Generar el tiempo discreto
    t = np.linspace(0, duracion, int(fs * duracion), endpoint=False)

    # Generar la señal de rampa que barre todos los códigos
    rampa = np.linspace(0, n_codigos-1, len(t))

    # Escribir los datos de configuración en un archivo de texto
    with open("input_config.txt", "w") as f_config:
        f_config.write("rampa_por_codigos\n")
        f_config.write(f"{duracion:.15f}\n")
        f_config.write(f"{fs:.15f}\n")
        f_config.write(f"{n_codigos}\n")

    # Escribir los datos en un archivo de texto
    with open("input.txt", "w") as f:
        for tiempo, valor in zip(t, rampa):
            f.write(f"{tiempo:.15f}\t{valor:.15f}\n")

    print("Datos de la señal de rampa por códigos generados y guardados en 'input.txt'.")

    respuesta = input("¿Desea ver la gráfica de la señal generada? (s/n): ")
    if respuesta.lower() == 's':
        # Representar la señal de rampa en una gráfica
        plt.figure(figsize=(10, 4))
        plt.plot(t, rampa, label="Señal de Rampa por Códigos")
        plt.title("Señal de Rampa por Códigos del DAC")
        plt.xlabel("Tiempo (s)")
        plt.ylabel("Código")
        plt.grid(True)
        plt.legend()
        plt.tight_layout()
        plt.show()

# Ejemplo de uso
generar_rampa_por_codigos(n_codigos=1024, duracion=0.000125)  # Duración ajustada para que quepan todos los códigos 
#duración = n_muestras / fs -> 10240 / 8.192e6 = 0.00125 s
