library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.parameters.all;

entity BNN is 

  port(
	clk: in std_logic; --clock
	Data_A:in std_logic_vector(1023 downto 0); --Input of data 
	en_A: in std_logic; -- write enable for data
	Data_B:in std_logic_vector(1023 downto 0); --Input of weigths
	en_B: in std_logic; -- write enable for write
	Data_T:in std_logic_vector(15 downto 0); -- Input of tresholds
	en_T: in std_logic; -- write enable for treshold
	start: in std_logic;-- signal to start caculation
	len:in Integer; -- length of the vectors
	dep:in Integer; -- rows of the weigth matrix
	wid:in Integer; -- colums of the input data (should be one)
	dataOut: out std_logic_vector(1023 downto 0); --results
	bnn_rdy: out std_logic -- indicates whether the controller is ready to accept data
	
  );
end;
--puts all moduls together
architecture struc of BNN is

component inputController --Controller
  port(
	clk: in std_logic;
	Data_A:in std_logic_vector(1023 downto 0);
	en_A: in std_logic;
	Data_B:in std_logic_vector(1023 downto 0);
	en_B: in std_logic;
	Data_T:in std_logic_vector(15 downto 0);
	en_T: in std_logic;
	start: in std_logic;
	len:in Integer;
	dep:in Integer;
	wid:in Integer;
	bnn_rdy: out std_logic;
	resetPE: out std_logic_vector(4 downto 0);
	o_A,o_B: buffer std_logic_vector(31 downto 0);
	o_T: buffer std_logic_vector(63 downto 0);
	outBufferIn: in std_logic
	
  );
end component;



component outputBuffer --outputBuffer
  port (
    clk: in std_logic;
    reset: in std_logic;
    dataOut: out std_logic_vector(1023 downto 0);
    dataIn: in std_logic_vector(3 downto 0);
	enableIn: in std_logic_vector(3 downto 0);
	dep, wid : in integer;
	start:in std_logic;
	outputAns: out std_logic
    
  );
end component;



	
component processing_unit --processing units
    port(
        clk: in std_logic; --clock
        reset: in std_logic; --reset for cache
        data: in std_logic_vector(NUMBER_OF_W_A -1 downto 0); --data vector
        weight: in std_logic_vector(NUMBER_OF_W_A -1 downto 0); --weight vector
        treshold: in std_logic_vector(15 downto 0); --treshold value
        output1: out std_logic; --output (0 or 1)
        output2 : out std_logic
    );
    end component;


signal o_A_Si, o_B_Si:std_logic_vector(31 downto 0);
signal resetPE_Si :std_logic_vector(4 downto 0);
signal o_T_Si :std_logic_vector(63 downto 0);
signal outBufferResetA_Si :std_logic;
signal dataIn_Buffer_Si, enableIn_Buffer_Si :std_logic_vector(3 downto 0);

begin

input :  inputController  port map(

		clk => clk,
		Data_A => Data_A,
		en_A => en_A,
		Data_B => Data_B,
		en_B => en_B,
		Data_T => Data_T,
		en_T => en_T,
		start => start,
		len => len,
		dep => dep,
		wid => wid,
		bnn_rdy => bnn_rdy,
		resetPE => resetPE_Si,
		o_A => o_A_Si,
		o_B => o_B_Si,
		o_T => o_T_Si,
		outBufferIn => outBufferResetA_Si
	);

	
output : outputBuffer port map(

		clk => clk,
		reset => resetPE_Si(4),
		dataOut => dataOut,
		dataIn => dataIn_Buffer_Si,
		enableIn => enableIn_Buffer_Si,
		dep => dep,
		wid => wid,
		start => start,
		outputAns => outBufferResetA_Si

	);
	
PE1 : processing_unit port map(
		
		clk => clk,
        reset => resetPE_Si(0),
        data => o_A_Si(7 downto 0),
        weight => o_B_Si(7 downto 0),
        treshold => o_T_Si(15 downto 0),
        output1 => dataIn_Buffer_Si(0),
		output2 => enableIn_Buffer_Si(0)
	);
	
PE2 : processing_unit port map(
		
		clk => clk,
        reset => resetPE_Si(1),
        data => o_A_Si(15 downto 8),
        weight => o_B_Si(15 downto 8),
        treshold => o_T_Si(31 downto 16),
        output1 => dataIn_Buffer_Si(1),
		output2 => enableIn_Buffer_Si(1)
	);
	
PE3 : processing_unit port map(
		
		clk => clk,
        reset => resetPE_Si(2),
        data => o_A_Si(23 downto 16),
        weight => o_B_Si(23 downto 16),
        treshold => o_T_Si(47 downto 32),
        output1 => dataIn_Buffer_Si(2),
		output2 => enableIn_Buffer_Si(2)
	);
	
	
PE4 : processing_unit port map(
		
		clk => clk,
        reset => resetPE_Si(3),
        data => o_A_Si(31 downto 24),
        weight => o_B_Si(31 downto 24),
        treshold => o_T_Si(63 downto 48),
        output1 => dataIn_Buffer_Si(3),
		output2 => enableIn_Buffer_Si(3)
	);



end;