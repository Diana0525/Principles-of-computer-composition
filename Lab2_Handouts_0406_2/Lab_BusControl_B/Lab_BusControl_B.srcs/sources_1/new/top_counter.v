`timescale 1ns / 1ps


module top_counter(
    input clk,rst,
    input [3:0]din_0, din_1, din_2,din_3,
    input BR_in_0, BR_in_1, BR_in_2, BR_in_3,
    input mode,
    input [1:0]cnt_rstval,
    output [3:0] dbus_out
//    ,
//    output BR_out_0,BR_out_1,BR_out_2,BR_out_3,
//    output BS_out_0,BS_out_1,BS_out_2,BS_out_3,
//    output [1:0]cnt
    );
wire BR_out_0,BR_out_1,BR_out_2,BR_out_3;
wire BS_out_0,BS_out_1,BS_out_2,BS_out_3;
wire [1:0]cnt;

io_interface_counter s0(
    .clk(clk),
    .rst(rst),
    .BR_in(BR_in_0),              // �ⲿ�������������
    .BR_out(BR_out_0),         // ��������������ź�
    .BS_out(BS_out_0),             // ���������æ�ź�
    .din(din_0),           // �����ַ���ⲿ����
    .dout(dbus_out),          // ����������ϵ�����
    .device_id(0),    // �豸��ַ�����ã�
    .cnt_in(cnt)        // ����������
    );
io_interface_counter s1(
    .clk(clk),
    .rst(rst),
    .BR_in(BR_in_1),              // �ⲿ�������������
    .BR_out(BR_out_1),         // ��������������ź�
    .BS_out(BS_out_1),             // ���������æ�ź�
    .din(din_1),           // �����ַ���ⲿ����
    .dout(dbus_out),          // ����������ϵ�����
    .device_id(1),    // �豸��ַ�����ã�
    .cnt_in(cnt)        // ����������
    );
io_interface_counter s2(
    .clk(clk),
    .rst(rst),
    .BR_in(BR_in_2),              // �ⲿ�������������
    .BR_out(BR_out_2),         // ��������������ź�
    .BS_out(BS_out_2),             // ���������æ�ź�
    .din(din_2),           // �����ַ���ⲿ����
    .dout(dbus_out),          // ����������ϵ�����
    .device_id(2),    // �豸��ַ�����ã�
    .cnt_in(cnt)        // ����������
    );
io_interface_counter s3(
    .clk(clk),
    .rst(rst),
    .BR_in(BR_in_3),              // �ⲿ�������������
    .BR_out(BR_out_3),         // ��������������ź�
    .BS_out(BS_out_3),             // ���������æ�ź�
    .din(din_3),           // �����ַ���ⲿ����
    .dout(dbus_out),          // ����������ϵ�����
    .device_id(3),    // �豸��ַ�����ã�
    .cnt_in(cnt)        // ����������
    );
controller_counter c0(
    .clk(clk),              // ʱ��
    .rst(rst),              // ��λ
    .BR(BR_out_0||BR_out_1||BR_out_2||BR_out_3),               // ����������
    .BS(BS_out_0||BS_out_1||BS_out_2||BS_out_3),               // ���߷�æ�ź�
    .mode(mode),             // ����ģʽ
    // 1������ֹ�㿪ʼ��ѭ��ģʽ��0���ӹ̶�ֵ��ʼ�Ĺ̶����ȼ�ģʽ
    .cnt_rstval(cnt_rstval), // �������ĸ�λֵ
    .cnt(cnt)    // �����������ֵ
    );
endmodule
