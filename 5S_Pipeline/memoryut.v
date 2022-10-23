module memory_unit(
    input wire clkwire, 
    input wire [3:0] registernum,
    input wire [3:0] instruction, 
    input wire [15:0] aluoutput, 

    input [3:0] linenum, 

    output wire [15:0] writedata, 
    output wire [3:0] regnum,
    output wire [3:0] opcode_out,
    output wire checkbool 
);

    reg[15:0] Mem[0:15], val;
    reg checkboolreg;
    reg [3:0] regno;
    reg [3:0] inst_pass;
    integer fd, a, i;
    assign regnum = regno;
    assign checkbool = checkboolreg;
    assign writedata = val;
    assign opcode_out = inst_pass;

    initial
        begin
            i = 0;
            fd = $fopen("mem.txt", "r");

            while(!($feof(fd)))
                begin
                    a = $fscanf(fd ,"%b", Mem[i]);
                    i = i+1;   
                end
        end

    always @(posedge clkwire) 
        begin
            regno = registernum;
            inst_pass = instruction;

            if(instruction == 4'b0011) // for load instruction
                begin
                    val = Mem[linenum - 1];
                    checkboolreg = 1'b1;
                end

            else if(instruction == 4'b0100) // for store instruction
                begin   
                    checkboolreg = 1'b0;
                    val = 0;
                    fd = $fopen("mem.txt", "w");

                    for (i = 0; i <= 14; i = i + 1)
                        begin
                            if(i == (linenum - 1)) 
                                $fdisplay(fd, "%b", aluoutput);

                            else 
                                $fdisplay(fd, "%b", Mem[i]); 
                        end

                    if(linenum != (i + 1)) 
                        $fwrite(fd, "%b",Mem[i]);

                    else 
                        $fwrite(fd, "%b", aluoutput);

                    $fclose(fd);
                end 

            else if(instruction == 4'b0000 || instruction == 4'b0001 || instruction == 4'b0010) // for add, sub and mul operations
                begin 
                    val = aluoutput;
                    checkboolreg = 1'b1;
                end

            else 
                checkboolreg = 1'b0;
        end

endmodule
