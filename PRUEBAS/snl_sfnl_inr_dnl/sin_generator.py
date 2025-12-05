import numpy as np
import matplotlib.pyplot as plt

# Parámetros de la señal
frecuencia = 1000  # Frecuencia de la señal en Hz (1 kHz)
amplitud = 1.0     # Amplitud de la señal
duracion = 0.01    # Duración de la señal en segundos (10 ms)
fs = 44100         # Frecuencia de muestreo en Hz (44.1 kHz)

# Generar el tiempo discreto
t = np.linspace(0, duracion, int(fs * duracion), endpoint=False)

# Generar la señal sinusoidal
sinusoidal = amplitud * np.sin(2 * np.pi * frecuencia * t)

# Escribir los datos en un archivo de texto
with open("sin_input.txt", "w") as f:
    for tiempo, valor in zip(t, sinusoidal):
        f.write(f"{tiempo:.6f}\t{valor:.6f}\n")

print("Datos de la señal sinusoidal generados y guardados en 'sin_input.txt'.")

# Representar la señal en una gráfica
plt.figure(figsize=(10, 4))
plt.plot(t, sinusoidal, label="Señal Sinusoidal (1kHz)")
plt.title("Señal Sinusoidal")  
plt.xlabel("Tiempo (s)")
plt.ylabel("Amplitud")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
