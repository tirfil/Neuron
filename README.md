
__Serial neuron implementation__

Data format: floating point 16 bit

![principle](neuron.png)

Selector module selects data coming from multiplier output or from FIFO to supply the two inputs of the next addition.  
Adder and multiplier are pipelining version.
