`include "Game.v"

module tb_game;
    reg clk,rst;
    reg [5:0] P1,P2;

    wire [1:0] HP1,HP2;
    wire [2:0] P1_POS,P2_POS;

 
    Game gg(
        .P1 (P1),
        .P2 (P2),
        .CLK (clk),
        .RST (rst),
        .HP1 (HP1),
        .HP2 (HP2),
        .P1_POS (P1_POS),
        .P2_POS (P2_POS)
    );

    initial begin
        $dumpfile("tb_game.vcd");
        $dumpvars(0, tb_game);
    end

    initial begin
        rst = 1'b1;
        clk = 1'b0;
        repeat (18)
        #10 clk =~clk;
    end

    initial begin
        P1 = 6'b010000;
        P2 = 6'b001000;
        #35;
        P1 = 6'b000010;
        P2 = 6'b000010;
        #20;
        P1 = 6'b000001;
        P2 = 6'b001000;
        #20;
        P1 = 6'b010000;
        P2 = 6'b000010;
        #20;
        P1 = 6'b000100;
        P2 = 6'b000100;
        #40;
        P1 = 6'b000010;
        P2 = 6'b000001;
        #20;
        P1 = 6'b100000;
        P2 = 6'b000010;
        #20;
        $finish;

    end

endmodule
