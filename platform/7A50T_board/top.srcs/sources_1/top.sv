
module top
  (
    input            SYS_CLK_I    ,
    input            USB_UART_RXD ,
    output           USB_UART_TXD ,
    output           USER_LED1    ,
    output           USER_LED2    ,
    output           USER_LED3    ,
    output           USER_LED4    ,
    output           USER_LED5    ,
    output           USER_LED6    ,
    output           USER_LED7    ,
    output           USER_LED8    ,
    input            PB1          ,
    input            PB2          ,
    input            PB3          ,
    input            PB4
  );

  logic     [27:0] heartbit;

  always_ff@(posedge SYS_CLK_I) begin
    heartbit <= heartbit + 1'b1;
  end

  assign USER_LED1 = heartbit[$high(heartbit)];

  (* keep_hierarchy="yes" *)(* dont_touch="true" *)popcount
  pcnt
  (
    . i_val      (PB2          ) ,
    . clk        (SYS_CLK_I    ) ,
    . rst        (PB1          ) ,
    . stream_i   (heartbit     ) ,
    . o_val      (USER_LED2    ) ,
    . stream_o   (USER_LED3    )
  );

endmodule



