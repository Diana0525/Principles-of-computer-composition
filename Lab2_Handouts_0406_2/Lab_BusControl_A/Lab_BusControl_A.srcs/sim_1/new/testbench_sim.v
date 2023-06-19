`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 14:17:52
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
reg [3:0]din_0, din_1, din_2, din_3;
reg BR_in_0, BR_in_1, BR_in_2, BR_in_3;
wire [3:0] dbus_out;
wire BG,BG_0,BG_1,BG_2,BG_3,BS_0,BS_1,BS_2,BS_3,BR_0,BR_1,BR_2,BR_3;
top_link ut0(
    .din_0(din_0), 
    .din_1(din_1), 
    .din_2(din_2), 
    .din_3(din_3), 
    .BR_in_0(BR_in_0), 
    .BR_in_1(BR_in_1), 
    .BR_in_2(BR_in_2), 
    .BR_in_3(BR_in_3),
    .dbus_out(dbus_out),
    .BG(BG),
    .BG_0(BG_0),
    .BG_1(BG_1),
    .BG_2(BG_2),
    .BG_3(BG_3),
    .BS_0(BS_0),
    .BS_1(BS_1),
    .BS_2(BS_2),
    .BS_3(BS_3),
    .BR_0(BR_0),
    .BR_1(BR_1),
    .BR_2(BR_2),
    .BR_3(BR_3)
    ); 

initial begin
    #10 din_0 = 4'b0000;
        din_1 = 4'b0001;
        din_2 = 4'b0010;
        din_3 = 4'b0011;
        
    #50 BR_in_0 = 0;
        BR_in_1 = 0;
        BR_in_2 = 1;
        BR_in_3 = 1;
    #50 BR_in_2 = 0;
    #50 BR_in_3 = 0; 
       
    #50 BR_in_0 = 0;
        BR_in_1 = 1;
        BR_in_2 = 1;
        BR_in_3 = 0;
    #50 BR_in_1 = 0;    
    #50 BR_in_2 = 0;
//    #50 BR_in_2 = 0;
//    #50 BR_in_3 = 0;
    
    #50 BR_in_0 = 0;
        BR_in_1 = 1;
        BR_in_2 = 0;
        BR_in_3 = 1;
    #50 BR_in_1 = 0;
    #50 BR_in_3 = 0;

        
end
endmodule
