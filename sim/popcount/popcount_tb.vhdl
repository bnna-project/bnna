library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity popcount_tb is
--generic(NUMBER_OF_BITs :INTEGER := 4);
end popcount_tb;

architecture test of popcount_tb is

    signal rst : std_logic;
    signal clk : std_logic := '0';
    signal stream_i : std_logic_vector(63 downto 0);
    signal stream_o : std_logic_vector(8 downto 0);
    signal i_val  : std_logic;
    signal o_val  : std_logic;

    signal int_rand1 : integer;
    signal int_rand2 : integer;

begin

    popcount: entity work.popcount(Behavioral)
    port map (
        rst       => rst,
        clk       => clk,
        stream_i  => stream_i,
        stream_o  => stream_o,
        i_val     => i_val,
        o_val     => o_val
    );

    clk <= not clk after 2 ns;

    reset_process : process begin
        rst <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        rst <= '0';
        wait;
    end process;

    input_process : process is
        variable rand1: real;
        variable rand2: real;
        variable seed1, seed2: positive;
        variable seed3: positive := 1;
        variable seed4: positive := 2;
        variable range_of_rand: integer := 2**64;

    begin
        i_val <= '0';
        
        wait until rst = '0';
        wait until rising_edge(clk);

        i_val <= '1';

        for i in 0 to 2**4 loop
            UNIFORM(seed1, seed2, rand1);
            int_rand1 <= integer(trunc(rand1*2**(31.0)));
            stream_i(31 downto 0) <= std_logic_vector(to_unsigned(int_rand1, 32));
            UNIFORM(seed3, seed4, rand2);
            int_rand2 <= integer(trunc(rand2*2**(31.0)));
            stream_i(63 downto 32) <= std_logic_vector(to_unsigned(int_rand2, 32));
            wait until rising_edge(clk);
        end loop;

        i_val <= '0';
    end process;

end test;
