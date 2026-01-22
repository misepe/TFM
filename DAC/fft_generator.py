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

def real_to_code(señal, vref=1.0, tipo_senal="sinusoidal", n_bits=10):
    """
    Convierte señal analógica (real) a códigos enteros 0..(2^N-1)
    asumiendo rango bipolar [-VREF, +VREF]
    """
    n_codes = 2**n_bits
    if tipo_senal == "output_dac" or tipo_senal == "output_rampa_por_codigos":
        vref = max(señal)
    if tipo_senal == "rampa_por_codigos":
        vref = n_codes - 1
    print("Vref used for code conversion:", vref)
    if tipo_senal == "sinusoidal" or tipo_senal == "output_dac" or tipo_senal == "output_rampa_por_codigos":
        codes = np.round(((señal + vref) / (2*vref)) * (n_codes - 1)).astype(int)
    else:
        codes = np.round(((señal) / (vref)) * (n_codes - 1)).astype(int)
    codes = np.clip(codes, 0, n_codes-1)
    #np.set_printoptions(threshold=np.inf)  # Desactiva el truncamiento
    #print("Codes for DNL calculation:", codes)
    return codes


# ============================================================
# Calculo del histograma para calcular DNL
# ============================================================


def dnl_por_pasos_barrido(señal, vref, tipo_senal, n_bits=10):
    """
    DNL estático asumiendo que:
      - la señal está muestreada como un barrido de códigos consecutivos
      - cada muestra corresponde a un código distinto (1 muestra por escalón)

    IMPORTANTE: esto solo es válido si el DAC/modelo se asienta en 1 muestra.
    """

    señal = np.asarray(señal)
    n_codes = 2**n_bits

    # Para output, NO recomiendo usar max(señal) como vref,
    # pero si lo quieres mantener:
    if tipo_senal == "output_rampa_por_codigos":
        vref = max(señal)

    # Unipolar 0..Vref -> LSB ideal por pasos
    lsb_ideal = vref / (n_codes - 1)
    print("lsb_ideal:", lsb_ideal, "vref", vref)

    # Si hay más muestras que códigos, recortamos a n_codes
    # Si hay menos, calculamos con lo que haya (pero no será “1024 códigos”)
    n = min(len(señal), n_codes)
    niveles = señal[:n]

    print("Niveles usados:", len(niveles))

    if len(niveles) < 2:
        return np.nan, np.array([np.nan]), niveles

    delta = np.diff(niveles)
    dnl_k = delta / (lsb_ideal + 1e-30) - 1.0
    dnl_peak = np.max(np.abs(dnl_k))

    return dnl_peak, dnl_k, niveles



# ============================================================
# CÁLCULO DE MÉTRICAS ESPECTRALES
# ============================================================
def analizar_metrica_fft(señal, vref, tipo_senal, fs):
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
    bins_fund = 10 # número de bins para integrar alrededor del pico fundamental
    idx_min = max(idx_fundamental - bins_fund, 0)
    idx_max = min(idx_fundamental + bins_fund + 1, len(P))

    P_signal = np.sum(P[idx_min:idx_max])

    # --- RUIDO ---
    P_noise = np.sum(P) - P_signal
    P_noise = max(P_noise, 1e-30)

    # --- SNR ---
    print("SNR Calculation: P_signal =", P_signal, ", P_noise =", P_noise)
    SNR = 10 * np.log10(P_signal / P_noise)

    # --- SFDR ---
    P_spurs = np.copy(P)
    P_spurs[idx_min:idx_max] = 0
    P_max_spur = max(np.max(P_spurs), 1e-30)

    print("SFDR Calculation: P_signal =", P_signal, ", P_max_spur =", P_max_spur)
    SFDR = 10 * np.log10(P_signal / P_max_spur)

    # --- DNL ---
    # Estimación a partir del histograma de niveles (modelo RNM)
    #hist, _ = np.histogram(señal, bins=256)
    #ideal = np.mean(hist)
    #DNL = np.max(np.abs(hist - ideal) / ideal)

    if tipo_senal == "rampa_por_codigos" or tipo_senal == "output_rampa_por_codigos":
        DNL_peak, dnl_k, niveles = dnl_por_pasos_barrido(señal, vref, tipo_senal, n_bits=10)
        codes = real_to_code(señal, vref=vref, tipo_senal=tipo_senal, n_bits=10)
        hist = np.bincount(codes, minlength=2**10)

        plt.figure(figsize=(10,8))
        #plot histogram of codes
        plt.subplot(2, 1, 1)
        plt.plot(hist)
        plt.title(f"Histograma de códigos ({tipo_senal})")
        plt.xlabel("Código")
        plt.ylabel("Número de ocurrencias")
        plt.grid(True)
        plt.tight_layout()
        plt.show(block=False)

        #plot dnl curve
        plt.subplot(2, 1, 2)
        plt.plot(dnl_k)
        plt.title(f"DNL por código ({tipo_senal})")
        plt.xlabel("Código")
        plt.ylabel("DNL [LSB]")
        plt.grid(True)
        plt.tight_layout()
        plt.show(block=False)
    else:
        DNL_peak = np.nan

    return SNR, SFDR, DNL_peak, frec, mag


# ============================================================
# PROCESADO DE UN ARCHIVO (INPUT O OUTPUT)
# ============================================================
def procesar_archivo(archivo,archivo_config, titulo):
    """
    Lee un archivo de datos, calcula métricas y grafica señal y FFT
    """

    datos = np.loadtxt(archivo)
    t = datos[:, 0]
    señal = datos[:, 1]
    vref = np.genfromtxt(archivo_config, dtype=float, skip_header=3, max_rows=1)
    vref = vref[0] if vref.ndim > 0 else vref  # Seleccionar el primer valor si es un array
    
    tipo_senal = np.genfromtxt(archivo_config, dtype=str, skip_header=0, max_rows=1)


    #fs = 1 / (t[1] - t[0])
    fs = np.genfromtxt(archivo_config, dtype=float, skip_header=2, max_rows=1)

    # Métricas
    SNR, SFDR, DNL, frec, mag = analizar_metrica_fft(señal, vref, tipo_senal, fs)

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
    plt.plot(frec, (20 * np.log10(mag_out + 1e-15)), label="Output", linewidth=1, alpha=0.8)

    #La comparación de la salida es a full scale
    plt.plot(frec, (20 * np.log10(mag_out + 1e-15))-np.max(20 * np.log10(mag_out + 1e-15)), label="Output_full_sacle", linewidth=1, alpha=0.8)

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
procesar_archivo("input.txt","input_config.txt", "Input")
procesar_archivo("output.txt", "output_config.txt", "Output")

comparar_fft("input.txt", "output.txt")

input("\nPresiona Enter para cerrar...")
