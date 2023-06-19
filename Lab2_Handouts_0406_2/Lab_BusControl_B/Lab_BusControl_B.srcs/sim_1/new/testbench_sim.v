`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/10 13:36:16
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
reg clk,rst;
reg [3:0]din_0, din_1, din_2,din_3;
reg BR_in_0, BR_in_1, BR_in_2, BR_in_3;
reg mode;
reg [1:0]cnt_rstval;
wire [3:0] dbus_out;
wire BR_out_0,BR_out_1,BR_out_2,BR_out_3,BS_out_0,BS_out_1,BS_out_2,BS_out_3;
wire [1:0]cnt;
top_counter t0(
    .clk(clk),.rst(rst),
    .din_0(din_0),.din_1(din_1),.din_2(din_2),.din_3(din_3),
    .BR_in_0(BR_in_0),.BR_in_1(BR_in_1),.BR_in_2(BR_in_2),.BR_in_3(BR_in_3),
    .mode(mode),
    .cnt_rstval(cnt_rstval),
    .dbus_out(dbus_out)
    ,
    .BR_out_0(BR_out_0),.BR_out_1(BR_out_1),.BR_out_2(BR_out_2),.BR_out_3(BR_out_3),
    .BS_out_0(BS_out_0),.BS_out_1(BS_out_1),.BS_out_2(BS_out_2),.BS_out_3(BS_out_3),
    .cnt(cnt)
    );

initial begin
    clk = 0;
    rst = 1;
    mode = 1;
    cnt_rstval = 0;
    din_0 = 0;
    din_1 = 1;
    din_2 = 2;
    din_3 = 3;
    BR_in_0 = 0;
    BR_in_1 = 0;
    BR_in_2 = 1;
    BR_in_3 = 1;
    #50 rst = 0;
    #100 BR_in_2 = 0;
    #50 BR_in_3 = 0;
    
    #50 rst = 1;
        cnt_rstval = 3;
    #50 rst = 0;
    #50 BR_in_3 = 1;
        BR_in_0 = 1;
    #50 BR_in_3 = 0;
    #50 BR_in_0 = 0;
        
end

always begin
    # 10 clk = ~clk;
end
endmodule
