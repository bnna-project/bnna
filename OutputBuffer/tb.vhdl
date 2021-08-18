library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testbench is
end;

architecture Behavioralim of testbench is

component outputBuffer is
  port (
    clk: in std_logic;
    reset: in std_logic;
    dataOut: out std_logic_vector(1023 downto 0);
    dataIn: in std_logic_vector(7 downto 0);
	dep, wid : in integer;
	start:in std_logic;
	outputAns: out std_logic
    
  );
end component;

signal clk, reset, start, outputAns: std_logic;
signal dep, wid : integer;
signal dataOut: std_logic_vector(1023 downto 0);
signal dataIn: std_logic_vector(7 downto 0);


begin

testInput: outputBuffer port map(
		clk,
		reset,
		dataOut,
		dataIn,
		dep, 
		wid,
		start,
		outputAns

	);
	
	process 
    begin
	clk <= '0';
	dep <= 2;
	wid <= 2;
	start <= '1';
	dataIn <= "00000000";
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	start <= '0';
	dataIn <= "10101111";
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	dataIn <= "00000000";
	reset <= '1';
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
