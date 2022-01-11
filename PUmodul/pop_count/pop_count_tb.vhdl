library ieee;
use ieee.std_logic_1164.all;


entity pop_count_tb is
--generic(NUMBER_OF_BITs :INTEGER := 4);
end pop_count_tb;

architecture test of pop_count_tb is

    signal rst : std_logic;
    signal clk : std_logic;
    signal stream_i : std_logic_vector(63 downto 0);
    signal stream_o : std_logic_vector(6 downto 0);

        begin
          popcount: entity work.popcount2(Behavioral)
            port map(
              rst => rst,
              clk => clk,
              stream_i => stream_i,
              stream_o => stream_o
            );
            process begin
              rst <= '1';
              wait for 5 ns;
              rst <= '0';
              for i in 0 to 50 loop
                clk <= '0';
                wait for 5 ns;
                clk <= '1';
                wait for 5 ns;
              end loop;
              wait;
            end process;
            process begin
              stream_i <= x"FFFFFFFFFFFFFFFF";
              wait for 100 ns;
              stream_i <= x"00000000000F000F";
              wait for 100 ns;
              stream_i <= x"0000000000000000";
              wait;
            end process;
    end test;
