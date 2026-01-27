import numpy as np

def popcount(x):
    """Cuenta bits a 1"""
    return bin(x).count("1")

# === CONFIG ===
FILENAME = "stimulus_input.txt"
LSB_BITS = 6
MSB_WEIGHT = 1 << LSB_BITS   # 64 si LSB_BITS=6
THERM_USED_BITS = 15         # usas Dataintherm[14:0]

# === CARGA ARCHIVO ===
data = []

with open(FILENAME, "r") as f:
    for line in f:
        if line.strip() == "":
            continue
        cols = line.split()
        digital_10b = int(cols[3], 2)
        datainbin   = int(cols[4], 2)
        dataintherm = int(cols[6], 2)
        data.append((digital_10b, datainbin, dataintherm))

# === COMPROBACIÓN ===
errors = 0

for i, (digital_10b, datainbin, dataintherm) in enumerate(data):
    lsb_bin = datainbin & ((1 << LSB_BITS) - 1)
    therm_mask = (1 << THERM_USED_BITS) - 1
    therm_count = popcount(dataintherm & therm_mask)

    k_recon = therm_count * MSB_WEIGHT + lsb_bin

    if k_recon != digital_10b:
        errors += 1
        if errors < 10:  # solo imprime los primeros
            print(f"[ERROR] línea {i}: "
                  f"digital={digital_10b}, reconstruido={k_recon}, "
                  f"therm={therm_count}, lsb={lsb_bin}")

print("===================================")
print(f"Total muestras: {len(data)}")
print(f"Errores de código: {errors}")
print("===================================")
