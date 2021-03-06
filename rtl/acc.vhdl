library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity acc is
    port(
        i_val_acc   : std_logic;
        reset       : in std_logic;
        clk         : in std_logic;
        i_data      : in std_logic_vector(8 downto 0);
        o_data      : out std_logic_vector(31 downto 0);
        o_val_acc   : out std_logic
    );
end acc;

architecture rtl of acc is
    signal first_dff        : std_logic_vector(8 downto 0);
    signal delay_val        : std_logic_vector(1 downto 0);
    signal resize_data_i    : std_logic_vector(31 downto 0);
    signal o_acc            : std_logic_vector(31 downto 0);
    signal o_reg_acc        : std_logic_vector(31 downto 0);
begin
    --first d_ff
    process(clk)
        begin
            if rising_edge(clk)then
              if reset = '1'then
                  first_dff <= (others => '0');
              elsif i_val_acc = '1'then
                first_dff <= i_data;
              end if;
            end if;
    end process;

    --resize inputs data
    process(first_dff)
        begin
        if first_dff(8) = '1'then
            -- result of accumulation
            o_acc <= std_logic_vector(unsigned(o_reg_acc) + unsigned((31 downto 9 => '1')  & first_dff));
        else
            o_acc <= std_logic_vector(unsigned(o_reg_acc) + unsigned((31 downto 9 => '0')  & first_dff));
        end if;

    end process;




    --accumulator
    process(clk)
        begin
            if rising_edge(clk)then
              if reset = '1'then
                  o_reg_acc <= (others => '0');
              else
                o_reg_acc <= o_acc;
              end if;
            end if;
    end process;

    --determine delay through pipeline
    process(clk)
        begin
            if rising_edge(clk)then
                 delay_val <= delay_val(0) & i_val_acc;
                 if delay_val(1) = '1' then
                    o_val_acc <= '1';
                 else
                   o_val_acc <= '0';
                 end if;
            end if;
    end process;


    -- last d_ff
    process(clk)
        begin
            if rising_edge(clk)then
              if reset = '1'then
                  o_data <= (others => '0');
              else
                o_data <= o_reg_acc;
              end if;
            end if;
    end process;

end rtl;
