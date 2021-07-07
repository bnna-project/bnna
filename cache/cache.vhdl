library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.parameters.all;

entity cache is
    port(
        reset: in std_logic;
        clk: in std_logic;
        input1: in std_logic_vector(2 downto 0);
        output1: out std_logic_vector(31 downto 0);
        ready: out std_logic
    );
end cache;

architecture bhv of cache is
    signal cache_register: std_logic_vector(31 downto 0);
begin
    process(clk)
    variable temp: unsigned(31 downto 0) := b"00000000000000000000000000000000";
    begin
        if rising_edge(clk) then
            ready <= '0';

            if(reset = '1') then
                cache_register <= b"00000000000000000000000000000000";
            else
                temp := resize(unsigned(input1), cache_register'length);
                temp := temp + unsigned(cache_register);
            end if;

            cache_register <= std_logic_vector(temp);
            output1 <= cache_register;

            ready <= '1';
        end if;

    end process;
end bhv;


