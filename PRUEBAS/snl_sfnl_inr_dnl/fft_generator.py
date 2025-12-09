import numpy as np
import matplotlib.pyplot as plt

def analizar_metrica_fft(señal, fs):

    # FFT
    N = len(señal)
    fft_result = np.fft.fft(señal)
    magnitud = np.abs(fft_result)[:N//2]
    frec = np.fft.fftfreq(N, 1/fs)[:N//2]

    # Magnitud del pico principal (fundamental)
    idx_fundamental = np.argmax(magnitud)
    fundamental = magnitud[idx_fundamental]

    # Ruido = todo excepto fundamental
    ruido = np.sqrt(np.sum(magnitud**2) - fundamental**2)

    # SNR (dB)
    SNR = 20 * np.log10(fundamental / ruido)

    # SFNR o SFDR: diferencia entre fundamental y mayor espurio
    espurios = np.copy(magnitud)
    espurios[idx_fundamental] = 0
    esp_max = np.max(espurios)
    SFNR = 20 * np.log10(fundamental / esp_max)

    # INR: interferencias (armónicos sin fundamental) respecto al ruido total
    INR = 20 * np.log10(esp_max / ruido)

    # DNL estimado a partir del histograma de niveles
    hist, bins = np.histogram(señal, bins=256)
    ideal = np.mean(hist)
    DNL = np.max(np.abs(hist - ideal) / ideal)

    return SNR, SFNR, INR, DNL, frec, magnitud


def procesar_archivo(archivo, titulo):
    datos = np.loadtxt(archivo)
    t = datos[:,0]
    señal = datos[:,1]
    fs = 1 / (t[1]-t[0])

    SNR, SFNR, INR, DNL, frec, magnitud = analizar_metrica_fft(señal, fs)

    print(f"\n Resultados para {titulo}")
    print(f"SNR   = {SNR:.2f} dB")
    print(f"SFNR  = {SFNR:.2f} dB")
    print(f"INR   = {INR:.2f} dB")
    print(f"DNL   = {DNL:.4f}")

    # Graficar señal y FFT
    plt.figure(figsize=(12,6))

    plt.subplot(2,1,1)
    plt.plot(t, señal)
    plt.title(f"Señal ({titulo})")
    plt.xlabel("Tiempo [s]")
    plt.ylabel("Amplitud")
    plt.grid(True)

    plt.subplot(2,1,2)
    plt.plot(frec, magnitud)
    plt.title(f"FFT ({titulo})")
    plt.xlabel("Frecuencia [Hz]")
    plt.xscale('log')
    plt.ylabel("Magnitud")
    plt.yscale('log')
    plt.grid(True)

    plt.tight_layout()
    plt.show(block=False)


def comparar_fft(archivo_in, archivo_out):
    datos_in = np.loadtxt(archivo_in)
    datos_out = np.loadtxt(archivo_out)

    t = datos_in[:,0]
    sig_in = datos_in[:,1]
    sig_out = datos_out[:,1]

    fs = 1/(t[1]-t[0])

    # FFT
    fft_in = np.abs(np.fft.fft(sig_in)) / len(sig_in)
    fft_out = np.abs(np.fft.fft(sig_out)) / len(sig_out)
    frec = np.fft.fftfreq(len(sig_in),1/fs)

    half = len(frec)//2

    plt.figure(figsize=(10,5))
    plt.plot(frec[:half],fft_in[:half],label="Input",linewidth=1)
    plt.plot(frec[:half],fft_out[:half],label="Output con ruido/offset",linewidth=1,alpha=0.8)
    plt.title("Comparación FFT Input vs Output")
    plt.xlabel("Frecuencia [Hz]")
    plt.xscale('log')
    plt.ylabel("Magnitud")
    plt.yscale('log')
    plt.grid(True)
    plt.legend()
    plt.show(block=False)

      # Nueva ventana (opcional pero útil)
    plt.figure(figsize=(11,4))
    plt.plot(t,sig_in,label="Input")
    plt.plot(t,sig_out,label="Output",alpha=0.7)
    plt.title("Señales Input vs Output")
    plt.xlabel("Tiempo [s]")
    plt.ylabel("Amplitud")
    plt.grid()
    plt.legend()
    plt.show(block=False)


# Ejecutar
procesar_archivo("sin_input.txt", "sin_input.txt")
procesar_archivo("sin_output.txt", "sin_output.txt")

comparar_fft("sin_input.txt", "sin_output.txt")

input("\nPresiona Enter para cerrar...")
