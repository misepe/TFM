import numpy as np
import matplotlib.pyplot as plt


# ============================================================
# FFT CON AMPLITUD FÍSICA REAL (UNILATERAL)
# ============================================================
def fft_amplitud_real(señal, fs):
    """
    Calcula la FFT unilateral de una señal real obteniendo amplitudes físicas.
    - Aplica ventana de Hann para reducir leakage
    - Compensa la ganancia de la ventana
    - Normaliza la FFT para obtener amplitud real
    """

    N = len(señal)

    # Eliminar componente DC (offset)
    señal = señal - np.mean(señal)

    # Ventana de Hann
    window = np.hanning(N)

    # Ganancia media de la ventana
    Gw = np.sum(window) / N

    # FFT ventanada
    fft = np.fft.fft(señal * window)
    fft_half = fft[:N // 2]

    # Espectro unilateral con amplitud física
    # Factor 2/N por FFT unilateral y corrección de ventana
    mag = (2.0 / (N * Gw)) * np.abs(fft_half)

    # Eje de frecuencias
    frec = np.fft.fftfreq(N, 1 / fs)[:N // 2]

    return frec, mag


# ============================================================
# CÁLCULO DE MÉTRICAS ESPECTRALES
# ============================================================
def analizar_metrica_fft(señal, fs):
    """
    Calcula métricas espectrales a partir de la FFT con amplitud real:
    - SNR
    - SFDR
    - DNL (estimado por histograma)
    """

    # FFT física
    frec, mag = fft_amplitud_real(señal, fs)

    # Potencia espectral
    P = mag ** 2

    # --- FUNDAMENTAL ---
    idx_fundamental = np.argmax(P)

    # Integración del fundamental (varios bins por ventana Hann)
    bins_fund = 2
    idx_min = max(idx_fundamental - bins_fund, 0)
    idx_max = min(idx_fundamental + bins_fund + 1, len(P))

    P_signal = np.sum(P[idx_min:idx_max])

    # --- RUIDO ---
    P_noise = np.sum(P) - P_signal
    P_noise = max(P_noise, 1e-30)

    # --- SNR ---
    SNR = 10 * np.log10(P_signal / P_noise)

    # --- SFDR ---
    P_spurs = np.copy(P)
    P_spurs[idx_min:idx_max] = 0
    P_max_spur = max(np.max(P_spurs), 1e-30)

    SFDR = 10 * np.log10(P_signal / P_max_spur)

    # --- DNL ---
    # Estimación a partir del histograma de niveles (modelo RNM)
    hist, _ = np.histogram(señal, bins=256)
    ideal = np.mean(hist)
    DNL = np.max(np.abs(hist - ideal) / ideal)

    return SNR, SFDR, DNL, frec, mag


# ============================================================
# PROCESADO DE UN ARCHIVO (INPUT O OUTPUT)
# ============================================================
def procesar_archivo(archivo, titulo):
    """
    Lee un archivo de datos, calcula métricas y grafica señal y FFT
    """

    datos = np.loadtxt(archivo)
    t = datos[:, 0]
    señal = datos[:, 1]

    fs = 1 / (t[1] - t[0])

    # Métricas
    SNR, SFDR, DNL, frec, mag = analizar_metrica_fft(señal, fs)

    print(f"\nResultados para {titulo}")
    print(f"SNR  = {SNR:.2f} dB")
    print(f"SFDR = {SFDR:.2f} dB")
    print(f"DNL  = {DNL:.4f}")

    # --- GRÁFICAS ---
    plt.figure(figsize=(12, 6))

    # Señal temporal
    plt.subplot(2, 1, 1)
    plt.plot(t, señal)
    plt.title(f"Señal temporal ({titulo})")
    plt.xlabel("Tiempo [s]")
    plt.ylabel("Amplitud")
    plt.grid(True)

    # FFT
    plt.subplot(2, 1, 2)
    plt.plot(frec, 20 * np.log10(mag + 1e-15))
    plt.title(f"FFT ({titulo})")
    plt.xlabel("Frecuencia [Hz]")
    plt.ylabel("Magnitud [dB]")
    plt.xscale("log")
    plt.grid(True)

    plt.tight_layout()
    plt.show(block=False)


# ============================================================
# COMPARACIÓN FFT INPUT VS OUTPUT
# ============================================================
def comparar_fft(archivo_in, archivo_out):
    """
    Superpone las FFT de entrada y salida usando la misma normalización
    """

    datos_in = np.loadtxt(archivo_in)
    datos_out = np.loadtxt(archivo_out)

    t = datos_in[:, 0]
    sig_in = datos_in[:, 1]
    sig_out = datos_out[:, 1]

    fs = 1 / (t[1] - t[0])

    # FFT física coherente para ambas señales
    frec, mag_in = fft_amplitud_real(sig_in, fs)
    _, mag_out = fft_amplitud_real(sig_out, fs)

    # --- FFT COMPARATIVA ---
    plt.figure(figsize=(10, 5))
    plt.plot(frec, 20 * np.log10(mag_in + 1e-15), label="Input", linewidth=1)
    plt.plot(frec, 20 * np.log10(mag_out + 1e-15), label="Output", linewidth=1, alpha=0.8)

    plt.title("Comparación FFT Input vs Output")
    plt.xlabel("Frecuencia [Hz]")
    plt.ylabel("Magnitud [dB]")
    plt.xscale("log")
    plt.grid(True)
    plt.legend()
    plt.show(block=False)

    # --- SEÑALES TEMPORALES ---
    plt.figure(figsize=(11, 4))
    plt.plot(t, sig_in, label="Input")
    plt.plot(t, sig_out, label="Output", alpha=0.7)
    plt.title("Señales temporales Input vs Output")
    plt.xlabel("Tiempo [s]")
    plt.ylabel("Amplitud")
    plt.grid(True)
    plt.legend()
    plt.show(block=False)


# ============================================================
# EJECUCIÓN
# ============================================================
procesar_archivo("input.txt", "Input")
procesar_archivo("output.txt", "Output")

comparar_fft("input.txt", "output.txt")

input("\nPresiona Enter para cerrar...")
