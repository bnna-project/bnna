library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity acc_tb is
end acc_tb;

architecture test of acc_tb is
    signal i_val_acc    : std_logic;
    signal reset        : std_logic;
    signal clk          : std_logic;
    signal i_data       : std_logic_vector(8 downto 0);
    signal o_data       : std_logic_vector(31 downto 0);
    signal o_val_acc    : std_logic;
    begin

      inst_acc :  entity work.acc(rtl)
        port map(
          i_val_acc   => i_val_acc,
          reset       => reset,
          clk         => clk,
          i_data      => i_data,
          o_data      => o_data,
          o_val_acc   => o_val_acc
        );

        process begin
            i_val_acc <= '1';
            reset <= '1';
            clk <= '1';
            wait for 1 ns;
            reset <= '0';
            clk <= '0';
            wait for 1 ns;
            for i in 0 to 20 loop
              clk <= '1';
              wait for 1 ns;
              clk <= '0';
              wait for 1 ns;
            end loop;
            wait;
        end process;

        process begin
            i_data <= b"1_1111_1111";
            wait for 5 ns;
            i_data <= b"0_0000_0001";
            wait for 5 ns;
            i_data <= b"0_0000_0011";
            wait for 5 ns;
            wait;
        end process;
      end test;
