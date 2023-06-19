`timescale 1ns / 1ps

module io_interface_link(
    input BG_in, // �������豸������BG�ź�
    output reg BG_out=0, // �������豸��BG�źţ���ʽ��
    input BR_in,    // �ⲿ�������������
    output reg BR_out = 0,  // ��������������ź�
    output reg BS_out = 0,  // ���������æ�ź�
    input [3:0]din, // �����ַ���ⲿ����
    output[3:0]dout   // ���������ߵ����
//    ,
//    output reg ena = 0,
//    output reg my_BG = 0,//��¼�ϼ�������BG�źţ���Ϊ�ϼ����ڴ����źź󳷻��ź�
//    output reg already_BG_out = 0//��¼�Ƿ񴫵ݹ�BG�ź�
    
    );
reg ena = 0;
reg my_BG = 0;//��¼�ϼ�������BG�źţ���Ϊ�ϼ����ڴ����źź󳷻��ź�
//reg already_BG_out = 0;//��¼�Ƿ񴫵ݹ�BG�ź�

assign dout = ena? din :4'bzzzz;//����������,����ʽ�����ź�BG�����IO�ӿ�
always @(*) begin
    BR_out = BR_in;
    if(BG_in && BR_in) begin
        ena = 1;
        BS_out = 1;
        my_BG = 1;
        BG_out = 0;
    end
    else if((my_BG || BG_in) && !BR_in) begin
        ena = 0;
        BS_out = 0;
        BG_out = 1;
        my_BG = 0;
    end
    if(!BG_in && !BR_in ) begin
        BG_out = 0;//���BG��������
    end
    else if(!BG_in && BR_in) begin
        
    end

end

endmodule
