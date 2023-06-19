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
    input clk,        // 时钟信号
    input [7:0] x,    // 乘数
    input [7:0] y,    // 被乘数
    input start,      // 输入就绪信号
    output reg [15:0] z,  // 积
    output reg busy       // 输出就绪信号
//    ,
//    output reg [8:0]minus_y,//7位数据位+2位符号位
//    output reg [8:0]record_x,
//    output reg [8:0]record_y,//7+2位符号位
//    output reg [2:0]count_move = 3'b0,
//    output reg [17:0]record_z,//2n+4=14+4=18
//    output reg control_move=0,//为了避免在两个always模块赋值move引入中间变量
//    output reg plus_y=0,//=1则表示将执行+y补码操作
//    output reg plus_minus_y=0//=1则表示将执行+（-y）补码操作
    );
    reg [8:0]minus_y;//7位数据位+2位符号位
    reg [8:0]record_x;
    reg [8:0]record_y;//7+2位符号位
    reg [2:0]count_move = 3'b0;//记录移动次数，共移动7次
    reg [17:0]record_z;//n+2=16+2=18
    reg control_move=0;//为了避免在两个always模块赋值move引入中间变量
    reg plus_y=0;//=1则表示将执行+y补码操作
    reg plus_minus_y=0;//=1则表示将执行+（-y）补码操作

    reg only_move = 0;//=1表示这次只需要移位而不需要进行加法运算
    reg [3:0]count_add =4'b0;//记录加法运算次数，共7+1=8次
    reg record_start=0;//初始化只用初始化一次
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
        if(start && !record_start)begin//接到信号后记录下xy的值，并计算出-y的补码
            record_x[7:0] = x;
            record_x[8] = x[7];
            record_y[7:0] = y[7:0];
            record_y[8] = y[7];//第二位符号位与第一位符号位一致
            minus_y[7:0] = ~y+1;
            minus_y[8] = ~y[7];
            busy = 1;//在下一个时钟的上升沿就可以开始运算
            record_z[17:9] = 9'b0;
            record_z[8:1] = x[7:0];//乘数就位
            record_z[0] = 0;//初始化部分积末位为0
            record_start = 1;
        end
        else if(!start) begin
            record_start = 0;
        end
        if(!clk && control_move==0 && busy && count_move<3'b111 && (only_move || plus_minus_y || plus_y)) begin//控制移位，部分积和乘数右移一位，移位移动6次
            record_z[17:0] = record_z[17:0]>>1;
            record_z[17] = record_z[16];//右移时最高位自动用0补上，此时将最高位等于次高位
            control_move = 1;
            count_move = count_move +1;//移动一次计数一次
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
    // 在此处编写你的代码
endmodule
