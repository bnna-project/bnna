library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity reset_unit is
    port(
        buffer_reset : in std_logic;
        reg_reset : in std_logic_vector(2 downto 0);
        clk : in std_logic;
        reset_reg : out std_logic;
        reset_PE1 : out std_logic;
        reset_PE2 : out std_logic;
        reset_PE3 : out std_logic;
        reset_PE4 : out std_logic;
        out_result : out std_logic
    );
    end reset_unit;

architecture rtl of reset_unit is
   begin
     process(buffer_reset)
          begin
        if (buffer_reset = '1') then
             reset_reg <= '1';
        else reset_reg <= '0';
		end if;
	 end process;
	 
	 process(clk,reg_reset)
	 begin
        if rising_edge(clk) then
                    if (reg_reset = "000") then
                        reset_PE1 <= '0';
                        reset_PE2 <= '0';
                        reset_PE3 <= '0';
                        reset_PE4 <= '0';

                    elsif (reg_reset = "001") then
                        reset_PE1 <= '1';
                        reset_PE2 <= '0';
                        reset_PE3 <= '0';
                        reset_PE4 <= '0';

                    elsif (reg_reset = "010") then
                        reset_PE1 <= '0';
                        reset_PE2 <= '1';
                        reset_PE3 <= '0';
                        reset_PE4 <= '0';

                    elsif (reg_reset = "011") then
                        reset_PE1 <= '0';
                        reset_PE2 <= '0';
                        reset_PE3 <= '1';
                        reset_PE4 <= '0';

                    elsif (reg_reset = "100") then
                        reset_PE1 <= '0';
                        reset_PE2 <= '0';
                        reset_PE3 <= '0';
                        reset_PE4 <= '1';

                    elsif (reg_reset = "111") then 
                        reset_PE1 <= '0';
                        reset_PE2 <= '0';
                        reset_PE3 <= '0';
                        reset_PE4 <= '0';
                        out_result <= '1';

                    end if;
        end if;
		end process;
    end rtl;
