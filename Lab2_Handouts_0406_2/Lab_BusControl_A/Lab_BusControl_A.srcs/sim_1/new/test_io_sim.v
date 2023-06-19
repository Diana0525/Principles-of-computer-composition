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
    .BG_in(BG_in), // �������豸������BG�ź�
    .BG_out(BG_out), // �������豸��BG�źţ���ʽ��
    .BR_in(BR_in),    // �ⲿ�������������
    .BR_out(BR_out),  // ��������������ź�
    .BS_out(BS_out),  // ���������æ�ź�
    .din(din), // �����ַ���ⲿ����
    .dout(dout),   // ���������ߵ����
    
    .ena(ena),
    .my_BG(my_BG),//��¼�ϼ�������BG�źţ���Ϊ�ϼ����ڴ����źź󳷻��ź�
    .already_BG_out(already_BG_out)//��¼�Ƿ񴫵ݹ�BG�ź�
    
    );
initial begin
    din = 4'b0001;
    BR_in = 1;
    #10 BG_in = 1;
    #100 BR_in = 0;
    
end
endmodule
