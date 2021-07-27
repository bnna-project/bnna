library ieee;
use ieee.std_logic_1164.all;

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

architecture structure of inputController is

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
	
component regfileB
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

regA:  regfileA port map(clk, we3Ac, rdaAc, waAc, wdDataAc, rdAc);
regB:  regfileB port map(clk, we3Bc, rdaBc, waBc, wdDataBc, rdBc);
regT:  regfileT port map(clk, weTc,  rdaTc, waTc, wdDataTc, rdTc);
regS:  regfileS port map(clk, weSc,  rdaSc, waSc, wdDataSc, rdSc);
regAD: regfileADDR port map(clk, weADc, rdaADc, waADc, wdDataADc, rdADc);
sig_fifo: fifo port map(rst_sync, clk, wr_enc, wr_datac, fullc, rd_enc, rd_datac, emptyc);
comcal: command_cal port map(clk, rdy, depthA, widthB, wr_datac, wr_enc, fullc);
con: controller port map(len, clk, rst_sync, rdy, resetPE, DataA, weA, wdDataAc, we3Ac, waAc, rdaAc, rdAc, DataB, weB, wdDataBc, we3Bc, waBc, rdaBc, rdBc, DataT, weT, wdDataTc, weTc, waTc, rdaTc, rdTc, wdDataSc, weSc, waSc, rdaSc, rdSc, wdDataADc, weADc, waADc, rdaADc, rdADc, rd_enc, rd_datac, emptyc, o_A,o_B,o_T);

end;
