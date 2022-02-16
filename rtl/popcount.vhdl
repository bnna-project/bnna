library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity popcount is
  port(
    i_val       : in std_logic;
    clk         : in std_logic;
    rst         : in std_logic;
    stream_i    : in std_logic_vector(63 downto 0);
    o_val       : out std_logic;
    stream_o    : out std_logic_vector(8 downto 0)
  );
end popcount;

architecture rtl of popcount is

    type ram_type32 is array (31 downto 0) of std_logic_vector(1 downto 0);
    signal mem32_i      : ram_type32 := (others => (others => '0'));
    signal mem32_o      : ram_type32 := (others => (others => '0'));

    type ram_type16 is array (15 downto 0) of std_logic_vector(2 downto 0);
    signal mem16_i      : ram_type16 := (others => (others => '0'));
    signal mem16_o      : ram_type16 := (others => (others => '0'));

    type ram_type8 is array (7 downto 0) of std_logic_vector(3 downto 0);
    signal mem8_i       : ram_type8 := (others => (others => '0'));
    signal mem8_o       : ram_type8 := (others => (others => '0'));

    type ram_type4 is array (3 downto 0) of std_logic_vector(4 downto 0);
    signal mem4_i       : ram_type4 := (others => (others => '0'));
    signal mem4_o       : ram_type4 := (others => (others => '0'));

    type ram_type2 is array (1 downto 0) of std_logic_vector(5 downto 0);
    signal mem2_i       : ram_type2 := (others => (others => '0'));
    signal mem2_o       : ram_type2 := (others => (others => '0'));

    type ram_type1 is array (0 downto 0) of std_logic_vector(6 downto 0);
    signal mem1_i       : std_logic_vector(6 downto 0);
    signal mem1_o       : std_logic_vector(6 downto 0);

    signal dff_stream   : std_logic_vector(63 downto 0);
    signal P2           : std_logic_vector(7 downto 0):=(others => '0');
    signal dff_2P       : std_logic_vector(7 downto 0):=(others => '0');
    signal dff_substr   : std_logic_vector(8 downto 0);
    signal delay_val    : std_logic_vector(8 downto 0):= (others => '0');



begin
    process(clk)begin
        if rising_edge(clk) and i_val = '1'then
          if rst = '1' then
            dff_stream <= (others=>'0');
          else
            dff_stream <= stream_i;
          end if;
        end if;
    end process;

    gen_add_1_2 : for i in 0 to 31 generate
        inst_adder_1_2:  entity work.bnn_adder(rtl)
            generic map(W_i => 1,
                        W_o => 2)
            port map(
                a(0) => dff_stream(i*2),
                b(0) => dff_stream(i*2+1),
                y => mem32_i(i)
            );
       inst_dff_2 : entity work.bnn_dff(rtl)
       generic map(W => 2)
        port map(
            d => mem32_i(i),
            rst => rst,
            clk => clk,
            q => mem32_o(i)
        );
    end generate;

    gen_add_2_3 : for i in 0 to 15 generate
        inst_adder_2_3 :  entity work.bnn_adder(rtl)
            generic map(W_i => 2,
                        W_o => 3)
            port map(
                a => mem32_o(i*2),
                b => mem32_o(i*2 +1),
                y => mem16_i(i)
            );
        inst_dff_3 : entity work.bnn_dff(rtl)
        generic map(W => 3)
        port map(
            d => mem16_i(i),
            rst => rst,
            clk => clk,
            q => mem16_o(i)
        );
    end generate;

    gen_add_3_4 : for i in 0 to 7 generate
        inst_adder_3_4 : entity work.bnn_adder(rtl)
            generic map(W_i => 3,
                        W_o => 4)
            port map(
                a => mem16_o(i*2),
                b => mem16_o(i*2+1),
                y => mem8_i(i)
            );
        inst_dff_4 : entity work.bnn_dff(rtl)
        generic map(W => 4)
        port map(
            d => mem8_i(i),
            rst => rst,
            clk => clk,
            q => mem8_o(i)
        );
    end generate;

    gen_add_4_5 : for i in 0 to 3 generate
        inst_adder_4_5 : entity work.bnn_adder(rtl)
            generic map (W_i => 4,
                         W_o => 5)
            port map(
                a => mem8_o(i*2),
                b => mem8_o(i*2+1),
                y => mem4_i(i)
            );
        inst_dff_5 : entity work.bnn_dff(rtl)
        generic map(W => 5)
        port map(
            d => mem4_i(i),
            rst => rst,
            clk => clk,
            q => mem4_o(i)
        );
    end generate;

    gen_add_5_6 : for i in 0 to 1 generate
        inst_adder_5_6 : entity work.bnn_adder(rtl)
            generic map(W_i => 5,
                        W_o => 6)
            port map(
                a => mem4_o(i*2),
                b => mem4_o(i*2+1),
                y => mem2_i(i)
            );
        inst_dff_6 : entity work.bnn_dff(rtl)
        generic map(W => 6)
        port map(
            d => mem2_i(i),
            rst => rst,
            clk => clk,
            q => mem2_o(i)
        );
    end generate;

    inst_adder_6_7 : entity work.bnn_adder(rtl)
        generic map(W_i => 6,
                    W_o => 7)
        port map(
            a => mem2_o(0),
            b => mem2_o(1),
            y => mem1_i
        );
    inst_dff_7 : entity work.bnn_dff(rtl)
        generic map(W => 7)
        port map(
            d => mem1_i,
            rst => rst,
            clk => clk,
            q => mem1_o
        );
---------------------------------------------------------------------
     process(mem1_o)begin
       P2 <= mem1_o(6 downto 0) & '0';
    end process;

    inst_dff_8 : entity work.bnn_dff(rtl)
    generic map(W => 8)
    port map(
        d => P2,
        rst => rst,
        clk => clk,
        q => dff_2P
    );
    inst_substr_7_8: entity work.bnn_substr(rtl)
        port map(
            a => dff_2P,
            b => x"40",
            y => dff_substr
        );
     process(clk)
        begin
            if rising_edge(clk)then
                if rst = '1'then
                  delay_val <= (others => '0');
                else
                  delay_val <= delay_val(7 downto 0) & i_val;
                  if(delay_val(7) = '1')then
                    o_val <= delay_val(7);
                  else
                    o_val <= '0';
                  end if;
                end if;
            end if;
     end process;

     process(clk)
        begin

            if rising_edge(clk) and delay_val(7) = '1'then
              if rst = '1'then
                  stream_o <= (others => '0');
              else
                stream_o <= dff_substr;
              end if;
            end if;
     end process;
--    inst_dff_9 : entity work.bnn_dff(rtl)
--    generic map(W => 9)
--    port map(
--        d => dff_substr,
--        rst => rst,
--        clk => clk,
--        q => stream_o
--    );
        --stream_o <= std_logic_vector(unsigned(dff_2P) - unsigned(dff_2P));
-----------------------------------------------------------------------


end rtl;
