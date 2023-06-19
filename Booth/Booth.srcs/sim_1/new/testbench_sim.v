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
    .clk(clk),        // ʱ���ź�
    .x(x),    // ����
    .y(y),    // ������
    .start(start),      // ��������ź�
    .z(z),  // ��
    .busy(busy)       // ��������ź�
    ,
    .minus_y(minus_y),//7λ����λ+2λ����λ
    .record_x(record_x),
    .record_y(record_y),//7+2λ����λ
    .count_move(count_move),
    .record_z(record_z),//n+2=16+2=18
    .control_move(control_move),//Ϊ�˱���������alwaysģ�鸳ֵmove�����м����
    .plus_y(plus_y),//=1���ʾ��ִ��+y�������
    .plus_minus_y(plus_minus_y)//=1���ʾ��ִ��+��-y���������
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
