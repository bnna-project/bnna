library ieee;
use ieee.std_logic_1164.all;

entity pe_tb is
end pe_tb;

architecture test of pe_tb is

  signal i_val_outside : std_logic;
  signal data          : std_logic_vector(63 downto 0);
  signal weights       : std_logic_vector(63 downto 0);
  signal threshold     : std_logic_vector(31 downto 0);
  signal clk           : std_logic;
  signal reset         : std_logic;
  signal result        : std_logic;
  signal o_val_pe      : std_logic;

  begin

    inst_pe : entity work.pe(struct)
      port map(
      i_val_outside => i_val_outside,
      data          => data,
      weights       => weights,
      threshold     => threshold,
      clk           => clk,
      reset         => reset,
      result        => result,
      o_val_pe      => o_val_pe
      );

      process begin
        reset         <= '1';
        clk           <= '1';
        wait for 1 ns;
        reset         <= '0';
        clk           <= '0';
        wait for 1 ns;
        for i in 0 to 50 loop
          clk         <= '1';
          wait for 1 ns;
          clk         <= '0';
          wait for 1 ns;
        end loop;
        wait;
      end process;

      process begin
        i_val_outside <= '1';
        data          <= b"0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111";
        weights       <= b"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
        threshold     <= b"1111_1111_1111_1111_1111_1111_1011_0000";
        wait for 5 ns;
        data          <= b"0000_0000_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111";
        weights       <= b"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
        threshold     <= b"1111_1111_1111_1111_1111_1111_1011_0000";
        wait for 5 ns;
        data          <= b"0000_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111";
        weights       <= b"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
        threshold     <= b"1111_1111_1111_1111_1111_1111_1011_0000";
        wait for 5 ns;
        data          <= b"0000_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111";
        weights       <= b"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
        threshold     <= b"1111_1111_1111_1111_1111_1111_1011_0000";
        wait for 5 ns;
        i_val_outside <= '0';
        wait;
      end process;

end test;
