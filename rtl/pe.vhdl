library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pe is
  port(
    i_val_outside : in std_logic;
    data          : in std_logic_vector(63 downto 0);
    weights       : in std_logic_vector(63 downto 0);
    threshold     : in std_logic_vector(31 downto 0);
    clk           : in std_logic;
    reset         : in std_logic;
    result        : out std_logic;
    o_val_pe      : out std_logic
  );
end pe;

architecture struct of pe is

  signal xnor_output            : std_logic_vector(63 downto 0);
  signal first_dff_data_pe      : std_logic_vector(63 downto 0);
  signal first_dff_weights_pe   : std_logic_vector(63 downto 0);
  signal delay_val_xnor         : std_logic_vector(1 downto 0);
  signal o_val_xnor             : std_logic;
  signal o_val_bnn_popcount     : std_logic;
  signal o_stream_popcount      : std_logic_vector(8 downto 0);
  signal o_stream_acc           : std_logic_vector(31 downto 0);
  signal o_val_acc              : std_logic;

  begin
    process(clk)
      begin
        if reset = '1' then
          first_dff_weights_pe  <= (others => '0');
        elsif rising_edge(clk)then
            if i_val_outside = '1'then
                first_dff_weights_pe  <= weights;
            end if;
        end if;
    end process;

    process(clk)
      begin
        if reset = '1' then
          first_dff_data_pe     <= (others => '0');
        elsif rising_edge(clk)then
            if i_val_outside = '1'then
                first_dff_data_pe     <= data;
            end if;
        end if;
    end process;

    xnor_gen : for i in 0 to 63 generate
        inst_xnor : entity work.xnor_2(rtl)
          port map(
            data    => first_dff_data_pe(i),
            weight  => first_dff_weights_pe(i),
            output1 => xnor_output(i)
          );
    end generate;

    process(clk)
        begin
            delay_val_xnor <= delay_val_xnor(0) & i_val_outside;
            if delay_val_xnor(1) = '1'then
                o_val_xnor <= '1';
            end if;
    end process;

    inst_bnn_popcount : entity work.popcount2(rtl)
        port map(
            i_val       => o_val_xnor,
            clk         => clk,
            rst         => reset,
            stream_i    => xnor_output,
            o_val       => o_val_bnn_popcount,
            stream_o    => o_stream_popcount
        );

    inst_acc : entity work.acc(rtl)
        port map(
            i_val_acc   => o_val_bnn_popcount,
            reset       => reset,
            clk         => clk,
            i_data      => o_stream_popcount,
            o_data      => o_stream_acc,
            o_val_acc   => o_val_acc
        );

     inst_comparator : entity work.comparator(rtl)
        port map(
            clk         => clk,
            reset       => reset,
            i_val_comp  => o_val_acc,
            a           => o_stream_acc,
            b           => threshold,
            o_val_comp  => o_val_pe,
            a_comp_b    => result
        );
end struct;
