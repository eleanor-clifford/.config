#!/usr/bin/python3
from matplotlib import pyplot as plt
import numpy as np
data = open("batterylog.txt").read().split("\n")[:-1] # last one is empty string
data = [x.split(" ") for x in data]
pw = np.array([int(x[0]) for i,x in enumerate(data)])
en = [int(x[1]) for i,x in enumerate(data)]
t = np.array(range(0,5*len(pw),5))
print(en[0])
en_integrated = [en[0] - (1/3600)*np.trapz(pw[:i],t[:i]) for i in range(len(pw))]
print(en_integrated)


plt.plot(t,pw)
plt.plot(t,en)
plt.plot(t,en_integrated)

plt.show()
