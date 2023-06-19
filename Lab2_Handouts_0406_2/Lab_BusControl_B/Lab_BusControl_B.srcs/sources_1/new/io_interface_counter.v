`timescale 1ns / 1ps

module io_interface_counter(
    input clk,
    input rst,
    input   BR_in,              // �ⲿ�������������
    output  BR_out,         // ��������������ź�
    output  reg BS_out = 0,             // ���������æ�ź�
    input   [3:0]din,           // �����ַ���ⲿ����
    output  [3:0]dout,          // ����������ϵ�����
    input   [1:0] device_id,    // �豸��ַ�����ã�
    input   [1:0] cnt_in        // ����������
    );
reg ena=0;
assign dout = ena?din:4'bzzzz;
assign BR_out = BR_in;
// ��ʹ������ʱ�������������̬��z)
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
