library ieee;
use ieee.std_logic_1164.all;

entity comparator_tb is
end comparator_tb;

architecture test of comparator_tb is

    signal clk        : std_logic;
    signal reset      : std_logic;
    signal i_val_comp : std_logic;
    signal o_val_comp : std_logic;
    signal a          : std_logic_vector(31 downto 0);
    signal b          : std_logic_vector(31 downto 0);
    signal a_comp_b   : std_logic;

    begin

      inst_comp : entity work.comparator(rtl)
        port map(
          clk         => clk,
          reset       => reset,
          i_val_comp  => i_val_comp,
          o_val_comp  => o_val_comp,
          a           => a,
          b           => b,
          a_comp_b    => a_comp_b
        );

      process begin
        i_val_comp <= '1';
        reset <= '1';
        clk   <= '1';
        wait for 1 ns;
        reset <= '0';
        clk   <= '0';
        wait for 1 ns;
        for i in 0 to 20 loop
          clk <= '1';
          wait for 1 ns;
          clk  <= '0';
          wait for 1 ns;
        end loop;
        wait;
      end process;

      process begin
        a <= x"0000_1000";
        b <= x"0000_0000";
        wait for 5 ns;
        a <= x"0000_0000";
        b <= x"0000_0001";
        wait for 5 ns;
        a <= x"0000_0000";
        b <= x"0000_0000";
        wait for 5 ns;
        a <= x"0000_0000";
        b <= x"1111_1111";
        -- wait for 5 ns;
        wait;
      end process;

    end test;
