library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bnn_dff is
   generic(
      W : integer:=2
   );
    port(
        d :  in std_logic_vector(W-1 downto 0);
        rst : in std_logic;
        clk : in std_logic;
        q   : out std_logic_vector(W-1 downto 0)
    );
end bnn_dff;

architecture rtl of bnn_dff is

begin
    process(clk)begin
        if rst = '1'then
            q <= (others=>'0');
        elsif rising_edge(clk)then
            q <= d;
        end if;
    end process;

end rtl;
