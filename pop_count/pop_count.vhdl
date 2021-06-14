library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.parameters.all;

entity pop_count is
    --generic(NUMBER_OF_BITs : INTEGER := 4); --number of bits pop_count output
    port(
        input1 : in slv(NUMBER_OF_W_A -1 downto 0);
        output1 : out slv(NUMBER_OF_BITs_out-1  downto 0)
    );
    end pop_count;

architecture rtl of pop_count is
    begin
        process(input1)
            variable count : unsigned (NUMBER_OF_BITs_out-1 downto 0);
            variable signal_concat : unsigned (NUMBER_OF_BITs_out -2 downto 0); 
            begin
                count := (others => '0');
                signal_concat :=(others => '0');
                for i in 0 to NUMBER_OF_W_A - 1 loop
                    count := count + (signal_concat & input1(i));    
                end loop ; 
                output1 <= slv(count);
            end process;
    end rtl;