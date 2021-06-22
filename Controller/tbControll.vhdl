library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tbControll is
end tbControll;

architecture Behavioralim of tbControll is

  component controll
  port(
    clk: in std_logic;
    we: in std_logic;
    dataIn: in std_logic_vector(7 downto 0);
	weigthIn: in std_logic_vector(7 downto 0);
    dwOut: buffer std_logic_vector(15 downto 0);
    adressData: out std_logic_vector (31 downto 0)
  );
  end component;
  

  signal weigth: std_logic_vector(7 downto 0);
  signal data: std_logic_vector(7 downto 0);
  signal writ, clkIn: std_logic;

begin
  tes: controll port map(clk => clkIn, we => writ, dataIn => data, weigthIn => weigth);

  process begin
    clkIn <= '0';
	writ <= '1';
	data <= x"f0";
	weigth <= x"0f";
	wait for 10 ns;
	clkIn <= '1';
	wait for 10 ns;
	clkIn <= '0';
	wait for 10 ns;
	clkIn <= '1';
	wait for 10 ns;
	wait;
  end process;
  
end Behavioralim;