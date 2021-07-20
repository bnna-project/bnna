library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reset_unit_tb is
end reset_unit_tb;

architecture behavior of reset_unit_tb is

  component reset_unit
  port(
    buffer_reset : in std_logic;
    reg_reset : in std_logic_vector(2 downto 0);
    clk : in std_logic;
    reset_reg : out std_logic;
    reset_PE1 : out std_logic;
    reset_PE2 : out std_logic;
    reset_PE3 : out std_logic;
    reset_PE4 : out std_logic;
    out_result : out std_logic
  );
  end component;
  
  signal buffer_reset,clk : std_logic;
  signal reg_reset: std_logic_vector(2 downto 0);
  signal reset_reg,reset_PE1,reset_PE2,reset_PE3,reset_PE4,out_result: std_logic;
  
begin
    reset_unit0: reset_unit port map(buffer_reset,reg_reset,clk,reset_reg,reset_PE1,reset_PE2,reset_PE3,reset_PE4,out_result);

  process begin
    buffer_reset <= '1';
    clk <= '0';
	wait for 10 ns;
	  buffer_reset <= '0';
    reg_reset <= "000";
  	clk <= '1';
	wait for 10 ns;
     clk <= '0';
  wait for 10 ns;
     reg_reset <= "001";
     clk <= '1';
     wait for 10 ns;
     clk <= '0';
  wait for 10 ns;
     reg_reset <= "010";
     clk <= '1';
     wait for 10 ns;
     clk <= '0';
     wait for 10 ns;
     reg_reset <= "001";
     clk <= '1';
     wait for 10 ns;
  clk <= '0';
  wait for 10 ns;
     reg_reset <= "010";
     clk <= '1';
     wait for 10 ns;
     clk <= '0';
  wait for 10 ns;
     reg_reset <= "011";
     clk <= '1';
     wait for 10 ns;
     clk <= '0';
     wait for 10 ns;
     reg_reset <= "010";
     clk <= '1';
     wait for 10 ns;
     clk <= '0';
  wait for 10 ns;
     reg_reset <= "100";
     clk <= '1';
     wait for 10 ns;
     clk <= '0';
     wait for 10 ns;
    reg_reset <= "000";
  	clk <= '1';
	wait for 10 ns;
     clk <= '0';
  wait for 10 ns;
     reg_reset <= "111";
     clk <= '1';
    wait for 10 ns;
	wait for 10 ns;
	wait;
  end process;
  
end behavior;
