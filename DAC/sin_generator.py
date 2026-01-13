import numpy as np
import matplotlib.pyplot as plt

def generar_tonos(frecuencias, amplitudes, duracion, fs=6e6): #Fs = 8.192 MHz para tener un numero de datos que sea potencia de 2
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
    señal_combinada += 1e-12  # Evitar problemas con logaritmos de cero
    for frecuencia, amplitud in zip(frecuencias, amplitudes):
        señal_combinada += amplitud * np.sin(2 * np.pi * frecuencia * t)

    # Añadir ruido pequeño a la señal
    ruido = np.random.normal(0, 0.00001 * np.max(amplitudes), size=señal_combinada.shape) # añadir ruido normal con una desviación estándar del 0.001%
    señal_combinada += ruido

    # Escribir los datos de configuración en un archivo de texto
    with open("input_config.txt", "w") as f_config:
        f_config.write(f"{duracion:.15f}\n")
        f_config.write(f"{fs:.15f}\n")
        for frecuencia, amplitud in zip(frecuencias, amplitudes):
            f_config.write(f"{amplitud:.15f}\t{frecuencia:.15f}\n")

    # Escribir los datos en un archivo de texto
    with open("input.txt", "w") as f:
        #f.write(f"{amplitud:.15f}\t{duracion:.15f}\t{fs:.15f}\n")
        for tiempo, valor in zip(t, señal_combinada):
            f.write(f"{tiempo:.15f}\t{valor:.15f}\n")

    print("Datos de la señal combinada generados y guardados en 'input.txt'.")

    respuesta = input("¿Desea ver la gráfica de la señal generada? (s/n): ")
    if respuesta.lower() == 's':
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
# La amplitud máxima de entrada es de 0.125 porque al ponerle el offset para eliminar los negativos, la señal pasa 
# de un rango de -0.125 a 0.125 a un rango de 0 a 0.25, Vmax=Vref/2=500uV/2=250uV
generar_tonos(frecuencias=[1e6], amplitudes=[0.125], duracion=0.0005)  # Señal de 1 MHz y duración de 0.0001 segundos
#generar la señal con un poco de ruido