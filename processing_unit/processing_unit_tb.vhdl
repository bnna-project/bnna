library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.parameters.all;

entity processing_unit_tb is
end processing_unit_tb;

architecture test of processing_unit_tb is
    signal reset: std_logic;
    signal clk: std_logic;
    signal data: std_logic_vector(NUMBER_OF_W_A -1 downto 0);
    signal weight: std_logic_vector(NUMBER_OF_W_A -1 downto 0);
    signal treshold: std_logic_vector(15 downto 0);
    signal output1: std_logic;
    signal output2 : std_logic;

    component processing_unit port(
        clk: in std_logic; --clock
        reset: in std_logic; --reset for cache
        data: in std_logic_vector(NUMBER_OF_W_A -1 downto 0); --data vector
        weight: in std_logic_vector(NUMBER_OF_W_A -1 downto 0); --weight vector
        treshold: in std_logic_vector(15 downto 0); --treshold value
        output1: out std_logic; --output (0 or 1)
        output2 : out std_logic
    );
    end component;

    begin
        process begin
            clk <= '0';
            reset <= '1';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            reset <= '0';
            clk <= '0';
            data <= b"00011011";
            weight <= b"00010111";
            treshold <= x"0002";
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            wait;
        end process;
        processing_unit0: processing_unit port map(clk, reset, data, weight, treshold, output1, output2);
end test;    
        