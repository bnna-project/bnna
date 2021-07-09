library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_tb is
end controller_tb;

architecture behavior of controller_tb is

  component controller
  port(
    clk: in std_logic;
    reset: in std_logic; 
    write: in std_logic;
    parameter_vec: in std_logic_vector(7 downto 0);
    weigth_vec: in std_logic_vector(7 downto 0);
    output: out std_logic_vector(15 downto 0);
    adress_out: out std_logic_vector (31 downto 0)
  );
  end component;
  
  signal clk,reset,write: std_logic;
  signal parameter_vec, weigth_vec: std_logic_vector(7 downto 0);
  signal output: std_logic_vector(15 downto 0);
  signal adress_out: std_logic_vector(31 downto 0);

begin
  controller0: controller port map(clk,reset,write,parameter_vec,weigth_vec, output, adress_out);

  process begin
    clk <= '0';
    reset <= '1';
	write <= '1';
	parameter_vec <= "00000011";
	weigth_vec <= "11000000";
	wait for 10 ns;
	clk <= '1';
    reset <= '0';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	wait;
  end process;
  
end behavior;