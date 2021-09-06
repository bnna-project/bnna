library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testbench is
end;

architecture Behavioralim of testbench is

component BNN is
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
	dataOut: out std_logic_vector(1023 downto 0);
	bnn_rdy: out std_logic
	
	
  );
end component;

signal en_A, en_B, en_T, start, bnn_rdy, outBufferIn: std_logic;
signal clk: std_logic:= '0';
signal len, dep, wid: Integer;
signal Data_A, Data_B, dataOut: std_logic_vector(1023 downto 0);
signal Data_T: std_logic_vector(15 downto 0);



begin

testInput: BNN port map( 
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
	dataOut,
	bnn_rdy
	);
	
	--std_logic_vector(to_unsigned(1000000000, 1024));
	process 
    begin
	len <= 9;
	wid <= 1;
	dep <= 3;
	Data_A <= std_logic_vector(to_unsigned(0, 1015)) & "101110001";
	Data_B <= std_logic_vector(to_unsigned(0, 1015)) & "101111111";
	Data_T <= "1111111111111111";
	en_A <= '1';
	en_B <= '1';
	en_T <= '1';
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	en_A <= '0';
	Data_B <= std_logic_vector(to_unsigned(0, 1015)) & "010000000";
	Data_T <= "0000000000000111";
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	Data_B <= std_logic_vector(to_unsigned(0, 1015)) & "101101100";
	Data_T <= "0000000000001111";
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
	start <= '0';
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
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;




	

	wait;
	end process;
end;
