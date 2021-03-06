library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
    port(
            clk         : in std_logic;
            reset       : in std_logic;
            i_val_comp  : in std_logic;
            a           : in std_logic_vector(31 downto 0); --accumulator output
            b           : in std_logic_vector(31 downto 0); --threshold
            o_val_comp  : out std_logic;
            a_comp_b    : out std_logic                     --result
    );
    end comparator;

--Compares the results from the register and the threshold
architecture rtl of comparator is
  signal first_dff_comp     : std_logic_vector(31 downto 0);
  signal second_dff_comp    : std_logic_vector(31 downto 0);
  signal delay_val_comp     : std_logic;
  begin
    --first d_ff comparator
    process(clk)
      begin
        if rising_edge(clk)then
          if reset = '1'then
            first_dff_comp <= (others => '0');
          elsif i_val_comp = '1'then
            first_dff_comp <= a;
          end if;
        end if;
    end process;

    process(clk)begin
      if rising_edge(clk)then
        if reset = '1'then
          second_dff_comp <= (others => '0');
        elsif i_val_comp = '1'then
          second_dff_comp <= b;
        end if;
      end if;
    end process;

    process (clk) begin
        if rising_edge(clk) then
            if (first_dff_comp(31) > second_dff_comp(31))then
              a_comp_b <= '0';
            else
                if (first_dff_comp >= second_dff_comp) then
                    a_comp_b <= '1';
                else
                    a_comp_b <= '0';
                end if;
            end if;
        end if;
    end process;

    -- delay through pipeline
    process(clk)begin
        if rising_edge(clk)then
            delay_val_comp <= i_val_comp;
            if delay_val_comp = '1' then
                o_val_comp <= '1';
            else
                o_val_comp <= '0';
            end if;
        end if;
    end process;

end rtl;
