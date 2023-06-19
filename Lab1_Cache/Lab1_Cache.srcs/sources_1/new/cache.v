`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Cache���� ///////////////////////////////////////
// ӳ�䷽ʽ��ֱ������
// �����ֳ���1 Byte
// Cache���С��4 Bytes
// �����ַ��ȣ� 11 bit
// Cache������64 Lines * 4 Bytes/Line = 256 Bytes
// �滻���ԣ��ޣ�ֱ�����������滻���ԣ�
//////////////////////////////////////////////////////////////////////////////////


module cache(
    // ȫ���ź�
    input clk,
    input reset,
    // ��CPU���ķ����ź�
    input [10:0] raddr_from_cpu,     // CPU��Ķ���ַ
    input rreq_from_cpu,            // CPU���Ķ�����
    // ���²��ڴ�ģ�������ź�
    input [31:0] rdata_from_mem,     // �ڴ��ȡ������
    input rvalid_from_mem,          // �ڴ��ȡ���ݿ��ñ�־
    input wait_data_from_mem,       //����ź���Ƶĳ�����Ϊ��ǿ����������ȴ������������ʹ�á�
    // �����CPU���ź�
    output reg [7:0] rdata_to_cpu,      // �����CPU������
    output reg hit_to_cpu = 0,              // �����CPU�����б�־
    // ������²��ڴ�ģ����ź�
    output reg rreq_to_mem,         // ������²��ڴ�ģ��Ķ�����
    output reg [10:0] raddr_to_mem  // ������²�ģ����׵�ַ
    
    );
    //״̬��ʾ����
    reg success = 0;
    reg fail_hit = 0;
    reg [1:0]next_state = 2'b00,current_state = 2'b00;
    parameter   READY = 2'b00,//ready״̬�����Խ��շ�������
                TAG_CHECK = 2'b01,//tag_check״̬��cache�Զ���cache�н��б�ǩ����Ч�Լ��
                REFILL = 2'b10;//refill״̬��cache������ģ�鷢��������󣬵ȴ�������Ӧ�������ֿ鴫�������ֱ������֪ͨ�ֿ鴫����ɡ�
    reg already_to_refill = 0;

    always @ (posedge clk) begin
        if(reset)begin 
            current_state <= READY;
        end
        else if (!reset) begin 
            current_state <= next_state;
        end
    end

    always @ (*) begin
        case(current_state)
            READY:begin
                if(rreq_from_cpu)begin
                    next_state = TAG_CHECK;
                end
                else begin
                    next_state = READY;
                end
            end
            TAG_CHECK:begin
                if(hit_to_cpu) begin//�������
                    next_state = READY;
                end
                else if(fail_hit&&!already_to_refill) begin//δ����
                    next_state = REFILL;
                    already_to_refill = 1;
                end
                else begin
                    next_state = TAG_CHECK;
                end
            end
            REFILL:begin
                already_to_refill = 0;
                if(rvalid_from_mem)begin//��ȡ����ɹ�
                    next_state = TAG_CHECK;
                end
                else begin
                    next_state = REFILL;
                end
            end
            default:begin end
        endcase
    end
    //ʵ����IP��
    reg wait_br = 0;
    reg [1:0]wait_cache = 2'b0;
    reg [5:0] addra_in_cache = 6'b0;//�ֿ��ڵ�ַ
    reg [35:0] rdata_to_cache;//�ֿ���һ�е����ݣ���������������32λ���ݺ�4λtag,���Ϊ35��С��Ϊ0
    reg wea = 0;//����wea���ڽ����ݴ�����д��cache��
    wire [35:0] rdata_from_cache; //= {valid,raddr_from_cpu[10:8],rdata_from_mem[31:0]};//ͬ��
    blk_mem_gen_0 C(
      .clka(clk),    // input wire clka
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addra_in_cache),  // input wire [5 : 0] addra���ֿ��ڵ�ַ��,0~63,����64��
      .dina(rdata_to_cache),    // input wire [35 : 0] dina��32λ���ֿ����ݺ�4λ��tag
      .douta(rdata_from_cache)  // output wire [35 : 0] douta
    );
    always @ (posedge clk) begin
        if(wea) begin
            wea <= 0;
        end
        else if(hit_to_cpu) begin
            hit_to_cpu <= 0;
            rdata_to_cpu <=0;
            wait_br <= 0;
        end
        else if(current_state == READY && rreq_from_cpu && next_state == TAG_CHECK) begin
            addra_in_cache <= raddr_from_cpu[7:2];//���ܷ��ʵ�ַ
            wait_cache <= wait_cache +1;
        end
        else if(wait_cache != 2'b10 && current_state == TAG_CHECK && rreq_from_cpu && !hit_to_cpu) begin
         wait_cache <= wait_cache +1;
        end
        else if(current_state == TAG_CHECK && rreq_from_cpu && !hit_to_cpu && rdata_from_cache[34:32] == raddr_from_cpu[10:8] 
                && rdata_from_cache[35:35]&&wait_cache == 2'b10)begin//����
                hit_to_cpu <= 1;
                if(raddr_from_cpu[1:0] == 2'b00)begin rdata_to_cpu <= rdata_from_cache[7:0];end
                else if(raddr_from_cpu[1:0] == 2'b01)begin rdata_to_cpu <= rdata_from_cache[15:8];end
                else if(raddr_from_cpu[1:0] == 2'b10)begin rdata_to_cpu <= rdata_from_cache[23:16];end
                else if(raddr_from_cpu[1:0] == 2'b11)begin rdata_to_cpu <= rdata_from_cache[31:24];end
        end
        else if(current_state == TAG_CHECK &&(!rdata_from_cache[35:35] || rdata_from_cache[34:32] != raddr_from_cpu[10:8])&&!wait_br&& wait_cache == 2'b10) begin//δ����
                fail_hit <=1;
                end
        else if(rvalid_from_mem && current_state == REFILL) begin
            wea <= 1;
            addra_in_cache <= raddr_from_cpu[7:2];
            rdata_to_cache[31:0] <= rdata_from_mem;
            rdata_to_cache[34:32] <= raddr_from_cpu[10:8];
            rdata_to_cache[35:35] <= 1;
            fail_hit <= 0;//ȡ����δ���С�״̬
            rreq_to_mem <= 0;//����������������ط����ź�
            wait_br <= 1;//��־�Ŵ�refill�׶ζ������ݣ��ȴ�RAM BLOCK��Ӧ
        end
        else if(current_state == REFILL) begin
            rreq_to_mem <= 1;
            raddr_to_mem <= raddr_from_cpu;
        end
    end
// Your Code Here
 
endmodule
