`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 22:36:57
// Design Name: 
// Module Name: test_io_sim
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


module test_io_sim();
reg BG_in,BR_in;
reg [3:0]din;
wire BG_out,BR_out,BS_out;
wire [3:0]dout;
wire ena,my_BG,already_BG_out;

io_interface_link i0(
    .BG_in(BG_in), // 由其他设备进来的BG信号
    .BG_out(BG_out), // 给其他设备的BG信号（链式）
    .BR_in(BR_in),    // 外部输入的总线请求
    .BR_out(BR_out),  // 输出：总线请求信号
    .BS_out(BS_out),  // 输出：总线忙信号
    .din(din), // 请求地址：外部输入
    .dout(dout),   // 到数据总线的输出
    
    .ena(ena),
    .my_BG(my_BG),//记录上级传来的BG信号，因为上级会在传输信号后撤回信号
    .already_BG_out(already_BG_out)//记录是否传递过BG信号
    
    );
initial begin
    din = 4'b0001;
    BR_in = 1;
    #10 BG_in = 1;
    #100 BR_in = 0;
    
end
endmodule
