library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity popcount_not_synth is
  port(
    stream_i : in std_logic_vector(63 downto 0);
    stream_o : out std_logic_vector(8 downto 0)
  );
end popcount_not_synth;

architecture test of popcount_not_synth is
  signal count : integer;
  signal count_conv : std_logic_vector(8 downto 0);
  begin
    process begin
      for i in 0 to 63 loop
        if(stream_i(i) = '1')then
          count <= count + 1;
        end if;
      end loop;
      count_conv <= std_logic_vector(to_unsigned(count, count_conv'length));
      stream_o <= std_logic_vector(unsigned(count_conv) + unsigned(count_conv));
    end process;
end test; 
