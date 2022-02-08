# BNNA
The BNNA consists of:
- 1 Controller
- 4 processing Unit
- 1 OutputBuffer

## Usage

When the 'bnn_rdy' output is '1'.  
Data can be push into the BNNA.  
Data_A for input Data.  
Data_B for Weight Matrix.  
Data_T for thresholds.  
every clock pluse on the rising edge one vector from this ports will be read  
if the enable read bit is set.  
The vector must be delivered inorder  
Befor the start the length of the input vector must be set to the 'len' input.  
The depth of the Weight matrix must be set to the 'dep' input  
The width of the Data shoud be '1'  
To start the caculation the 'start' bit must be set to '1' for one rising edge.  
The result will be set to the 'dataOut' port  

