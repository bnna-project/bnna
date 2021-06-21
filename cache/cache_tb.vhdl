library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.parameters.all;

entity cache_tb is
end cache_tb;

architecture test of cache_tb is
    signal reset: std_logic;
    signal clk: std_logic;
    signal input1: std_logic_vector(NUMBER_OF_BITs_out -1 downto 0);
    --signal output1: std_logic_vector(31 downto 0);
    --signal ready: std_logic;

    component cache port(
        reset: in std_logic;
        clk: in std_logic;
        input1: in std_logic_vector(NUMBER_OF_BITs_out -1 downto 0);
        output1: out std_logic_vector(31 downto 0);
        ready: out std_logic
    );
    end component;

    for all: cache use entity work.cache(bhv);

    begin
        process begin
            clk <= '0';
            input1 <= b"000";
            reset <= '0';
            wait for 10 ns;
            input1 <= b"011";
            clk <= '1';
            wait for 10 ns;
            clk <= '0';
            wait for 10 ns;
            wait;
        end process;
        --cache0: cache port map (input1 => input1, output1 => output1, reset => reset, clk => clk, ready => ready);
        cache0: cache port map (input1 => input1, reset => reset, clk => clk);
end test;    
        