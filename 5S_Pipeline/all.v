`include "Execution_unit.v"
`include "if_unit.v"
`include "memoryut.v"
`include "id_unit.v"
`include "wb_unit.v"

module Exe_mem;
    reg clk,checkwdata_wb; 
    reg [7:0] pc;
    reg [19:0] current_instruction;
    reg [15:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8;    
    reg [7:0] npc_in, imm, npci,jump_address_reg;
    reg [15:0] op1, op2, AluOutput_reg;
    reg [3:0] ldsti, regdesti, instructioni, regNos_reg;
    reg [3:0] inst;
    reg [0:0] jump_selector_reg;
    reg [15:0] aluoutput, Data_from_mem;
    reg [3:0] linenum;
    reg [3:0] registernum;
    reg [15:0] wdatareg;
    reg done;

    wire clkwire;
    wire [19: 0] ciwire;
    wire [15:0] regwire1, regwire2, regwire3, regwire4, regwire5, regwire6, regwire7, regwire8;
    wire [15:0] reg1_out, reg2_out, reg3_out, reg4_out, reg5_out, reg6_out, reg7_out, reg8_out;
    wire [15:0] reg_data_1_wire, reg_data_2_wire, ALU_output, AluOutput; 
    wire [3:0] instruction_4_bits, regNos, dest_reg_wire, regdest, ldst, instruction,  memwire;
    wire [7:0] instrwire, npc_out, npc, npcwire, jump_address, jump_address_exe;
    wire [15:0] wdata;
    wire [3:0] regnum, opcode_out;
    wire[15:0] wdataregw;
    wire checkwdata, jump_selector, jump_selector_exe;

    integer i;

    assign wdataregw = wdatareg;
    assign clkwire = clk;
    assign regwire1 = reg1;
    assign regwire2 = reg2;
    assign regwire3 = reg3;
    assign regwire4 = reg4;
    assign regwire5 = reg5;
    assign regwire6 = reg6;
    assign regwire7 = reg7;
    assign regwire8 = reg8;
    assign regNos = regNos_reg;
    assign AluOutput = AluOutput_reg;
    assign jump_selector = jump_selector_reg;
    assign jump_address = jump_address_reg;


    if_unit iftest(
        .clkwire(clkwire), 
        .jump_selector(jump_selector), 
        .jump_address(jump_address), 
        .instructionwire(ciwire)
        );

    id_unit S2(
        .clkwire(clkwire),
        .regwire1(reg1), 
        .regwire2(reg2), 
        .regwire3(reg3), 
        .regwire4(reg4), 
        .regwire5(reg5), 
        .regwire6(reg6), 
        .regwire7(reg7), 
        .regwire8(reg8), 
        .current_instruction(current_instruction), 
        .reg_data_1_wire(reg_data_1_wire), 
        .reg_data_2_wire(reg_data_2_wire), 
        .instruction_4_bits(instruction_4_bits), 
        .dest_reg_wire(dest_reg_wire), 
        .memwire(memwire), 
        .instrwire(instrwire)
        );

    memory_unit dut(
        .clkwire(clkwire), 
        .checkbool(checkwdata), 
        .instruction(inst), 
        .linenum(linenum), 
        .writedata(wdata), 
        .aluoutput(aluoutput), 
        .regnum(regnum), 
        .registernum(registernum),
        .opcode_out(opcode_out)
    );

    Execution_unit dut2(
        .jump_address(jump_address_exe),
        .jump_selector(jump_selector_exe),
        .clkwire(clkwire), 
        .op1(op1), 
        .op2(op2), 
        .imm(imm),
        .regdesti(regdesti), 
        .ldsti(ldsti), 
        .regdest(regdest), 
        .ldst(ldst), 
        .instructioni(instructioni),
        .instruction(instruction), 
        .ALU_output(ALU_output)
        );

    write_back D(
        .clkwire(clkwire), 
        .writeToReg(checkwdata_wb), 
        .regNos(regNos), 
        .writeData(wdataregw), 
        .reg1_in(regwire1),
        .reg2_in(regwire2), 
        .reg3_in(regwire3), 
        .reg4_in(regwire4), 
        .reg5_in(regwire5), 
        .reg6_in(regwire6), 
        .reg7_in(regwire7), 
        .reg8_in(regwire8),
        .reg1_out(reg1_out),
        .reg2_out(reg2_out),
        .reg3_out(reg3_out),
        .reg4_out(reg4_out),
        .reg5_out(reg5_out),
        .reg6_out(reg6_out),
        .reg7_out(reg7_out),
        .reg8_out(reg8_out) 
        );

    always #1
        begin
            clk = ~clk;
        end

    initial 
        begin
            i = -1;
            done = 1'b0;
            clk = 1'b0;
            pc = 8'b0;
	        reg1 = 0;
            reg2 = 0;
            reg3 = 0;
            reg4 = 0;
            reg5 = 0;
            reg6 = 0;
            reg7 = 0;
            reg8 = 0;
            #2000 $finish;
        end
    always @(negedge clk)
        begin
            i = i - 1;
            inst = instruction; 
            aluoutput = ALU_output; 
            linenum = ldst; 
            registernum = regdest; 
            jump_address_reg = jump_address_exe;
            jump_selector_reg = jump_selector_exe;
            checkwdata_wb = checkwdata;
            AluOutput_reg = wdata;
            Data_from_mem = wdata;
            regNos_reg = regnum;
            wdatareg = wdata;

            reg1 = reg1_out;
            reg2 = reg2_out;
            reg3 = reg3_out;
            reg4 = reg4_out;
            reg5 = reg5_out;
            reg6 = reg6_out;
            reg7 = reg7_out;
            reg8 = reg8_out;
            current_instruction = ciwire;

            if((ciwire == 20'b11100000000000000000) && (done == 1'b0))
                begin
                    i = 5; 
                    done = 1'b1;
                end

            op1 = reg_data_1_wire;
            op2 = reg_data_2_wire;
            ldsti = memwire;
            npci = npc_out;
            regdesti = dest_reg_wire;
            instructioni = instruction_4_bits;
            imm = instrwire;

            $display("Current instruction in IF unit is: %b", current_instruction );

            if(i == 0) 
                $finish;
        end
endmodule
