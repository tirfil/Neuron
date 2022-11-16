# half precision floating point (FP16)
import struct
import random as rd

maxi = 65504

def fp16(num):
    s0 = ''
    for c in struct.pack('!e', num):
        s0 += '{:0>8b}'.format(c)
    return s0
    
def gen_fp16(lmaxi):
    while True:
        a = rd.random()*lmaxi
        if (rd.random() > .5):
            a = -a
        if (a < lmaxi and a > -lmaxi):
            return (fp16(a),a)
            
def gen_data():
    num = int(rd.random()*100)
    lmaxi = int(maxi/num)
    data=[]
    summ = 0
    for i in range(num):
        (f,d) = gen_fp16(lmaxi)
        data.append(f)
        summ += d
    fs = fp16(summ)
    return (data,fs)
    
def gen_acc():
    arr, res = gen_data()
    for i in arr:
        print(i)
    print()
    print(res)
    print()    
    
if __name__ == "__main__":
    
    for i in range(10):
        gen_acc()
