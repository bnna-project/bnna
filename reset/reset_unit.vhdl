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
    type t_Data is array (0 to 3) of std_logic ;
    signal r_Data : t_Data := "0000";
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
                        reset_PE1 <= r_Data(0) ;
                        reset_PE2 <= r_Data(1);
                        reset_PE3 <= r_Data(2);
                        reset_PE4 <= r_Data(3);
                                    
                    elsif (reg_reset = "001") then
                        reset_PE1 <= not r_Data(0) ; 
                        r_Data(0) <= not r_Data(0) ;

                    elsif (reg_reset = "010") then
                        reset_PE2 <= not r_Data(1) ; 
                        r_Data(1) <= not r_Data(1) ;

                    elsif (reg_reset = "011") then
                        reset_PE3 <= not r_Data(2) ; 
                        r_Data(2) <= not r_Data(2) ;

                    elsif (reg_reset = "100") then
                        reset_PE4 <= not r_Data(3) ; 
                        r_Data(3) <= not r_Data(3) ;

                    elsif (reg_reset = "111") then 
                        out_result <= '1';

                    end if;
        end if;
		end process;
    end rtl;
