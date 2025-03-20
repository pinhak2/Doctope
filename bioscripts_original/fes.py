#!/usr/bin/python

# this is to calculate the distribution of a dynamic variable 
# one gives the input file and the min and max of the variable and the number of 
# required interval devisions
# 
# the input file should contain only two columns:
# TIME DATA

from numpy import genfromtxt
import sys,string
import numpy as np
import math
from numpy.random import uniform, seed
from matplotlib.mlab import griddata
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
from pylab import *
from matplotlib import *
from numpy.random import randn
from matplotlib.patches import Patch
from pylab import *
from optparse import OptionParser




##### Variable Initializations ##########

def fes(infilename1, infilename2,_i1,_i2 ,_temp ,outfilename, fontsize_tick):

    data_rg = genfromtxt(infilename1,skip_header=22, 
                    dtype={'names':['time', 'rg','rgx','rgy','rgz'],
                   'formats':[int,float,float,float,float]})

    data_rmsd = genfromtxt(infilename2,skip_header=13, 
                    dtype={'names':['time', 'rmsd'],
                   'formats':[int,float]})


    data1_min = data_rg['rg'].min(axis=0)
    data1_max = data_rg['rg'].max(axis=0)
    data2_min = data_rmsd['rmsd'].min(axis=0)
    data2_max = data_rmsd['rmsd'].max(axis=0)  


    np.savetxt('rg_rmsd.out', np.array([data_rg['rg'],data_rmsd['rmsd']] ).transpose(), fmt='%f %f', delimiter=',')


    _minv1 = data1_min
    _maxv1 = data1_max
    _minv2 = data2_min 
    _maxv2 = data2_max

    infilename='rg_rmsd.out'



    ifile = open(infilename,'r')     # open file for reading
    ofile = open(outfilename,'w')    # open file for writing

    i1 = int(_i1)
    i2 = int(_i2)

    minv1 = float(_minv1)
    maxv1 = float(_maxv1)
    minv2 = float(_minv2)
    maxv2 = float(_maxv2)

    V = np.zeros((i1,i2))
    DG = np.zeros((i1,i2))


    I1 = maxv1 - minv1
    I2 = maxv2 - minv2

    kB = 3.2976268E-24
    An = 6.02214179E23
    T = float(_temp)


##########################################

    for line in ifile:
        v1 = float(line.split()[0])
        for x in range(i1):
		    if v1 <= minv1+(x+1)*I1/i1 and v1 > minv1+x*I1/i1:
			    v2 = float(line.split()[1])
			    for y in range(i2):
				    if v2 <= minv2+(y+1)*I2/i2 and v2 > minv2+y*I2/i2:
					    V[x][y] = V[x][y] +1
					    break
			    break	

		
##### Finding the maximum          
    P = list()
    for x in range(i1):
	    for y in range(i2):
	    	P.append(V[x][y])

    Pmax = max(P)
#####

    LnPmax = math.log(Pmax) 
	
    for x in range(i1):
        for y in range(i2):
	        if V[x][y] == 0:
		        DG[x][y] = 10
        		continue
        	else:
		        DG[x][y] = -0.001*An*kB*T*(math.log(V[x][y])-LnPmax)

    for x in range(i1):
    	for y in range(i2):
    		ofile.write(str((2*minv1+(2*x+1)*I1/i1)/2) + "\t" + str((2*minv2+(2*y+1)*I2/i2)/2) + "\t" + str(DG[x][y])+"\n")
    		
    	ofile.write("\n")


    ofile.close()
    ifile.close()


    plots_fes(plt.cm.Spectral,output,data1_min,data1_max,data2_min,data2_max, fontsize_tick)
    plots_fes(plt.cm.Blues,output,data1_min,data1_max,data2_min,data2_max, fontsize_tick)
    plots_fes(plt.cm.RdYlGn,output,data1_min,data1_max,data2_min,data2_max, fontsize_tick)
    plots_fes(plt.cm.YlGnBu,output,data1_min,data1_max,data2_min,data2_max, fontsize_tick) 
    plots_fes(plt.cm.gnuplot,output,data1_min,data1_max,data2_min,data2_max, fontsize_tick)
    plots_fes(plt.cm.terrain,output,data1_min,data1_max,data2_min,data2_max, fontsize_tick)






def plots_fes(colorscale,outfilename,data1_min,data1_max,data2_min,data2_max, fontsize_tick):

    data_fes = genfromtxt(outfilename,skip_header=22, 
                    dtype={'names':['rg','rmsd','Dg'],
                   'formats':[float,float,float]})
    # make up data.
    #npts = int(raw_input('enter # of random points to plot:'))
    npts = np.shape(data_fes['rg'])[0]

    x = data_fes['rg']
    y = data_fes['rmsd']
    z = data_fes['Dg']

    # define grid.
    xi = np.linspace(data1_min,data1_max,npts)
    yi = np.linspace(data2_min,data2_max,npts)
    # grid the data.
    zi = griddata(x,y,z,xi,yi,interp='linear')
    # contour the gridded data, plotting dots at the nonuniform data points.
    CS = plt.contour(xi,yi,zi,15,linewidths=0.1,colors='k')

    # rainbow |

    CS = plt.contourf(xi,yi,zi,15,cmap=colorscale,
                  vmax=abs(zi).max(), vmin=-abs(zi).max())



    cb=plt.colorbar(orientation="vertical")
    #cb.set_label("Dg",fontsize=17)    
    for t in cb.ax.get_yticklabels():
         t.set_fontsize(fontsize_tick)    


    # plot data points.
    #plt.scatter(x,y,marker='o',c='b',s=5,zorder=10)
    plt.xlim(data1_min,data1_max)
    plt.ylim(data2_min,data2_max)


    
    plt.yticks( fontsize=fontsize_tick )    
    plt.xticks( fontsize=fontsize_tick )
    #plt.ylabel("RMSD",override)
    #plt.xlabel("RMSD",override)

    plt.title('Free Energy Surface')
    plt.show()




if __name__ == '__main__':

    # build option parser:
    class MyParser(OptionParser):
        def format_epilog(self, formatter):
            return self.epilog
    
    usage = "usage: python %prog [options] filename\n"    

    description = """
Free Energy Surface
"""

    epilog = """
for exemple:

python fes.py --rg_file rg.xvg --rmsd_file rmsd.xvg  --bin1 30  --bin2 30  --temp 310   --output outfile



"""

    parser = MyParser(usage, description=description,epilog=epilog)
    parser.add_option("--rg_file",  dest="rg_file", action="store",
                      help='input  ')

    parser.add_option("--rmsd_file",  dest="rmsd_file", action="store",
                      help='input  ')

    parser.add_option("--bin1",  dest="bin1", action="store",
                      help='input  ')

    parser.add_option("--bin2",  dest="bin2", action="store",
                      help='input  ')

    parser.add_option("--temp",  dest="temp", action="store",
                      help='input  ')

    parser.add_option("--fsize",  dest="fsize", action="store",
                      help='input  ')

    parser.add_option("--output",  dest="output", action="store",
                      help='output  ')




    (options, args) = parser.parse_args()

    if len(sys.argv) <3:
        parser.error("incorrect number of arguments. Use -h to help you.")
    
    output = options.output
    temp = options.temp
    bin1 = options.bin1
    bin2 = options.bin2
    rg_file = options.rg_file
    rmsd_file = options.rmsd_file
    fsize = options.fsize


    fes(rg_file, rmsd_file,bin1,bin2 ,temp ,output,fsize)

#diferent kind of color scale
#http://matplotlib.org/api/pyplot_summary.html?highlight=rainbow







