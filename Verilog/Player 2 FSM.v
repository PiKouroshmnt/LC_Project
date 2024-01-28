`timescale 1ns/1ps

// input P2 = J,MR,ML,W,P,K         e.g:  010000 means MR (Move Right) , 000010 means P (Punch)
//            5, 4, 3,2,1,0

module Player_2_FSM (
    input [5:0] P2,
    input [5:0] P1,
    input CLK,
    input RST,
    output [1:0] Health,
    output [2:0] position
);

    reg [3:0] state;
    reg wait_counter;
    reg [2:0] distance;
    reg [2:0] self_pos,op_pos;

    parameter S6_3 = 4'b0111, S6_2 = 4'b0110, S6_1 = 4'b0101;
    parameter S5_3 = 4'b1011, S5_2 = 4'b1010, S5_1 = 4'b1001;
    parameter S4_3 = 4'b1111, S4_2 = 4'b1110, S4_1 = 4'b1101;
    parameter Sx_0 = 4'b0000;

    initial begin
        state = S6_3;
        wait_counter = 1'b0;
        distance = 3'b100;
        self_pos = 3'b110;
        op_pos = 3'b001;
    end

    always @(posedge CLK or negedge RST) begin
        if(~RST) begin
            state = S6_3;
            wait_counter = 1'b0;
            distance = 3'b100;
            self_pos = 3'b110;
            op_pos = 3'b001;
        end
        else begin
            if (op_pos != 1)
                op_pos = op_pos - P1[3];
            if (op_pos != 3)
                op_pos = op_pos + P1[4];

            if (self_pos != 4)
                self_pos = self_pos - P2[3];
            if (self_pos != 6)
                self_pos = self_pos + P2[4];

            distance = self_pos - op_pos - 3'b001;

            case (state)
                S6_3: begin
                    if (P2[3] && P1[0] && distance < 2) 
                        state = S5_2;
                    else if (P2[3])
                        state = S5_3;
                    else
                        state = S6_3;        
                end

                S5_3: begin
                    if (P2[2]) begin
                        wait_counter = ~wait_counter;
                    end
                    else
                        wait_counter = 1'b0;

                    if (P2[4]) 
                        state = S6_3;
                    else if (P2[3] && P1[1] && distance == 0)
                        state = S4_1;
                    else if (P2[3] && P1[0] && distance < 2)
                        state = S4_2;
                    else if (P2[3])
                        state = S4_3;

                    else if (P2[0] && P1[0] && distance < 2) begin
                        state = S6_3;
                        self_pos = 3'b110;
                        op_pos = op_pos - 3'b001;
                    end
                    else if (~P2[5] && P1[0] && distance < 2)
                        state = S5_2;
                    else
                        state = S5_3;
                end

                S4_3: begin
                    if (P2[2]) 
                        wait_counter = ~wait_counter;
                    else
                        wait_counter = 1'b0;

                    if (P2[4] && P1[0] && distance < 2)
                        state = S5_2;
                    else if (P2[4])
                        state = S5_3;
                    
                    else if (P2[1] && P1[0] && distance == 0)
                        state = S4_3;
                    else if (P2[1] && P1[1] && distance == 0) begin
                        state = S5_3;
                        self_pos = 3'b101;
                        op_pos = op_pos - 3'b001;
                    end
                    else if (P2[0] && P1[0] && distance < 2) begin
                        state = S5_3;
                        self_pos = 3'b101;
                        op_pos = op_pos - 3'b001;
                    end
                    else if (~P2[5] && P1[1] && distance == 0)
                        state = S4_1;
                    else if (~P2[5] && P1[0] && distance < 2)
                        state = S4_2;
                    else
                        state = S4_3;
                    
                end

                S6_2: begin
                    if (~P2[2])
                        wait_counter = 1'b0;

                    if (P2[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S6_3;
                    end
                    else if (P2[2] && ~wait_counter) begin
                        wait_counter =~wait_counter;
                        state = S6_2;
                    end
                    else if (P2[3] && P1[0] && distance < 2)
                        state = S5_1;
                    else if (P2[3])
                        state = S5_2;
                    else
                        state = S6_2;
                end

                S5_2: begin
                    if (~P2[2])
                        wait_counter = 1'b0;

                    if (P2[2] && wait_counter && P1[0] && distance < 2) begin
                        wait_counter = ~wait_counter;
                        state = S5_2;
                    end
                    else if(P2[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S5_3;
                    end

                    else if(P2[3] && P1[1] && distance == 0)
                        state = Sx_0;
                    else if(P2[3] && P1[0] && distance < 2)
                        state = S4_1;
                    else if(P2[3])
                        state = S4_2;
                    else if(P2[4])
                        state = S6_2;
                    
                    else if(P2[0] && P1[0] && distance < 2) begin
                        state = S6_2;
                        self_pos = 3'b110;
                        op_pos = op_pos - 3'b001;
                    end
                    else if(~P2[5] && P1[0] && distance < 2)
                        state = S5_1;
                    else
                        state = S5_2;

                    if(P2[2] && ~wait_counter)
                        wait_counter = ~wait_counter;     
                end

                S4_2: begin
                    if (~P2[2])
                        wait_counter = 1'b0;

                    if(P2[2] && wait_counter && P1[1] && distance == 0) begin
                        wait_counter = ~wait_counter;
                        state = S4_1;
                    end
                    else if(P2[2] && wait_counter && P1[0] && distance < 2) begin
                        wait_counter = ~wait_counter;
                        state = S4_2;
                    end
                    else if(P2[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S4_3;
                    end

                    else if(P2[4] && P1[0] && distance < 2)
                        state = S5_1;
                    else if(P2[4])
                        state = S5_2;
                    
                    else if(P2[1] && P1[0] && distance == 0)
                        state = S4_2;
                    else if(P2[1] && P1[1] && distance == 0) begin
                        state = S5_2;
                        self_pos = 3'b101;
                        op_pos = op_pos - 3'b001;
                    end
                    else if(P2[0] && P1[0] && distance < 2) begin
                        state = S5_2;
                        self_pos = 3'b101;
                        op_pos = op_pos - 3'b001;
                    end
                    else if(~P2[5] && P1[1] && distance == 0)
                        state = Sx_0;
                    else if(~P2[5] && P1[0] && distance < 2)
                        state = S4_1;
                    else
                        state = S4_2;

                    if(P2[2] && ~wait_counter)
                        wait_counter = ~wait_counter;
                end

                S6_1: begin
                    if (~P2[2])
                        wait_counter = 1'b0;

                    if(P2[2] && ~wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S6_1;
                    end
                    else if(P2[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S6_2;
                    end
                    
                    else if(P2[3] && P1[0] && distance < 2)
                        state = Sx_0;
                    else if(P2[3])
                        state = S5_1;
                    else
                        state = S6_1;
                end

                S5_1: begin
                    if (~P2[2])
                        wait_counter = 1'b0;
                    
                    if (P2[2] && wait_counter && P1[0] && distance < 2) begin
                        wait_counter = ~wait_counter;
                        state = S5_1;
                    end
                    else if(P2[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S5_2;
                    end

                    else if(P2[4])
                        state = S6_1;
                    else if(P2[3] && P1[1] && distance == 0)
                        state = Sx_0;
                    else if(P2[3] && P1[0] && distance < 2)
                        state = Sx_0;
                    else if(P2[3])
                        state = S4_1;
                    
                    else if(P2[0] && P1[0] && distance < 2) begin
                        state = S6_1;
                        self_pos = 3'b110;
                        op_pos = op_pos - 3'b001;
                    end
                    else if(~P2[5] && P1[0] && distance < 2)
                        state = Sx_0;
                    else
                        state = S5_1;

                    if(P2[2] && ~wait_counter)
                        wait_counter = ~wait_counter;
                end

                S4_1: begin
                    if (~P2[2])
                        wait_counter = 1'b0;

                    if (P2[2] && wait_counter && P1[1] && distance == 0) begin
                        wait_counter = ~wait_counter;
                        state = Sx_0;
                    end
                    else if(P2[2] && wait_counter && P1[0] && distance < 2) begin
                        wait_counter = ~wait_counter;
                        state = S4_1;
                    end
                    else if(P2[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S4_2;
                    end

                    else if(P2[4] && P1[0] && distance < 2)
                        state = Sx_0;
                    else if(P2[4])
                        state = S5_1;
                    
                    else if(P2[1] && P1[0] && distance == 0)
                        state = S4_1;
                    else if(P2[1] && P1[1] && distance == 0) begin
                        state = S5_1;
                        self_pos = 3'b101;
                        op_pos = op_pos - 3'b001;
                    end
                    else if(P2[0] && P1[0] && distance < 2) begin
                        state = S5_1;
                        self_pos = 3'b101;
                        op_pos = op_pos - 3'b001;
                    end
                    else if(~P2[5] && P1[1] && distance == 0)
                        state = Sx_0;
                    else if(~P2[5] && P1[0] && distance < 2)
                        state = Sx_0;
                    else
                        state = S4_1;

                    if(P2[2] && ~wait_counter)
                        wait_counter = ~wait_counter;
                end
            endcase
        end
    end

    assign Health = state[1:0];
    assign position = {1'b1,~state[3:2]};
    
endmodule