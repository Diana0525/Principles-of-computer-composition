`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 18:00:04
// Design Name: 
// Module Name: tri_sim
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


module tri_sim();
reg ena1,ena2;
reg [3:0] din1,din2;
wire [3:0] dout;
top_tri t0(
    .ena1(ena1),
    .ena2(ena2),
    .din1(din1),
    .din2(din2),
    .dout(dout)
    );
initial begin
    ena2 = 0;
    #10 ena1 = 1;
        din1 = 4'b1111;
    #50 ena1 = 0;
    #10 ena2 = 1;
        din2 = 4'b0001;
    #10 ena2 = 0;
        ena1 = 1;
        din1 = 4'b1111;
end
endmodule
