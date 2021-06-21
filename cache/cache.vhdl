library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.parameters.all;

entity cache is
    port(
        reset: in std_logic;
        clk: in std_logic;
        input1: in std_logic_vector(NUMBER_OF_BITs_out -1 downto 0);
        output1: out std_logic_vector(31 downto 0);
        ready: out std_logic
    );
end cache;

architecture bhv of cache is
    --type register is slv(31 downto 0);
    signal cache_register: std_logic_vector(31 downto 0);
begin
    cache_register <= x"00000000";
    process(input1)
    variable temp: unsigned(31 downto 0) := x"00000000";
    begin
        ready <= '0';

        if(reset = '1') then
            cache_register <= x"00000001";
        end if;
        temp := (x"00000000" + unsigned(input1)) + (x"00000000" + unsigned(input1)) + unsigned(cache_register);
        cache_register <= std_logic_vector(temp);
        --cache_register <= std_logic_vector(unsigned(cache_register) + (x"2" * unsigned(input1)) - x"3");
        output1 <= cache_register;
        --cache_register <= x"0000FFFF";
        --output1 <= x"0000000F";

        ready <= '1';

    end process;
end bhv;


