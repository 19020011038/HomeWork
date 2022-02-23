`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: regfile.v
//   > ����  ���Ĵ�����ģ�飬ͬ��д���첽��
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module regfile(
    input             clk,      //ʱ�ӿ����ź�
    input             wen,      //дʹ���źţ�1��Ч
    input      [4 :0] raddr1,   //��һ�����˿ڵĵ�ַ
    input      [4 :0] raddr2,   //�ڶ������˿ڵĵ�ַ
    input      [4 :0] waddr,    //һ��д�˿�
    input      [31:0] wdata,    //��Ҫд�������
    output  [31:0] rdata1,   //����������1
    output  [31:0] rdata2,   //����������2
    input      [4 :0] test_addr,    //����ĵ��Ե�ַ
    output  [31:0] test_data     //�����������
    );
    
    //���ڴ˴���Ӵ���
    
    //�ܹ�32���Ĵ���
integer i = 0;
reg [31:0] REG_Files[31:0];
	initial//��ʼ��32���Ĵ�����ȫΪ0
        for(i = 0;i < 32;i = i + 1) 
        REG_Files[i]<=0;
	always @ (posedge clk)
	begin
	   if(wen)
	   REG_Files[waddr] <= wdata;
	end
	assign rdata1 = REG_Files[raddr1] ;
	assign rdata2 = REG_Files[raddr2];
	assign test_data  = REG_Files[test_addr];
endmodule

