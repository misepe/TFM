import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt("noise_samples.txt")
samples = data[:, 1]

mu = np.mean(samples)
sigma = np.std(samples)

x = np.linspace(mu - 5*sigma, mu + 5*sigma, 500)
gauss = (1/(sigma*np.sqrt(2*np.pi))) * np.exp(-0.5*((x-mu)/sigma)**2)

print("Media:", mu)
print("Std:", sigma)

plt.figure(figsize=(10, 5))
plt.hist(samples, bins=50, density=True, edgecolor="black", alpha=0.6, label="Muestras")
plt.plot(x, gauss, linewidth=2, label="Gaussiana (fit)")
plt.title("Histograma + ajuste gaussiano")
plt.xlabel("Valor de ruido")
plt.ylabel("Densidad")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()

