library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.parameters.all;

entity processing_unit is
    port(
        clk: in std_logic; --clock
        reset: in std_logic; --reset for cache
        data: in std_logic_vector(NUMBER_OF_W_A -1 downto 0); --data vector
        weight: in std_logic_vector(NUMBER_OF_W_A -1 downto 0); --weight vector
        treshold: in std_logic_vector(7 downto 0); --treshold value
        output1: out std_logic; --output (0 or 1)
        output2 : out std_logic
    );
    end;

    architecture structure of processing_unit is
        signal output_comp : std_logic;

        component xnor_2
        port(
            data: in std_logic;
            weight: in std_logic;
            output1: out std_logic
        );
        end component;

        component pop_count
        port(
            input1: in std_logic_vector(NUMBER_OF_W_A -1 downto 0);
            output1: out std_logic_vector(NUMBER_OF_BITs_out downto 0)
        );
        end component;

        component cache
        port(
            reset: in std_logic;
            clk: in std_logic;
            input1: in std_logic_vector(NUMBER_OF_BITs_out downto 0);
            output1: out std_logic_vector(7 downto 0);
            ready: out std_logic
        );
        end component;

        component comparator
        port(
            a : in std_logic_vector(7 downto 0);
            b : in std_logic_vector(7 downto 0);
            a_comp_b : out std_logic
        );
        end component;

        signal popcount_in: std_logic_vector(NUMBER_OF_W_A -1 downto 0);
        signal popcount_out: std_logic_vector(NUMBER_OF_BITs_out downto 0);
        signal cache_out: std_logic_vector(7 downto 0);

        begin
            --8 xnor gates connected to one popcount with 8 inputs and 3 outputs
            gen: for i in 0 to (NUMBER_OF_W_A -1) generate
            xnori: xnor_2 port map(data=>data(i), weight=>weight(i), output1=>popcount_in(i));
            end generate;

            pop_count1: pop_count port map(
                input1 => popcount_in,
                output1 => popcount_out
            );

            cache1: cache port map(
                reset,
                clk,
                input1 => popcount_out,
                output1 => cache_out
            );

            comparator1: comparator port map(
                a => cache_out,
                b => treshold,
                a_comp_b => output_comp
            );
                process(output_comp)begin
                    case output_comp is
                        when '0' => output2 <= '1';
                        when '1' => output2 <= '1';
                        when others => output2 <= '-';
                    end case;
                end process;
                
                output1 <= output_comp;

            end;
