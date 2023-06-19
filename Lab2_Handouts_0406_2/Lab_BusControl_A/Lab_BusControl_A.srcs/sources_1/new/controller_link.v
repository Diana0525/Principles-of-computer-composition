`timescale 1ns / 1ps

module controller_link(
    input BS,BR,
    output BG
    );
//BR→BG=1,BS→BG=0,当BG=1，之后要迅速撤回
assign BG = (!BS && BR)? 1:0;

endmodule
