library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity command_cal is
    port (
        clk: in std_logic;
        i_rdy: in std_logic;
        i_depthA: in Integer;
        i_widthB: in integer;
        o_com: buffer std_logic_vector(19 downto 0);
        wr_en: out  std_logic;
        i_full: in std_logic
    );
end;

architecture behavior of command_cal is

begin
    process(clk) 
        variable start: std_logic:= '0';
    variable deepthC, widthC: integer := 0;
    variable deepthTmp, widthTmp: integer := 1;
begin


    if rising_edge(clk) then 
        if(i_rdy = '1' and start = '0') then 
            start := '1';
            deepthC := i_depthA;
            widthC := i_widthB;
        end if;


    end if;
    if falling_edge(clk) then
        if(start = '1' and i_full =  '0' and widthTmp <= widthC ) then
            wr_en <= '1';
            o_com <= std_logic_vector(to_unsigned(widthTmp, 10)) &  std_logic_vector(to_unsigned(deepthTmp, 10));
            deepthTmp := deepthTmp +1;
            if(deepthTmp > deepthC ) then
                deepthTmp := 1;
                widthTmp := widthTmp +1;
            end if;
        elsif(start = '1' and i_full =  '0' and widthTmp = widthC  +1 ) then

            wr_en <= '1';
            o_com <= "11111111111111111111";
            deepthTmp := deepthTmp +1;
        else 
            wr_en <= '0';
        end if;

    end if;
end process;


end;