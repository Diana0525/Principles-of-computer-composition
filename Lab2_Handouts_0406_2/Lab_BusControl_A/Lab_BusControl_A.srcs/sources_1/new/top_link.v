`timescale 1ns / 1ps


module top_link(
    input [3:0]din_0, din_1, din_2, din_3,      // IO��������
    input BR_in_0, BR_in_1, BR_in_2, BR_in_3,   // IO����
    output [3:0] dbus_out                  // �����������
//    ,
//    output BG,
//    output BG_0,
//    output BG_1,
//    output BG_2,
//    output BG_3,
//    output BS_0,
//    output BS_1,
//    output BS_2,
//    output BS_3,
//    output BR_0,
//    output BR_1,
//    output BR_2,
//    output BR_3
    );  
wire BS_0;
wire BS_1;
wire BS_2;
wire BS_3;
wire BR_0;
wire BR_1;
wire BR_2;
wire BR_3;
wire BG_0;
wire BG_1;
wire BG_2;
wire BG_3;
wire BG;

// ʵ�����ĸ�IO�ӿڣ�ʵ����������������ɽ��߹���
io_interface_link s0(
    .BG_in(BG), // �������豸������BG�ź�
    .BG_out(BG_0), // �������豸��BG�źţ���ʽ��
    .BR_in(BR_in_0),    // �ⲿ�������������
    .BR_out(BR_0),  // ��������������ź�
    .BS_out(BS_0),  // ���������æ�ź�
    .din(din_0), // �����ַ���ⲿ����
    .dout(dbus_out)    // ���������ߵ����
    );
io_interface_link s1(
    .BG_in(BG_0), // �������豸������BG�ź�
    .BG_out(BG_1), // �������豸��BG�źţ���ʽ��
    .BR_in(BR_in_1),    // �ⲿ�������������
    .BR_out(BR_1),  // ��������������ź�
    .BS_out(BS_1),  // ���������æ�ź�
    .din(din_1), // �����ַ���ⲿ����
    .dout(dbus_out)    // ���������ߵ����
    );
io_interface_link s2(
    .BG_in(BG_1), // �������豸������BG�ź�
    .BG_out(BG_2), // �������豸��BG�źţ���ʽ��
    .BR_in(BR_in_2),    // �ⲿ�������������
    .BR_out(BR_2),  // ��������������ź�
    .BS_out(BS_2),  // ���������æ�ź�
    .din(din_2), // �����ַ���ⲿ����
    .dout(dbus_out)    // ���������ߵ����
    );
io_interface_link s3(
    .BG_in(BG_2), // �������豸������BG�ź�
    .BG_out(BG_3), // �������豸��BG�źţ���ʽ��
    .BR_in(BR_in_3),    // �ⲿ�������������
    .BR_out(BR_3),  // ��������������ź�
    .BS_out(BS_3),  // ���������æ�ź�
    .din(din_3), // �����ַ���ⲿ����
    .dout(dbus_out)    // ���������ߵ����
    );
controller_link c0(
    .BS(BS_0||BS_1||BS_2||BS_3),
    .BR(BR_0||BR_1||BR_2||BR_3),
    .BG(BG)
    );
endmodule
