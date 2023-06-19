`timescale 1ns / 1ps

module io_interface_link(
    input BG_in, // 由其他设备进来的BG信号
    output reg BG_out=0, // 给其他设备的BG信号（链式）
    input BR_in,    // 外部输入的总线请求
    output reg BR_out = 0,  // 输出：总线请求信号
    output reg BS_out = 0,  // 输出：总线忙信号
    input [3:0]din, // 请求地址：外部输入
    output[3:0]dout   // 到数据总线的输出
//    ,
//    output reg ena = 0,
//    output reg my_BG = 0,//记录上级传来的BG信号，因为上级会在传输信号后撤回信号
//    output reg already_BG_out = 0//记录是否传递过BG信号
    
    );
reg ena = 0;
reg my_BG = 0;//记录上级传来的BG信号，因为上级会在传输信号后撤回信号
//reg already_BG_out = 0;//记录是否传递过BG信号

assign dout = ena? din :4'bzzzz;//有总线请求,且链式请求信号BG到达该IO接口
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
        BG_out = 0;//清空BG线上数据
    end
    else if(!BG_in && BR_in) begin
        
    end

end

endmodule
