`timescale 1ns / 1ps

module controller_counter(
    input clk,              // ʱ��
    input rst,              // ��λ
    input BR,               // ����������
    input BS,               // ���߷�æ�ź�
    input mode,             // ����ģʽ
    // 1������ֹ�㿪ʼ��ѭ��ģʽ��0���ӹ̶�ֵ��ʼ�Ĺ̶����ȼ�ģʽ
    input [1:0] cnt_rstval, // �������ĸ�λֵ
    output reg [1:0] cnt    // �����������ֵ
    );
always @(posedge clk) begin
    if(rst) begin
        cnt <= cnt_rstval;
    end
    else if(mode  && !BS) begin
        cnt <= cnt+1;
    end
    else if(mode && BS) begin
        cnt <= cnt;
    end
    else if(!mode && !BS) begin
        cnt <= cnt+1;
    end
    else if(!mode && BS) begin
        cnt <= cnt;
    end
end
endmodule
