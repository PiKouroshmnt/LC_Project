`timescale 1ns/1ps
`include "Player 2 FSM.v"
`include "Player 1 FSM.v"

module Game (
    input [5:0] P1,
    input [5:0] P2,
    input CLK,
    input RST,
    output [1:0] HP1,
    output [1:0] HP2,
    output [2:0] P1_POS,
    output [2:0] P2_POS
);

    Player_1_FSM M1(P1,P2,CLK,RST,HP1,P1_POS);
    Player_2_FSM M2(P2,P1,CLK,RST,HP2,P2_POS);

endmodule