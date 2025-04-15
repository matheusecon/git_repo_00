import numpy as np
from matplotlib import pyplot as plt
from sympy import *


# Define parabola
def f1(x): 
    return x**2

def f2(x): 
    return x**2+4

def f3(x): 
    return x**2+8

# Calculo da derivada
x = Symbol('x')
y = x**3 + 1
yprime = y.diff(x)
yprime

# Define parabola derivative
def slope(x): 
    return 2*x

# Define x data range for parabola
x = np.linspace(-5,5,100)

# Choose point to plot tangent line
x1 = 0

y1 = f1(x1)

y2 = f2(x1)

y3 = f3(x1)

# Define tangent line
# y = m*(x - x1) + y1
def line1(x, x1, y1):
    return slope(x1)*(x - x1) + y1

def line2(x, x1, y2):
    return slope(x1)*(x - x1) + y2

def line3(x, x1, y3):
    return slope(x1)*(x - x1) + y3

# Define x data range for tangent line
xrange1 = np.linspace(x1-1.5, x1+1.5, 10)
xrange2 = np.linspace(x1-1.5, x1+1.5, 10)
xrange3 = np.linspace(x1-1.5, x1+1.5, 10)

# Plot the figure
plt.figure()
plt.plot(x, f1(x))
plt.plot(x, f2(x))
plt.plot(x, f3(x))
plt.scatter(x1, y1, color='C3', s=50)
plt.scatter(x1, y2, color='C3', s=50)
plt.scatter(x1, y3, color='C3', s=50)
plt.plot(xrange1, line1(xrange1, x1, y1), 'C3--', linewidth = 2)
plt.plot(xrange2, line1(xrange2, x1, y2), 'C3--', linewidth = 2)
plt.plot(xrange3, line1(xrange3, x1, y3), 'C3--', linewidth = 2)
axes = plt.gca()
axes.set_xlim([-5,5])
axes.set_ylim([-5,25])