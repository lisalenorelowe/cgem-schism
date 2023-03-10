import subprocess
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime, timedelta

def cgem_plot1D(grid,which_var):
    print("Plotting CGEM variable",which_var)
    results = subprocess.run(['./CGEM.exe',which_var],stdout=subprocess.PIPE, text=True)
    ar = results.stdout.splitlines()
    result = np.array(list(map(str.strip,ar))).astype(float)
    time = cgem_timearray(grid)
    fig, ax = plt.subplots(figsize=(15, 3))
    ax.plot(time,result,label=which_var)
    ax.legend(loc='upper left')
    
def cgem_getvar(which_var):
    print("Calculating CGEM variable",which_var)
    results = subprocess.run(['./CGEM.exe',which_var],stdout=subprocess.PIPE, text=True)
    ar = results.stdout.splitlines()
    result = np.array(list(map(str.strip,ar))).astype(float)
    return result
        
def cgem_tstart(grid):
    iYrS = grid.get('hydro').get('iyrs')
    iMonS = grid.get('hydro').get('imons')
    iDayS = grid.get('hydro').get('idays')
    iHrS = grid.get('hydro').get('ihrs')
    iMinS = grid.get('hydro').get('imins')
    iSecS = grid.get('hydro').get('isecs')
    T = datetime(iYrS, iMonS, iDayS, iHrS, iMinS, iSecS)
    return T

def cgem_tend(grid):
    iYrE = grid.get('hydro').get('iyre')
    iMonE = grid.get('hydro').get('imone')
    iDayE = grid.get('hydro').get('idaye')
    iHrE = grid.get('hydro').get('ihre')
    iMinE = grid.get('hydro').get('imine')
    iSecE = grid.get('hydro').get('isece')
    T = datetime(iYrE, iMonE, iDayE, iHrE, iMinE, iSecE)
    return T

def cgem_timearray(grid):
    results = subprocess.run(['./CGEM.exe','A'],stdout=subprocess.PIPE, text=True)
    ar = results.stdout.splitlines()
    result = np.array(list(map(str.strip,ar))).astype(float)
    Tstart = cgem_tstart(grid)
    dtout = grid.get('hydro').get('dt')
    dt = timedelta(seconds=dtout)
    res = []
    for x in range (0, len(result)):
        res.append(Tstart+x*dt)
    return res


def cgem_plotks(grid,which_var):
    print("Plotting CGEM variable",which_var)
    time = cgem_timearray(grid)
    km = grid.get('hydro').get('km')
    fig, ax = plt.subplots(figsize=(30, 5))
    for i in range (1,km+1):
        x = str(i)
        results = subprocess.run(['./CGEM.exe',which_var,x],stdout=subprocess.PIPE, text=True)
        ar = results.stdout.splitlines()
        result = np.array(list(map(str.strip,ar))).astype(float)
        label = which_var + " k=" + x
        ax.plot(time,result,label=label)
    ax.legend(loc='upper left')
    
    
def cgem_plotAs(grid,cgem):
    print("Plotting Phytoplankton Groups")
    time = cgem_timearray(grid)
    nospA = cgem.get('nosp').get('nospA')
    fig, ax = plt.subplots(figsize=(30, 5))
    for i in range (1,nospA+1):
        x = 'A' + str(i)
        results = subprocess.run(['./CGEM.exe',x],stdout=subprocess.PIPE, text=True)
        ar = results.stdout.splitlines()
        result = np.array(list(map(str.strip,ar))).astype(float)
        label = x + " k=1"
        ax.plot(time,result,label=label)
    ax.legend(loc='upper left')
