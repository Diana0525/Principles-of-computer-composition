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
    .BR_in(BR_in_0),              // 外部输入的总线请求
    .BR_out(BR_out_0),         // 输出：总线请求信号
    .BS_out(BS_out_0),             // 输出：总线忙信号
    .din(din_0),           // 请求地址：外部输入
    .dout(dbus_out),          // 输出到总线上的数据
    .device_id(0),    // 设备地址（配置）
    .cnt_in(cnt)        // 计数器输入
    );
io_interface_counter s1(
    .clk(clk),
    .rst(rst),
    .BR_in(BR_in_1),              // 外部输入的总线请求
    .BR_out(BR_out_1),         // 输出：总线请求信号
    .BS_out(BS_out_1),             // 输出：总线忙信号
    .din(din_1),           // 请求地址：外部输入
    .dout(dbus_out),          // 输出到总线上的数据
    .device_id(1),    // 设备地址（配置）
    .cnt_in(cnt)        // 计数器输入
    );
io_interface_counter s2(
    .clk(clk),
    .rst(rst),
    .BR_in(BR_in_2),              // 外部输入的总线请求
    .BR_out(BR_out_2),         // 输出：总线请求信号
    .BS_out(BS_out_2),             // 输出：总线忙信号
    .din(din_2),           // 请求地址：外部输入
    .dout(dbus_out),          // 输出到总线上的数据
    .device_id(2),    // 设备地址（配置）
    .cnt_in(cnt)        // 计数器输入
    );
io_interface_counter s3(
    .clk(clk),
    .rst(rst),
    .BR_in(BR_in_3),              // 外部输入的总线请求
    .BR_out(BR_out_3),         // 输出：总线请求信号
    .BS_out(BS_out_3),             // 输出：总线忙信号
    .din(din_3),           // 请求地址：外部输入
    .dout(dbus_out),          // 输出到总线上的数据
    .device_id(3),    // 设备地址（配置）
    .cnt_in(cnt)        // 计数器输入
    );
controller_counter c0(
    .clk(clk),              // 时钟
    .rst(rst),              // 复位
    .BR(BR_out_0||BR_out_1||BR_out_2||BR_out_3),               // 总线请求线
    .BS(BS_out_0||BS_out_1||BS_out_2||BS_out_3),               // 总线繁忙信号
    .mode(mode),             // 计数模式
    // 1：从终止点开始的循环模式，0：从固定值开始的固定优先级模式
    .cnt_rstval(cnt_rstval), // 计数器的复位值
    .cnt(cnt)    // 计数器的输出值
    );
endmodule
