import numpy as np
import random as rd

maxi = 65504

def gen_acc():
    num = int(rd.random()*100)
    lmaxi = int(maxi/num)
    data=[]
    for i in range(num):
        a = rd.random()*lmaxi
        if (rd.random() > .5):
            a = -a
        data.append(a)

    npa = np.array(data,dtype='f2')
    npsum = np.sum(data,dtype='f2')
    npsum0 =  np.array([npsum],dtype='f2')

    tab0 = ['{0:016b}'.format(h) for h in npa.view(dtype='u2')]
    for item in tab0:
        print(item)
    tab1 = ['{0:016b}'.format(h) % h for h in npsum0.view(dtype='u2')]
    print()
    print(tab1[0])
    print()    
    
if __name__ == "__main__":
    
    for i in range(10):
        gen_acc()



    
