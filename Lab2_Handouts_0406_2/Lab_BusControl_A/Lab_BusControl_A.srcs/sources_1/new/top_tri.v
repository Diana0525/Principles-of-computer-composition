`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 17:59:09
// Design Name: 
// Module Name: top_tri
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


module top_tri(
input ena1,
    input ena2,
    input [3:0]din1,
    input [3:0]din2,
    output [3:0]dout
    );

tri_state u_tri_state(
    .a    (din1    ),
    .ena  (ena1  ),
    .dout (dout )
);

tri_state u_tri_state2(
    .a    (din2    ),
    .ena  (ena2  ),
    .dout (dout )
);
endmodule
