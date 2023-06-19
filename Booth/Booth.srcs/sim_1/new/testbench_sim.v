`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/15 16:36:09
// Design Name: 
// Module Name: testbench_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_sim();
reg clk;
reg [7:0]x,y;
reg start;
wire [15:0]z;
wire busy;
wire [8:0]minus_y,record_x,record_y;
wire [2:0]count_move;
wire [17:0]record_z;
wire control_move;
wire plus_y;
wire plus_minus_y;
booth bo1(
    .clk(clk),        // 时钟信号
    .x(x),    // 乘数
    .y(y),    // 被乘数
    .start(start),      // 输入就绪信号
    .z(z),  // 积
    .busy(busy)       // 输出就绪信号
    ,
    .minus_y(minus_y),//7位数据位+2位符号位
    .record_x(record_x),
    .record_y(record_y),//7+2位符号位
    .count_move(count_move),
    .record_z(record_z),//n+2=16+2=18
    .control_move(control_move),//为了避免在两个always模块赋值move引入中间变量
    .plus_y(plus_y),//=1则表示将执行+y补码操作
    .plus_minus_y(plus_minus_y)//=1则表示将执行+（-y）补码操作
    );
    
initial begin
    clk = 0;
    start = 1;
    x = 8'b11111111;
    y = 8'b11111111;
//    x = 8'b10011110;
//    y = 8'b10110010;
    #20 start = 0;
        x = 0;
        y = 0;
        
end

always begin
    #10 clk = ~clk;
end
endmodule
