`include "defines.v"

module hilo (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,
    input wire we,

    input wire [`REG_BUS] hi_i,
    input wire [`REG_BUS] lo_i,

    output reg [`REG_BUS] hi_o,
    output reg [`REG_BUS] lo_o
);
  reg [`REG_BUS] hireg;
  reg [`REG_BUS] loreg;
  always @(posedge cpu_clk_50M) begin
    if (cpu_rst_n == `RST_ENABLE) begin
      hireg <= 0;
      loreg <= 0;
    end else begin
      if (we) begin
        hireg <= hi_i;
        loreg <= lo_i;
      end else begin
        hireg <= hireg;
        loreg <= loreg;
      end
    end
  end

  always @(*) begin
    if (cpu_rst_n == `RST_ENABLE) begin
      hi_o <= `ZERO_WORD;
      lo_o <= `ZERO_WORD;
    end else begin
      hi_o <= hireg;
      lo_o <= loreg;
    end
  end

endmodule
