`timescale 1ns / 1ps

module controller_link(
    input BS,BR,
    output BG
    );
//BR��BG=1,BS��BG=0,��BG=1��֮��ҪѸ�ٳ���
assign BG = (!BS && BR)? 1:0;

endmodule
