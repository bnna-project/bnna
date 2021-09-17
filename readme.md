# BNN Accelerator

![bnn_acceler](https://user-images.githubusercontent.com/88595269/132109786-aab49aa2-564d-4334-88f9-b0abbc07dc69.png)


## Requirements
* **GHDL**
* **GTKWave**
* **VHDL**

## Quick Instruction

### cloning repository

      $ git clone https://github.com/bnna-project/bnna.git  
      $ cd bnna  

### compiling VHDL code and looking on wave diagrams in GTKWave

      $ ghdl -s test_file.vhdl                 #Syntax Check  
      $ ghdl -a test_file.vhdl                 #Analyse  
      $ ghdl -e test_file.vhdl                 #Build   
      $ ghdl -r test_file --vcd=testbench.vcd  #VCD-Dump  
      $ gtkwave testbench.vcd                  #Start GTKWave  

Also you can compile and look on wave diagrams in GTKWave with command  
  
      $ bash script.sh test_file.vhdl test_file_testbench.vhdl  
 
Last file must be **testbench** !!! 

### auto compiling the project
In the compile folder is a script to compile all the components automatically. You can use it like this:

      $ cd compile
      $ bash auto_compile.sh

After this you just have to compile the test benches you want to use. For example like this (you should still be in the compile folder):

      $ bash script.sh ../BNNA/tb_presentation.vhdl

## References

1. FP-BNN:  Binarized  neural  network  on  FPGA  
  https://www.sciencedirect.com/science/article/abs/pii/S0925231217315655

2. Stochastic Computing for Hardware Implementationof Binarized Neural Networks  
  https://arxiv.org/abs/1906.00915

3. FINN: A Framework for Fast, Scalable Binarized Neural Network Inference  
  https://arxiv.org/abs/1612.07119

