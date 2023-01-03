# pip install --user matplotlib-backend-kitty
# export MPLBACKEND='module://matplotlib-backend-kitty'

import numpy as np
import pandas as pd

import matplotlib
matplotlib.use('module://matplotlib-backend-kitty')
import matplotlib.pyplot as plt

n = 10000
df = pd.DataFrame({'x': np.random.randn(n), 'y': np.random.randn(n)})
df.plot.hexbin(x='x', y='y', gridsize=20)

plt.show()
