###########################################################
## GENERATE WAVEFORM RAM DATA FROM ANALYTICAL EXPRESSION ##
###########################################################

from math import pi, sin, cos

def itof(x):
    return float(x / 31)

def scale(f):
    if f > 1:
        f = 1
    elif f < 0:
        f = 0
    return int(round(0xF * f))


def sin_w(x):
    return sin(2 * pi * x)

def cos_w(x):
    return cos(2 * pi * x)

def f(x):
    x_f = itof(x)
    X = ideal_func(x_f)
    return scale(0.5 * (1 + X))

def ideal_func(x):
    return sin_w(x) / (x+0.01)

n = 8
cache = []

print("  dl ", end="")

for x in range(32):
    if (x+1) % n:
        cache.append(f(x))
    else:
        total = f(x)

        for item in cache[::-1]:
            total = (total << 4) | item

        print(f"{total:#0{n+2}x}".replace("0x", "$").upper(),
              end=(", " if x < 31 else ""))

        cache = []

print()

