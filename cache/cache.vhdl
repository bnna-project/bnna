library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.parameters.all;

entity cache is
    port(
        reset: in std_logic;
        clk: in std_logic;
        input1: in std_logic_vector(3 downto 0);
        output1: out std_logic_vector(7 downto 0);
        ready: out std_logic
    );
end cache;

architecture bhv of cache is
    signal cache_register: std_logic_vector(7 downto 0);
begin
    process(clk)
    variable tin: unsigned(7 downto 0) := b"00000000";
    variable tcache: unsigned(7 downto 0) := b"00000000";
    begin
        if rising_edge(clk) then
            ready <= '0';
            --if reset bit is 1 only reset the cache.
            if(reset = '1') then
                cache_register <= b"00000000";
            --else add input to existing value in the cache.
            else
                --remove the sign bit from the cache and increase to the size of cache_register
                tin := resize(unsigned(input1(2 downto 0)), cache_register'length);
                tcache := unsigned(cache_register);
                --if value of the input is negative some 1s have to be inserted because of 2'S complement
                if(input1(3) = '1') then
                    tin := tin or b"11111000";
                end if;
                --finally add input and value in the cache.
                tin := tin + tcache;
                --write result to cache
                cache_register <= std_logic_vector(tin);
            end if;
            ready <= '1';
        end if;

        --output on falling edge
        if falling_edge(clk) then
            ready <= '0';
            if(reset = '0') then
                output1 <= cache_register;
            end if;
            ready <= '1';
        end if;
    end process;
end bhv;


