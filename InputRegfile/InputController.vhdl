library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


entity inputController is
    port(
        clk: in std_logic;
        rst_sync: in std_logic;
        rdy: in std_logic;
        depthA: in Integer;
        widthB: in integer;
        len: in integer;
        resetPE: out std_logic_vector(2 downto 0);
        DataA: in std_logic_vector(2047 downto 0);
        weA: in std_logic;
        DataB: in std_logic_vector(2047 downto 0);
        weB: in std_logic;
        DataT: in std_logic_vector(15 downto 0);
        weT: in std_logic;
        o_A: buffer std_logic_vector(31 downto 0);
        o_B: buffer std_logic_vector(31 downto 0);
        o_T: buffer std_logic_vector(63 downto 0)
    );
end;

architecture aufbau of inputController is

    component regfileA
        port(
            clk: in std_logic;
            we3: in std_logic;
            a1: in std_logic_vector(11 downto 0);
            a3: in std_logic_vector(11 downto 0);
            wd3: in std_logic_vector(2047 downto 0);
            rd1: buffer std_logic_vector(2047 downto 0)
        );
end component;


component regfileT
    port(
        clk: in std_logic;
        we3: in std_logic;
        a1: in std_logic_vector(11 downto 0);
        a3: in std_logic_vector(11 downto 0);
        wd3: in std_logic_vector(15 downto 0);
        rd1: buffer std_logic_vector(15 downto 0)

    );
end component;

component regfileS
    port(
        clk: in std_logic;
        we3: in std_logic;
        a1: in std_logic_vector(3 downto 0);
        a3: in std_logic_vector(3 downto 0);
        wd3: in std_logic_vector(7 downto 0);
        rd1: buffer std_logic_vector(7 downto 0)

    );
end component;

component regfileADDR
    port(
        clk: in std_logic;
        we3: in std_logic;
        a1: in std_logic_vector(3 downto 0);
        a3: in std_logic_vector(3 downto 0);
        wd3: in std_logic_vector(23 downto 0);
        rd1: buffer std_logic_vector(23 downto 0)

    );
end component;

component fifo
    generic(g_WIDTH : natural := 24); 
port(
    i_rst_sync : in std_logic;
    i_clk      : in std_logic;

    -- FIFO Write Interface
    i_wr_en   : in  std_logic;
    i_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
    o_full    : out std_logic;

    -- FIFO Read Interface
    i_rd_en   : in  std_logic;
    o_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
    o_empty   : out std_logic

);
end component;

component command_cal
    port(

        clk: in std_logic;
        i_rdy: in std_logic;
        i_depthA: in Integer;
        i_widthB: in integer;
        o_com: buffer std_logic_vector(23 downto 0);
        wr_en: out  std_logic;
        i_full: in std_logic

    );
end component;

component controller
    port(
        i_len: in integer;
        i_clk: in std_logic;
        i_reset: in std_logic;
        i_rdy: in std_logic;
        resetPE: out std_logic_vector(2 downto 0);
        --register A Interface
        i_wdDataA: in std_logic_vector(2047 downto 0);
        i_weA: in std_logic;
        --register A Connection
        o_wdDataA: out std_logic_vector(2047 downto 0);
        o_weA: out std_logic;
        o_waA: out std_logic_vector(11 downto 0);
        o_rdaA: out std_logic_vector(11 downto 0);
        i_rdA: in std_logic_vector(2047 downto 0);
        --register B Interface
        i_wdDataB: in std_logic_vector(2047 downto 0);
        i_weB: in std_logic;
        --register B Connection
        o_wdDataB: out std_logic_vector(2047 downto 0);
        o_weB: out std_logic;
        o_waB: out std_logic_vector(11 downto 0);
        o_rdaB: out std_logic_vector(11 downto 0);
        i_rdB: in std_logic_vector(2047 downto 0);
        --register Tres Interface
        i_wdDataT: in std_logic_vector(15 downto 0);
        i_weT: in std_logic;
        --register Tres Connection
        o_wdDataT: out std_logic_vector(15 downto 0);
        o_weT: out std_logic;
        o_waT: out std_logic_vector(11 downto 0);
        o_rdaT: out std_logic_vector(11 downto 0);
        i_rdT: in std_logic_vector(15 downto 0);
        --register State Connection
        o_wdDataS: out std_logic_vector(7 downto 0);
        o_weS: out std_logic;
        o_waS: out std_logic_vector(3 downto 0);
        o_rdaS: out std_logic_vector(3 downto 0);
        i_rdS: in std_logic_vector(7 downto 0);
        --register addr Connection
        o_wdDataAD: out std_logic_vector(23 downto 0);
        o_weAD: out std_logic;
        o_waAD: out std_logic_vector(3 downto 0);
        o_rdaAD: out std_logic_vector(3 downto 0);
        i_rdAD: in std_logic_vector(23 downto 0);
        --FiFo
        o_rd_en   : out  std_logic;
        i_rd_data : in std_logic_vector(23 downto 0);
        i_empty   : in std_logic;
        --Output
        o_A: buffer std_logic_vector(31 downto 0);
        o_B: buffer std_logic_vector(31 downto 0);
        o_T: buffer std_logic_vector(63 downto 0)

    );
end component;

signal we3Ac, we3Bc, weTc, weSc, weADc, wr_enc, rd_enc, emptyc, fullc :std_logic;
signal wdDataAc, rdAc, wdDataBc, rdBc:std_logic_vector(2047 downto 0);
signal rdaAc, waAc, rdaBc, waBc, rdaTc, waTc:std_logic_vector(11 downto 0);
signal wdDataTc, rdTc :std_logic_vector(15 downto 0);
signal wdDataSc, rdSc :std_logic_vector(7 downto 0);
signal rdaSc, waSc, rdaADc, waADc :std_logic_vector(3 downto 0);
signal wdDataADc, rdADc, wr_datac, rd_datac :std_logic_vector(23 downto 0);

begin

    regA:  regfileA port map(clk, we3 => we3Ac, a1 => rdaAc, a3 => waAc, wd3 => wdDataAc, rd1 => rdAc);
    regB:  regfileA port map(clk, we3 => we3Bc, a1 => rdaBc, a3 => waBc, wd3 => wdDataBc, rd1 => rdBc);
    regT:  regfileT port map(clk, we3 => weTc,  a1 => rdaTc, a3 => waTc, wd3 => wdDataTc, rd1 => rdTc);
    regS:  regfileS port map(clk, we3 => weSc,  a1 => rdaSc, a3 => waSc, wd3 => wdDataSc, rd1 => rdSc);
    regAD: regfileADDR port map(clk, we3 => weADc, a1 => rdaADc, a3 => waADc, wd3 => wdDataADc, rd1 => rdADc);
    sig_fifo: fifo port map(i_rst_sync => rst_sync, i_clk => clk, i_wr_en => wr_enc, i_wr_data => wr_datac, o_full => fullc, i_rd_en => rd_enc, o_rd_data => rd_datac, o_empty => emptyc);
    comcal: command_cal port map(clk, i_rdy => rdy, i_depthA => depthA, i_widthB => widthB, o_com => wr_datac, wr_en => wr_enc, i_full => fullc);
    con: controller port map(
        i_len => len,
        i_clk => clk,
        i_reset => rst_sync,
        i_rdy => rdy,
        resetPE => resetPE,
        i_wdDataA => DataA,
        i_weA => weA,
        o_wdDataA => wdDataAc,
        o_weA => we3Ac,
        o_waA => waAc,
        o_rdaA => rdaAc,
        i_rdA => rdAc,
        i_wdDataB => DataB,
        i_weB => weB,
        o_wdDataB => wdDataBc,
        o_weB => we3Bc,
        o_waB => waBc,
        o_rdaB => rdaBc,
        i_rdB => rdBc,
        i_wdDataT => DataT,
        i_weT => weT,
        o_wdDataT => wdDataTc,
        o_weT => weTc,
        o_waT => waTc,
        o_rdaT => rdaTc,
        i_rdT => rdTc,
        o_wdDataS => wdDataSc,
        o_weS => weSc,
        o_waS => waSc,
        o_rdaS => rdaSc,
        i_rdS => rdSc,
        o_wdDataAD => wdDataADc,
        o_weAD => weADc,
        o_waAD => waADc,
        o_rdaAD => rdaADc,
        i_rdAD => rdADc,
        o_rd_en => rd_enc,
        i_rd_data => rd_datac,
        i_empty => emptyc,
        o_A => o_A,
        o_B => o_B,
        o_T => o_T
    );


end;

