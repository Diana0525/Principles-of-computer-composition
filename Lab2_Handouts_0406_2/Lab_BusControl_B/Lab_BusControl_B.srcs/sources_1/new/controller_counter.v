`timescale 1ns / 1ps

module controller_counter(
    input clk,              // 时钟
    input rst,              // 复位
    input BR,               // 总线请求线
    input BS,               // 总线繁忙信号
    input mode,             // 计数模式
    // 1：从终止点开始的循环模式，0：从固定值开始的固定优先级模式
    input [1:0] cnt_rstval, // 计数器的复位值
    output reg [1:0] cnt    // 计数器的输出值
    );
always @(posedge clk) begin
    if(rst) begin
        cnt <= cnt_rstval;
    end
    else if(mode  && !BS) begin
        cnt <= cnt+1;
    end
    else if(mode && BS) begin
        cnt <= cnt;
    end
    else if(!mode && !BS) begin
        cnt <= cnt+1;
    end
    else if(!mode && BS) begin
        cnt <= cnt;
    end
end
endmodule
