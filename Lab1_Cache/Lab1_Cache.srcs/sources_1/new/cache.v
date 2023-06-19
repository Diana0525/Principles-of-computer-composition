`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Cache参数 ///////////////////////////////////////
// 映射方式：直接相联
// 数据字长：1 Byte
// Cache块大小：4 Bytes
// 主存地址宽度： 11 bit
// Cache容量：64 Lines * 4 Bytes/Line = 256 Bytes
// 替换策略：无（直接相联，无替换策略）
//////////////////////////////////////////////////////////////////////////////////


module cache(
    // 全局信号
    input clk,
    input reset,
    // 从CPU来的访问信号
    input [10:0] raddr_from_cpu,     // CPU來的读地址
    input rreq_from_cpu,            // CPU来的读请求
    // 从下层内存模块来的信号
    input [31:0] rdata_from_mem,     // 内存读取的数据
    input rvalid_from_mem,          // 内存读取数据可用标志
    input wait_data_from_mem,       //这个信号设计的初衷是为了强调“主存读等待”，大家酌情使用。
    // 输出给CPU的信号
    output reg [7:0] rdata_to_cpu,      // 输出给CPU的数据
    output reg hit_to_cpu = 0,              // 输出给CPU的命中标志
    // 输出给下层内存模块的信号
    output reg rreq_to_mem,         // 输出给下层内存模块的读请求
    output reg [10:0] raddr_to_mem  // 输出给下层模块的首地址
    
    );
    //状态表示参数
    reg success = 0;
    reg fail_hit = 0;
    reg [1:0]next_state = 2'b00,current_state = 2'b00;
    parameter   READY = 2'b00,//ready状态：可以接收访问请求
                TAG_CHECK = 2'b01,//tag_check状态：cache对读出cache行进行标签和有效性检查
                REFILL = 2'b10;//refill状态：cache对主存模块发起访问请求，等待主存相应的连续字块传输回来，直到主存通知字块传输完成。
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
                if(hit_to_cpu) begin//如果命中
                    next_state = READY;
                end
                else if(fail_hit&&!already_to_refill) begin//未命中
                    next_state = REFILL;
                    already_to_refill = 1;
                end
                else begin
                    next_state = TAG_CHECK;
                end
            end
            REFILL:begin
                already_to_refill = 0;
                if(rvalid_from_mem)begin//读取主存成功
                    next_state = TAG_CHECK;
                end
                else begin
                    next_state = REFILL;
                end
            end
            default:begin end
        endcase
    end
    //实例化IP核
    reg wait_br = 0;
    reg [1:0]wait_cache = 2'b0;
    reg [5:0] addra_in_cache = 6'b0;//字块内地址
    reg [35:0] rdata_to_cache;//字块内一行的数据，包括从主存读入的32位数据和4位tag,大端为35，小端为0
    reg wea = 0;//拉高wea用于将数据从主存写入cache中
    wire [35:0] rdata_from_cache; //= {valid,raddr_from_cpu[10:8],rdata_from_mem[31:0]};//同上
    blk_mem_gen_0 C(
      .clka(clk),    // input wire clka
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addra_in_cache),  // input wire [5 : 0] addra，字块内地址线,0~63,代表64行
      .dina(rdata_to_cache),    // input wire [35 : 0] dina，32位的字块数据和4位的tag
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
            addra_in_cache <= raddr_from_cpu[7:2];//接受访问地址
            wait_cache <= wait_cache +1;
        end
        else if(wait_cache != 2'b10 && current_state == TAG_CHECK && rreq_from_cpu && !hit_to_cpu) begin
         wait_cache <= wait_cache +1;
        end
        else if(current_state == TAG_CHECK && rreq_from_cpu && !hit_to_cpu && rdata_from_cache[34:32] == raddr_from_cpu[10:8] 
                && rdata_from_cache[35:35]&&wait_cache == 2'b10)begin//命中
                hit_to_cpu <= 1;
                if(raddr_from_cpu[1:0] == 2'b00)begin rdata_to_cpu <= rdata_from_cache[7:0];end
                else if(raddr_from_cpu[1:0] == 2'b01)begin rdata_to_cpu <= rdata_from_cache[15:8];end
                else if(raddr_from_cpu[1:0] == 2'b10)begin rdata_to_cpu <= rdata_from_cache[23:16];end
                else if(raddr_from_cpu[1:0] == 2'b11)begin rdata_to_cpu <= rdata_from_cache[31:24];end
        end
        else if(current_state == TAG_CHECK &&(!rdata_from_cache[35:35] || rdata_from_cache[34:32] != raddr_from_cpu[10:8])&&!wait_br&& wait_cache == 2'b10) begin//未命中
                fail_hit <=1;
                end
        else if(rvalid_from_mem && current_state == REFILL) begin
            wea <= 1;
            addra_in_cache <= raddr_from_cpu[7:2];
            rdata_to_cache[31:0] <= rdata_from_mem;
            rdata_to_cache[34:32] <= raddr_from_cpu[10:8];
            rdata_to_cache[35:35] <= 1;
            fail_hit <= 0;//取消“未命中”状态
            rreq_to_mem <= 0;//访问主存结束，撤回访问信号
            wait_br <= 1;//标志着从refill阶段读出数据，等待RAM BLOCK反应
        end
        else if(current_state == REFILL) begin
            rreq_to_mem <= 1;
            raddr_to_mem <= raddr_from_cpu;
        end
    end
// Your Code Here
 
endmodule
