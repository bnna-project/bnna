
module pu_tb();

  logic               clk      ; // : in std_logic; --clock
  logic               reset    ; // : in std_logic; --reset for cache
  logic        [63:0] data     ; // : in std_logic_vector(NUMBER_OF_W_A -1 downto 0); --data vector
  logic        [63:0] weight   ; // : in std_logic_vector(NUMBER_OF_W_A -1 downto 0); --weight vector
  logic        [15:0] treshold ; // : in std_logic_vector(15 downto 0); --treshold value
  logic               output1  ; // : out std_logic; --output (0 or 1)
  logic               output2  ; // : out std_logic --enable Bit for Output

  //--------------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------------
  // Clock
  initial begin
    clk = 1'b0;
    forever begin
      #1ns; clk = ~clk;
    end
  end

  // Reset
  initial begin
    reset = 1'b1;
    repeat(4)@(posedge clk);
    reset = 1'b0;
  end

  localparam int N_TEST_WORDS = 2;

  //--------------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------------
  // 2*popcount(word) - size(word)
  function logic [7:0] pcnt_2p_n (input logic [63:0] word);
      automatic logic [11:0] res = 0;
      for (int i = 0; i < $size(word); i++) begin
        if (word[i]) begin
          res++;
        end
      end

      res = 2*res - $size(word);

      return res;
  endfunction

  //--------------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------------

  // Input data thread
  initial begin
    // i_val = 1'b0;
    data = 1'b0;
    weight = 1'b0;
    treshold = 1'b0;
    @(negedge reset);
    repeat(2)@(posedge clk);

    repeat(N_TEST_WORDS) begin
      @(posedge clk);
      
      data[63:3] = '1;
      data[2:0] = 3'b101;
      weight[63:3] = '0;
      weight[2:0] = 3'b111;
      treshold = 64'd8;
    end

    // Wait for finish
    repeat(32)@(posedge clk);
  end

  // DUT instance
  processing_unit
  dut
  (.*);

endmodule
