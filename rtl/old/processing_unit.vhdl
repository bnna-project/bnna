library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library work;
    use work.all;
    use work.parameters.all;

entity processing_unit is
    generic (
        DATA_W : natural := 64;
        DATA_OUT_W : natural := f_log2(DATA_W)+1
    );
    port(
        clk : in std_logic; --clock
        reset : in std_logic; --reset for cache
        data : in std_logic_vector(DATA_W-1 downto 0); --data vector
        weight : in std_logic_vector(DATA_W-1 downto 0); --weight vector
        treshold : in std_logic_vector(15 downto 0); --treshold value
        output1 : out std_logic; --output (0 or 1)
        output2 : out std_logic --enable Bit for Output
    );
end;

architecture structure of processing_unit is
    component bnn_xnor
        port(
            data : in std_logic;
            weight : in std_logic;
            output : out std_logic
        );
    end component;

    component popcount
        port(
            i_val       : in std_logic;
            clk         : in std_logic;
            rst         : in std_logic;
            stream_i    : in std_logic_vector(DATA_W-1 downto 0);
            o_val       : out std_logic;
            stream_o    : out std_logic_vector(DATA_OUT_W-1 downto 0)
        );
    end component;

    component cache
        port(
            reset: in std_logic;
            clk: in std_logic;
            input1: in std_logic_vector(DATA_OUT_W-1 downto 0);
            output1: out std_logic_vector(15 downto 0);
            ready: out std_logic
        );
    end component;

    component comparator
        port(
            a : in std_logic_vector(15 downto 0);
            b : in std_logic_vector(15 downto 0);
            a_comp_b : out std_logic
        );
    end component;

    signal output_comp : std_logic;
    signal popcount_in : std_logic_vector(DATA_W-1 downto 0);
    signal popcount_out : std_logic_vector(DATA_OUT_W downto 0);
    signal cache_out : std_logic_vector(15 downto 0);
    signal tmp_out2, tmp_out2_1 : std_logic;

begin
    --8 xnor gates connected to one popcount with 8 inputs and 3 outputs
    gen_xnor : for i in 0 to (DATA_W-1) generate
        inst_xnor : bnn_xnor port map(data=>data(i), weight=>weight(i), output=>popcount_in(i));
    end generate;

    inst_pcnt : popcount port map (
        i_val    => '1',
        clk      => clk,
        rst      => reset,
        stream_i => popcount_in,
        o_val    => open,
        stream_o => popcount_out
    );

    inst_cache : cache port map (
        reset => reset,
        clk => clk,
        input1 => popcount_out,
        output1 => cache_out
    );

    inst_comp : comparator port map(
        a => cache_out,
        b => treshold,
        a_comp_b => output_comp
    );
    
    -- ensures that the result enable bit is only present for one clock pulse
    -- and only when the reset jumps from zero to one
    process (clk) begin
        if rising_edge(clk) then
            if reset = '0' then
                tmp_out2_1 <= '1';
            end if;
            if reset = '1' and tmp_out2_1 = '1' then
                tmp_out2 <= '1';
            end if;

        end if;

        if falling_edge(clk) then -- fixme
            if tmp_out2 = '1' then 
                tmp_out2_1 <= '0';
                tmp_out2 <= '0';
                output2 <= '1';
            else 
                output2 <= '0';
            end if;
        end if;
    end process;

    --sets the result of the comparator to output1
    process (output_comp) begin
        if output_comp = '0' or output_comp = '1' then -- fixme
            output1 <= output_comp;
        else
            output1 <= '0';
        end if;
    end process;
end;
