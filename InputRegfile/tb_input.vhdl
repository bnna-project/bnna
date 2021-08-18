library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testbench is
end;

architecture Behavioralim of testbench is

component inputController is
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
	resetPE: out std_logic_vector(2 downto 0);
	o_A,o_B: buffer std_logic_vector(31 downto 0);
	o_T: buffer std_logic_vector(63 downto 0);
	outBufferIn: in std_logic
  );
end component;

signal en_A, en_B, en_T, start, bnn_rdy, outBufferIn: std_logic;
signal clk: std_logic:= '0';
signal len, dep, wid: Integer;
signal resetPE: std_logic_vector(2 downto 0);
signal Data_A, Data_B: std_logic_vector(1023 downto 0);
signal Data_T: std_logic_vector(15 downto 0);
signal o_A, o_B :std_logic_vector(31 downto 0);
signal o_T: std_logic_vector(63 downto 0);


begin

testInput: inputController port map( 
	clk,
	Data_A,
	en_A,
	Data_B,
	en_B,
	Data_T,
	en_T,
	start,
	len,
	dep,
	wid,
	bnn_rdy,
	resetPE,
	o_A,
	o_B,
	o_T,
	outBufferIn
	);
	--std_logic_vector(to_unsigned(1000000000, 1024));
	process 
    begin
	len <= 16;
	wid <= 2;
	dep <= 2;
	Data_A <= x"dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd";
	Data_B <= std_logic_vector(to_unsigned(0, 1024));
	Data_T <= ( others => '0');
	en_A <= '1';
	en_B <= '1';
	en_T <= '1';
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	en_A <= '0';
	en_B <= '0';
	en_T <= '0';
	start <= '1';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;



	

	wait;
	end process;
end;
