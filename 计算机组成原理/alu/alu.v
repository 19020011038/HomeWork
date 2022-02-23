`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: alu.v
//   > ����  ��ALUģ�飬����12�ֲ���
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module alu(
    input  [11:0] alu_control, 
    input  [31:0] alu_src1, 
    input  [31:0] alu_src2,
    output   [31:0] alu_result 
    );
    reg [31:0] alu_result;
    wire alu_add;   //�ӷ�
    wire alu_sub;   //����
    wire alu_slt;   //�з��űȽϣ�С����λ
    wire alu_sltu;  //�޷��űȽϣ�С����λ
    wire alu_and;   //��λ��
    wire alu_nor;   //��λ���
    wire alu_or;    //��λ�� 
    wire alu_xor;   //��λ���
    wire alu_sll;   //�߼�����
    wire alu_srl;   //�߼�����
    wire alu_sra;   //��������
    wire alu_lui;   //��λ����

    assign alu_add  = alu_control[11];
    assign alu_sub  = alu_control[10];
    assign alu_slt  = alu_control[ 9];
    assign alu_sltu = alu_control[ 8];
    assign alu_and  = alu_control[ 7];
    assign alu_nor  = alu_control[ 6];
    assign alu_or   = alu_control[ 5];
    assign alu_xor  = alu_control[ 4];
    assign alu_sll  = alu_control[ 3];
    assign alu_srl  = alu_control[ 2];
    assign alu_sra  = alu_control[ 1];
    assign alu_lui  = alu_control[ 0];

    wire [31:0] add_sub_result; //�Ӽ�����������üӷ���ʵ��
    wire [31:0] slt_result;     //
    wire [31:0] sltu_result;    //
    wire [31:0] and_result;
    wire [31:0] nor_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;
    wire [31:0] sll_result;
    wire [31:0] srl_result;
    wire [31:0] sra_result;     //
    wire [31:0] lui_result;

    wire signed [31:0] temp_src1;   //������������ʱ����
    assign temp_src1 = alu_src1;    //��������alu_src1������������
    
    assign and_result = alu_src1 & alu_src2;        //��λ��
    assign or_result  = alu_src1 | alu_src2;        //��λ��
    assign nor_result = ~or_result;                 //���
    assign xor_result = alu_src1 ^ alu_src2;        //���
    assign lui_result = {alu_src2[15:0], 16'd0};    //��λ���أ��ڶ����������ĵ�ʮ��λ���ص���ʮ��λ��
    assign sll_result = alu_src1 << alu_src2;       //�߼�����
    assign srl_result = alu_src1 >> alu_src2;       //�߼�����
    assign slt_result = adder_result[31] ? 1'b1 : 1'b0;   // ��������С����λ
    assign sltu_result = adder_cout ? 1'b0 : 1'b1;     //�޷�����С����λ
    assign sra_result = temp_src1 >>> alu_src2;     //��������

    wire [31:0] adder_operand1;
    wire [31:0] adder_operand2;
    wire        adder_cin     ;
    wire [31:0] adder_result  ;
    wire        adder_cout    ;
    assign adder_operand1 = alu_src1; 
    assign adder_operand2 = alu_add ? alu_src2 : ~alu_src2;     //Ĭ�Ͻ��м�����Ϊslt��sltu����
    assign adder_cin      = ~alu_add;  //����Ҷ���Ϊ������bug
    adder adder_module(     //���üӷ�ģ��
    .operand1(adder_operand1),
    .operand2(adder_operand2),
    .cin     (adder_cin     ),
    .result  (adder_result  ),
    .cout    (adder_cout    )
    );
    
    
assign add_sub_result = adder_result;

	always@(*)
	begin

        if(alu_add | alu_sub)  //����Ǽӷ����߼�����������ѼӼ������add_sub_result����alu���յ�������alu_result��
            alu_result <= add_sub_result;
            else if(alu_slt)  //������з��űȽϣ�����з��űȽϽ��slt_result����alu���յ�������alu_result��
            alu_result <= slt_result;
            else if(alu_sltu)  //������޷��űȽϣ�����޷��űȽϽ��sltu_result����alu���յ�������alu_result��
            alu_result <= sltu_result;
            else if(alu_and)  //����ǰ�λ���������Ѱ�λ��������and_result����alu���յ�������alu_result��
            alu_result <= and_result;
            else if(alu_nor)  //����ǰ�λ��ǲ�������Ѱ�λ��ǲ������nor_result����alu���յ�������alu_result��
            alu_result <= nor_result;
            else if(alu_or)  //����ǰ�λ���������Ѱ�λ��������or_result����alu���յ�������alu_result��
            alu_result <= or_result;
            else if(alu_xor)  //����ǰ�λ����������Ѱ�λ���������xor_result����alu���յ�������alu_result��
            alu_result <= xor_result;
            else if(alu_sll)  //������߼����Ʋ���������߼����ƵĽ��alu_sll����alu���յ�������alu_result��
            alu_result <= sll_result;
            else if(alu_srl)  //������߼����Ʋ���������߼����ƵĽ��alu_srl����alu���յ�������alu_result��
            alu_result <= srl_result;
            else if(alu_sra)  //������������Ʋ���������������ƵĽ��alu_sra����alu���յ�������alu_result��
            alu_result <= sra_result;
            else if(alu_lui)  //����Ǹ�λ���ز�������Ѹ�λ���ز����Ľ��lui_result����alu���յ�������alu_result��
            alu_result <= lui_result;
         
	end
	
	
endmodule
