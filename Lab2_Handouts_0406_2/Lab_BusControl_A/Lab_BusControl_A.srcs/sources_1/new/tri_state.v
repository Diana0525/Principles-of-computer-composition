`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 17:58:20
// Design Name: 
// Module Name: tri_state
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


module tri_state(
    input [3:0]a,
    input ena,
    output [3:0]dout
    );
    assign dout = ena ? a:4'bzzzz;    
endmodule

