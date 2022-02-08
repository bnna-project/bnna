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
  signal comp_result        : std_logic;
  signal delay_val_comp     : std_logic_vector(1 downto 0);
  begin
    --first d_ff comparator
    process(clk)
      begin
        if reset = '1'then
          first_dff_comp <= (others => '0');
        elsif rising_edge(clk) and i_val_comp = '1'then
          first_dff_comp <= a;
        end if;
    end process;

    process(clk)begin
      if reset = '1'then
        second_dff_comp <= (others => '0');
      elsif rising_edge(clk) and i_val_comp = '1'then
        second_dff_comp <= b;
      end if;
    end process;

    process(clk)
      begin
        if(first_dff_comp(31) > second_dff_comp(31))then
          comp_result <= '1';
        else
          if(first_dff_comp >= second_dff_comp)then
            comp_result <= '1';
          else
            comp_result <= '0';
          end if;
        end if;
    end process;
    -- delay through pipeline
    process(clk)begin
        if rising_edge(clk)then
            delay_val_comp <= delay_val_comp(0) & i_val_comp;
            if delay_val_comp(1) = '1'then
                o_val_comp <= '1';
            end if;
        end if;
    end process;

    process(clk)
        begin
            if reset = '1'then
                a_comp_b <= '0';
            elsif rising_edge(clk) and delay_val_comp(0) = '1' then
                a_comp_b <= comp_result;
            end if;
    end process;

end rtl;
