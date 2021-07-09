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
        output1: out std_logic --output (0 or 1)
    );
    end;

    architecture structure of processing_unit is
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
            output1: out std_logic_vector(NUMBER_OF_BITs_out -1 downto 0)
        );
        end component;

        component cache
        port(
            reset: in std_logic;
            clk: in std_logic;
            input1: in std_logic_vector(2 downto 0);
            output1: out std_logic_vector(31 downto 0);
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
        signal popcount_out: std_logic_vector(NUMBER_OF_BITs_out -1 downto 0);
        signal cache_out: std_logic_vector(31 downto 0);

        begin
            --8 xnor gates connected to one popcount with 8 inputs and 3 outputs
            xnor0: xnor_2 port map(
                data => data(0),
                weight => weight(0),
                output1 => popcount_in(0)
            );

            xnor1: xnor_2 port map(
                data => data(1),
                weight => weight(1),
                output1 => popcount_in(1)
            );

            xnor2: xnor_2 port map(
                data => data(2),
                weight => weight(2),
                output1 => popcount_in(2)
            );

            xnor3: xnor_2 port map(
                data => data(3),
                weight => weight(3),
                output1 => popcount_in(3)
            );

            xnor4: xnor_2 port map(
                data => data(4),
                weight => weight(4),
                output1 => popcount_in(4)
            );

            xnor5: xnor_2 port map(
                data => data(5),
                weight => weight(5),
                output1 => popcount_in(5)
            );

            xnor6: xnor_2 port map(
                data => data(6),
                weight => weight(6),
                output1 => popcount_in(6)
            );

            xnor7: xnor_2 port map(
                data => data(7),
                weight => weight(7),
                output1 => popcount_in(7)
            );

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
                a => cache_out(7 downto 0),
                b => treshold,
                a_comp_b => output1
            );

            end;
