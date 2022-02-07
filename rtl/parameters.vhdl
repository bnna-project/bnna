library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
        

package parameters is
    function f_log2(x:positive)return natural;
end package;

package body parameters is
    function f_log2(x:positive) return natural is
        variable i : natural;
        begin
            i := 0;
            while(2**i < x) and i < 31 loop
                i:= i + 1;
            end loop;
            return i;
        end function;

    constant NUMBER_OF_W_A : natural := 8; -- W: weights, A : activates;
    constant NUMBER_OF_BITs_out : natural := f_log2(NUMBER_OF_W_A);

    -- An alias is an alternative name for an existing object (signal, variable or constant).
    alias sl is std_logic;              
    alias slv is std_logic_vector;
end package body parameters;
