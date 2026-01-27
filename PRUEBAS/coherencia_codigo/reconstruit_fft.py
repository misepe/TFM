import numpy as np
import matplotlib.pyplot as plt

def fft_amplitud_real(x, fs):
    N = len(x)
    x = x - np.mean(x)
    w = np.hanning(N)
    Gw = np.sum(w)/N
    X = np.fft.fft(x*w)[:N//2]
    mag = (2.0/(N*Gw))*np.abs(X)
    f = np.fft.fftfreq(N, 1/fs)[:N//2]
    return f, mag

# Carga stimulus_input (donde está digital_10b)
d = np.loadtxt("../../DAC/stimulus_input.txt", dtype=str)
t = d[:,0].astype(float)
digital_10b = np.array([int(b,2) for b in d[:,3]])

# Reconstrucción ideal del DAC (unipolar 0..FS)
Nbits = 10
FS = 0.639375  # pon aquí tu VFS diferencial real si lo sabes
yq = (digital_10b/(2**Nbits-1))*FS

fs = 1/(t[1]-t[0])

f, mag = fft_amplitud_real(yq, fs)
plt.semilogx(f, 20*np.log10(mag+1e-15))
plt.grid(True)
plt.title("FFT de señal reconstruida desde digital_10b (solo cuantización)")
plt.xlabel("Hz"); plt.ylabel("dB")
plt.show()
