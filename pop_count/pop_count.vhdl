library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.parameters.all;

entity pop_count is
    port(
        input1  : in slv(NUMBER_OF_W_A -1 downto 0);
        output1 : out slv(NUMBER_OF_BITs_out  downto 0)
    );
    end pop_count;

architecture rtl of pop_count is
    begin
        process(input1)
            variable count          : unsigned (NUMBER_OF_BITs_out-1 downto 0);
            variable signal_concat  : unsigned (NUMBER_OF_BITs_out -2 downto 0);
            variable sum_pop        : unsigned(NUMBER_OF_BITs_out downto 0);
            variable number_b       : unsigned(NUMBER_OF_BITs_out downto 0);
            variable num_bits       : unsigned(NUMBER_OF_BITs_out downto 0);
            variable msb            : std_logic; 


            begin
                --popcount adds 1's from xnors outputs
                count := (others => '0');
                signal_concat :=(others => '0');
                for i in 0 to NUMBER_OF_W_A - 1 loop
                    count := count + (signal_concat & input1(i));    
                end loop ; 
                    
                    --after that should be used formel 2P-N, where P number of 1's and N - number of bits
                    sum_pop := (others => '0');
                    num_bits := (others => '0');

                    sum_pop := sum_pop + count + count;
                    num_bits := to_unsigned(NUMBER_OF_W_A,num_bits'length);

                        --if condition, N < 2P: 
                        --1. should be used general formel 2P - N;
                        --2. 2P + two_complement(number of bits)

                        if num_bits < sum_pop then
                            msb := '0';
                            output1 <=  std_logic_vector(sum_pop - unsigned(num_bits));
                            output1(NUMBER_OF_BITs_out) <= '0';
                        else
                            number_b := unsigned(not num_bits);
                            number_b := number_b + 1;
                            output1 <= std_logic_vector(sum_pop + number_b);
                            output1(NUMBER_OF_BITs_out) <= '1';
                                
                        end if;
            end process;
    end rtl;