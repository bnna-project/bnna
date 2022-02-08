library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity buffer_bnn_tb is
end buffer_bnn_tb;

architecture test of buffer_bnn_tb is

    signal clk          : std_logic; 
    signal bnn_ready    : std_logic := '1';                     -- if '0', matrices can be read in 
    signal data_A       : std_logic_vector(1023 downto 0);      -- rows from matrix "A"
    signal data_B       : std_logic_vector(1023 downto 0);      -- columns from matrix "B"
    signal data_T       : std_logic_vector(15 downto 0);        -- Threshold
    signal en_A         :  std_logic;                           -- Enable "A"
    signal en_B         :  std_logic;                           -- Enable "B"
    signal en_T         :  std_logic;                           -- Enable "T"
    signal start        : std_logic;                            -- '1' if matrices A,B are transferred
    signal length       : integer;                              -- length of vectrors "A" and "B"
    signal depth_A      : integer;                              -- depth of matrix "A"
    signal width_B      : integer;                              -- width of matrix "B"

    begin
        inst_buffer_bnn : entity work.buffer_bnn(rtl)
            port map(
                clk         => clk,
                bnn_ready   => bnn_ready,
                data_A      => data_A,
                data_B      => data_B,
                data_T      => data_T,
                en_A        => en_A,
                en_B        => en_B,
                en_T        => en_T,
                start       => start,
                length      => length,
                depth_A     => depth_A,
                width_B     => width_B
            );
        process begin
            bnn_ready   <= '0';
            clk         <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait;
        end process;
    end test;