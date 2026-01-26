import os
import glob
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


def leer_fs_de_config(path_config):
    """
    Lee fs de output_config_run_i.txt (3a línea, índice 2).
    """
    with open(path_config, "r") as f:
        lines = f.readlines()
    if len(lines) < 3:
        raise ValueError(f"Config demasiado corto: {path_config}")
    #fs = float(lines[2].strip())
    fs = np.genfromtxt(path_config, dtype=float, skip_header=2, max_rows=1)
    return fs

# ============================================================
# PROMEDIO CUADRÁTICO (ENSEMBLE / WELCH-LIKE) DE 32 OUTPUTS
# ============================================================
def fft_media_cuadratica_outputs(
    carpeta="./output",
    patron_runs="output_run_*.txt",
    col_vout_total=1,   # 2ª columna (t, Vout_total, ...)
    plot=True
):
    archivos = sorted(glob.glob(os.path.join(carpeta, patron_runs)))
    if not archivos:
        raise FileNotFoundError(f"No encuentro archivos: {os.path.join(carpeta, patron_runs)}")

    P_acc = None
    frec_ref = None
    n_usados = 0

    for path_run in archivos:
        # sacar i del nombre: output_run_12.txt -> "12"
        base = os.path.basename(path_run)
        idx = base.replace("output_run_", "").replace(".txt", "")

        # config correspondiente
        path_cfg = os.path.join(carpeta, f"output_config_run_{idx}.txt")
        if not os.path.exists(path_cfg):
            raise FileNotFoundError(f"No existe config para {path_run}: {path_cfg}")

        fs = leer_fs_de_config(path_cfg)

        datos = np.loadtxt(path_run)
        señal = datos[:, col_vout_total]  # Vout_total

        frec, mag = fft_amplitud_real(señal, fs)
        P = mag**2

        if P_acc is None:
            P_acc = np.zeros_like(P)
            frec_ref = frec
        else:
            if len(P) != len(P_acc):
                raise ValueError(f"FFT distinta longitud en {path_run}: {len(P)} vs {len(P_acc)}")
            # opcional: comprobar que las frecuencias coinciden
            if not np.allclose(frec, frec_ref):
                raise ValueError(f"Eje de frecuencias distinto en {path_run} (fs diferente o N diferente).")

        P_acc += P
        n_usados += 1

    # media en potencia
    P_avg = P_acc / n_usados

    # magnitud RMS equivalente y a dB
    mag_rms = np.sqrt(P_avg)
    mag_rms_db = 20 * np.log10(mag_rms + 1e-30)

    np.savetxt("./output_mean.txt",np.column_stack([frec_ref,P_avg, mag_rms, mag_rms_db]))


    if plot:
        plt.figure(figsize=(10, 5))
        plt.plot(frec_ref, mag_rms_db, linewidth=1)
        plt.title(f"FFT promedio cuadrático (M={n_usados})")
        plt.xlabel("Frecuencia [Hz]")
        plt.ylabel("Magnitud [dB]")
        plt.xscale("log")
        plt.grid(True)
        plt.tight_layout()
        plt.show(block=False)

    return frec_ref, mag_rms, mag_rms_db, n_usados


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
def analizar_metrica_fft(señal, vref, tipo_senal, fs,t):
    """
    Calcula métricas espectrales a partir de la FFT con amplitud real:
    - SNR
    - SFDR
    - DNL 
    """

    # FFT física
    if(tipo_senal != "output_dac" and tipo_senal != "output_rampa_por_codigos"):
        frec, mag = fft_amplitud_real(señal, fs)
        
    else:
        mag=np.sqrt(señal) #Si la señal es potencia se cambia hace la raíz cuadrada para tener la magnitud
        frec=t

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
def procesar_archivo(archivo,archivo_config, titulo, archivo_mean = None):
    """
    Lee un archivo de datos, calcula métricas y grafica señal y FFT
    """

    if archivo_mean is None:
        archivo_mean = archivo #Usar archivo como archivo mean si no se pasa otro
        print("Usando mismo archivo para mean:", archivo_mean)

    datos = np.loadtxt(archivo)
    datos_mean = np.loadtxt(archivo_mean)
    t = datos[:, 0]
    señal = datos[:, 1]
    t_mean = datos_mean[:, 0]
    señal_mean = datos_mean[:, 1] #Se usa la potencia en rms o la señal directamente
    vref = np.genfromtxt(archivo_config, dtype=float, skip_header=3, max_rows=1)
    vref = vref[0] if vref.ndim > 0 else vref  # Seleccionar el primer valor si es un array
    
    tipo_senal = np.genfromtxt(archivo_config, dtype=str, skip_header=0, max_rows=1)

    

    #fs = 1 / (t[1] - t[0])
    #fs = np.genfromtxt(archivo_config, dtype=float, skip_header=2, max_rows=1)
    fs= leer_fs_de_config(archivo_config)

    # Métricas
    SNR, SFDR, DNL, frec, mag = analizar_metrica_fft(señal_mean, vref, tipo_senal, fs,t_mean)

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
def comparar_fft(archivo_in, archivo_out,archivo_mean):
    """
    Superpone las FFT de entrada y salida usando la misma normalización
    """

    datos_in = np.loadtxt(archivo_in)
    datos_out = np.loadtxt(archivo_out)
    datos_mean = np.loadtxt(archivo_mean)

    t = datos_in[:, 0]
    sig_in = datos_in[:, 1]
    sig_out = datos_out[:, 1]
    frec_out_mean = datos_mean[:, 0]
    mag_out_mean = datos_mean[:, 2] #Se usa la magnitud en rms

    fs = 1 / (t[1] - t[0])

    # FFT física coherente para ambas señales
    frec, mag_in = fft_amplitud_real(sig_in, fs)
    _, mag_out = fft_amplitud_real(sig_out, fs)
    

    # --- FFT COMPARATIVA ---
    plt.figure(figsize=(10, 5))
    plt.plot(frec, 20 * np.log10(mag_in + 1e-15), label="Input", linewidth=1)
    plt.plot(frec_out_mean, (20 * np.log10(mag_out_mean + 1e-15)), label="Output", linewidth=1, alpha=0.8)

    #La comparación de la salida es a full scale
    plt.plot(frec_out_mean, (20 * np.log10(mag_out_mean + 1e-15))-np.max(20 * np.log10(mag_out_mean + 1e-15)), label="Output_full_sacle", linewidth=1, alpha=0.8)

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

f, mag_rms, mag_rms_db, M = fft_media_cuadratica_outputs("./output", plot=True)

procesar_archivo("input.txt","input_config.txt", "Input")
#procesar_archivo("./output_mean.txt", "./output/output_config_run_1.txt", "Output mean time")
#procesar_archivo("./output/output_run_1.txt", "./output/output_config_run_1.txt", "Output time time ")
procesar_archivo("./output/output_run_1.txt", "./output/output_config_run_1.txt", "Output all","./output_mean.txt")

comparar_fft("input.txt", "./output/output_run_1.txt","output_mean.txt")

input("\nPresiona Enter para cerrar...")
