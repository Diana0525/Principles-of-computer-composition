`timescale 1ns / 1ps


module top_link(
    input [3:0]din_0, din_1, din_2, din_3,      // IO数据输入
    input BR_in_0, BR_in_1, BR_in_2, BR_in_3,   // IO请求
    output [3:0] dbus_out                  // 数据总线输出
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

// 实例化四个IO接口，实例化控制器，并完成接线工作
io_interface_link s0(
    .BG_in(BG), // 由其他设备进来的BG信号
    .BG_out(BG_0), // 给其他设备的BG信号（链式）
    .BR_in(BR_in_0),    // 外部输入的总线请求
    .BR_out(BR_0),  // 输出：总线请求信号
    .BS_out(BS_0),  // 输出：总线忙信号
    .din(din_0), // 请求地址：外部输入
    .dout(dbus_out)    // 到数据总线的输出
    );
io_interface_link s1(
    .BG_in(BG_0), // 由其他设备进来的BG信号
    .BG_out(BG_1), // 给其他设备的BG信号（链式）
    .BR_in(BR_in_1),    // 外部输入的总线请求
    .BR_out(BR_1),  // 输出：总线请求信号
    .BS_out(BS_1),  // 输出：总线忙信号
    .din(din_1), // 请求地址：外部输入
    .dout(dbus_out)    // 到数据总线的输出
    );
io_interface_link s2(
    .BG_in(BG_1), // 由其他设备进来的BG信号
    .BG_out(BG_2), // 给其他设备的BG信号（链式）
    .BR_in(BR_in_2),    // 外部输入的总线请求
    .BR_out(BR_2),  // 输出：总线请求信号
    .BS_out(BS_2),  // 输出：总线忙信号
    .din(din_2), // 请求地址：外部输入
    .dout(dbus_out)    // 到数据总线的输出
    );
io_interface_link s3(
    .BG_in(BG_2), // 由其他设备进来的BG信号
    .BG_out(BG_3), // 给其他设备的BG信号（链式）
    .BR_in(BR_in_3),    // 外部输入的总线请求
    .BR_out(BR_3),  // 输出：总线请求信号
    .BS_out(BS_3),  // 输出：总线忙信号
    .din(din_3), // 请求地址：外部输入
    .dout(dbus_out)    // 到数据总线的输出
    );
controller_link c0(
    .BS(BS_0||BS_1||BS_2||BS_3),
    .BR(BR_0||BR_1||BR_2||BR_3),
    .BG(BG)
    );
endmodule
