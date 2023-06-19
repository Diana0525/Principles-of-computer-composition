`timescale 1ns / 1ps

module io_interface_counter(
    input clk,
    input rst,
    input   BR_in,              // 外部输入的总线请求
    output  BR_out,         // 输出：总线请求信号
    output  reg BS_out = 0,             // 输出：总线忙信号
    input   [3:0]din,           // 请求地址：外部输入
    output  [3:0]dout,          // 输出到总线上的数据
    input   [1:0] device_id,    // 设备地址（配置）
    input   [1:0] cnt_in        // 计数器输入
    );
reg ena=0;
assign dout = ena?din:4'bzzzz;
assign BR_out = BR_in;
// 不使用总线时，必须输出高阻态（z)
always @(*) begin
    if(rst)begin
        ena = 0;
        BS_out = 0;
    end
    if(BR_in && cnt_in==device_id) begin
        ena = 1;
        BS_out = 1;
    end
    else if(!BR_in && cnt_in==device_id) begin
        ena = 0;
        BS_out = 0;
    end
end

endmodule
