`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/02 11:02:56
// Design Name: 
// Module Name: booth
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


module booth(
    input clk,        // ʱ���ź�
    input [7:0] x,    // ����
    input [7:0] y,    // ������
    input start,      // ��������ź�
    output reg [15:0] z,  // ��
    output reg busy       // ��������ź�
//    ,
//    output reg [8:0]minus_y,//7λ����λ+2λ����λ
//    output reg [8:0]record_x,
//    output reg [8:0]record_y,//7+2λ����λ
//    output reg [2:0]count_move = 3'b0,
//    output reg [17:0]record_z,//2n+4=14+4=18
//    output reg control_move=0,//Ϊ�˱���������alwaysģ�鸳ֵmove�����м����
//    output reg plus_y=0,//=1���ʾ��ִ��+y�������
//    output reg plus_minus_y=0//=1���ʾ��ִ��+��-y���������
    );
    reg [8:0]minus_y;//7λ����λ+2λ����λ
    reg [8:0]record_x;
    reg [8:0]record_y;//7+2λ����λ
    reg [2:0]count_move = 3'b0;//��¼�ƶ����������ƶ�7��
    reg [17:0]record_z;//n+2=16+2=18
    reg control_move=0;//Ϊ�˱���������alwaysģ�鸳ֵmove�����м����
    reg plus_y=0;//=1���ʾ��ִ��+y�������
    reg plus_minus_y=0;//=1���ʾ��ִ��+��-y���������

    reg only_move = 0;//=1��ʾ���ֻ��Ҫ��λ������Ҫ���мӷ�����
    reg [3:0]count_add =4'b0;//��¼�ӷ������������7+1=8��
    reg record_start=0;//��ʼ��ֻ�ó�ʼ��һ��
    always @(posedge clk) begin
        if(!busy) begin
            count_add <= 4'b0;
        end
        if(plus_y)begin
            plus_y <=0;
        end
        else if(plus_minus_y) begin
            plus_minus_y <=0;
        end
        else if(only_move) begin
            only_move <=0;
        end
        if(record_z[0]>record_z[1] && busy && count_add<4'b1000)begin
            record_z[17:9] <= record_z[17:9]+record_y[8:0];
            plus_y <= 1;
            count_add <= count_add+1;
        end
        else if(record_z[0]<record_z[1] && busy && count_add<4'b1000)begin
            record_z[17:9] <= record_z[17:9]+minus_y[8:0];
            plus_minus_y <= 1;
            count_add <= count_add+1;
        end
        else if(record_z[0]==record_z[1] && busy && count_add<4'b1000) begin
            only_move <=1;
            count_add <= count_add+1;
        end
        
    end
    always @(*) begin
        if(start && !record_start)begin//�ӵ��źź��¼��xy��ֵ���������-y�Ĳ���
            record_x[7:0] = x;
            record_x[8] = x[7];
            record_y[7:0] = y[7:0];
            record_y[8] = y[7];//�ڶ�λ����λ���һλ����λһ��
            minus_y[7:0] = ~y+1;
            minus_y[8] = ~y[7];
            busy = 1;//����һ��ʱ�ӵ������ؾͿ��Կ�ʼ����
            record_z[17:9] = 9'b0;
            record_z[8:1] = x[7:0];//������λ
            record_z[0] = 0;//��ʼ�����ֻ�ĩλΪ0
            record_start = 1;
        end
        else if(!start) begin
            record_start = 0;
        end
        if(!clk && control_move==0 && busy && count_move<3'b111 && (only_move || plus_minus_y || plus_y)) begin//������λ�����ֻ��ͳ�������һλ����λ�ƶ�6��
            record_z[17:0] = record_z[17:0]>>1;
            record_z[17] = record_z[16];//����ʱ���λ�Զ���0���ϣ���ʱ�����λ���ڴθ�λ
            control_move = 1;
            count_move = count_move +1;//�ƶ�һ�μ���һ��
        end
        else if(clk && control_move==1 && busy && count_move<3'b111) begin
            control_move = 0;
        end
        if(count_add == 4'b1000 && busy) begin
            busy = 0;
            z = record_z[17:2];
        end
        if(!busy) begin
            count_move = 4'b0;
        end
    end
    // �ڴ˴���д��Ĵ���
endmodule
