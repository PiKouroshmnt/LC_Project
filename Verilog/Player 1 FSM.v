`timescale 1ns/1ps

// input P1 = J,MR,ML,W,P,K         e.g:  010000 means MR (Move Right) , 000010 means P (Punch)
//            5, 4, 3,2,1,0

module Player_1_FSM (
    input [5:0] P1,
    input [5:0] P2,
    input CLK,
    input RST,
    output [1:0] Health,
    output [2:0] position
);

    reg [3:0] state;
    reg wait_counter;
    reg [2:0] distance;
    reg [2:0] op_pos,self_pos;

    parameter S1_3 = 4'b0111, S1_2 = 4'b0110, S1_1 = 4'b0101;
    parameter S2_3 = 4'b1011, S2_2 = 4'b1010, S2_1 = 4'b1001;
    parameter S3_3 = 4'b1111, S3_2 = 4'b1110, S3_1 = 4'b1101;
    parameter Sx_0 = 4'b0000;

    initial begin
        state = S1_3;
        wait_counter = 1'b0;
        distance = 3'b100;
        op_pos = 3'b110;
        self_pos = 3'b001;
    end

    always @(posedge CLK or negedge RST) begin
        if(~RST) begin
            state = S1_3;
            wait_counter = 1'b0;
            distance = 3'b100;
            op_pos = 3'b110;
            self_pos = 3'b001;
        end
        else begin
            if (self_pos != 1)
                self_pos = self_pos - P1[3];
            if (self_pos != 3)
                self_pos = self_pos + P1[4];

            if (op_pos != 4)
                op_pos = op_pos - P2[3];
            if (op_pos != 6)
                op_pos = op_pos + P2[4];

            distance = op_pos - self_pos - 3'b001;

            case (state)
                S1_3: begin
                    if (P1[4] && P2[0] && distance < 2) 
                        state = S2_2;
                    else if (P1[4])
                        state = S2_3;
                    else
                        state = S1_3;        
                end

                S2_3: begin
                    if (P1[2]) begin
                        wait_counter = ~wait_counter;
                    end
                    else
                        wait_counter = 1'b0;

                    if (P1[3]) 
                        state = S1_3;
                    else if (P1[4] && P2[1] && distance == 0)
                        state = S3_1;
                    else if (P1[4] && P2[0] && distance < 2)
                        state = S3_2;
                    else if (P1[4])
                        state = S3_3;

                    else if (P1[0] && P2[0] && distance < 2) begin
                        state = S1_3;
                        self_pos = 3'b001;
                        op_pos = op_pos + 3'b001;
                    end
                    else if (~P1[5] && P2[0] && distance < 2)
                        state = S2_2;
                    else
                        state = S2_3;
                end

                S3_3: begin
                    if (P1[2]) 
                        wait_counter = ~wait_counter;
                    else
                        wait_counter = 1'b0;

                    if (P1[3] && P2[0] && distance < 2)
                        state = S2_2;
                    else if (P1[3])
                        state = S2_3;
                    
                    else if (P1[1] && P2[0] && distance == 0)
                        state = S3_3;
                    else if (P1[1] && P2[1] && distance == 0) begin
                        state = S2_3;
                        self_pos = 3'b010;
                        op_pos = op_pos + 3'b001;
                    end
                    else if (P1[0] && P2[0] && distance < 2) begin
                        state = S2_3;
                        self_pos = 3'b010;
                        op_pos = op_pos + 3'b001;
                    end
                    else if (~P1[5] && P2[1] && distance == 0)
                        state = S3_1;
                    else if (~P1[5] && P2[0] && distance < 2)
                        state = S3_2;
                    else
                        state = S3_3;
                    
                end

                S1_2: begin
                    if (~P1[2])
                        wait_counter = 1'b0;

                    if (P1[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S1_3;
                    end
                    else if (P1[2] && ~wait_counter) begin
                        wait_counter =~wait_counter;
                        state = S1_2;
                    end
                    else if (P1[4] && P2[0] && distance < 2)
                        state = S2_1;
                    else if (P1[4])
                        state = S2_2;
                    else
                        state = S1_2;
                end

                S2_2: begin
                    if (~P1[2])
                        wait_counter = 1'b0;

                    if (P1[2] && wait_counter && P2[0] && distance < 2) begin
                        wait_counter = ~wait_counter;
                        state = S2_2;
                    end
                    else if(P1[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S2_3;
                    end

                    else if(P1[4] && P2[1] && distance == 0)
                        state = Sx_0;
                    else if(P1[4] && P2[0] && distance < 2)
                        state = S3_1;
                    else if(P1[4])
                        state = S3_2;
                    else if(P1[3])
                        state = S1_2;
                    
                    else if(P1[0] && P2[0] && distance < 2) begin
                        state = S1_2;
                        self_pos = 3'b001;
                        op_pos = op_pos + 3'b001;
                    end
                    else if(~P1[5] && P2[0] && distance < 2)
                        state = S2_1;
                    else
                        state = S2_2;

                    if(P1[2] && ~wait_counter)
                        wait_counter = ~wait_counter;     
                end

                S3_2: begin
                    if (~P1[2])
                        wait_counter = 1'b0;

                    if(P1[2] && wait_counter && P2[1] && distance == 0) begin
                        wait_counter = ~wait_counter;
                        state = S3_1;
                    end
                    else if(P1[2] && wait_counter && P2[0] && distance < 2) begin
                        wait_counter = ~wait_counter;
                        state = S3_2;
                    end
                    else if(P1[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S3_3;
                    end

                    else if(P1[3] && P2[0] && distance < 2)
                        state = S2_1;
                    else if(P1[3])
                        state = S2_2;
                    
                    else if(P1[1] && P2[0] && distance == 0)
                        state = S3_2;
                    else if(P1[1] && P2[1] && distance == 0) begin
                        state = S2_2;
                        self_pos = 3'b010;
                        op_pos = op_pos + 3'b001;
                    end
                    else if(P1[0] && P2[0] && distance < 2) begin
                        state = S2_2;
                        self_pos = 3'b010;
                        op_pos = op_pos + 3'b001;
                    end
                    else if(~P1[5] && P2[1] && distance == 0)
                        state = Sx_0;
                    else if(~P1[5] && P2[0] && distance < 2)
                        state = S3_1;
                    else
                        state = S3_2;

                    if(P1[2] && ~wait_counter)
                        wait_counter = ~wait_counter;    
                end

                S1_1: begin
                    if (~P1[2])
                        wait_counter = 1'b0;

                    if(P1[2] && ~wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S1_1;
                    end
                    else if(P1[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S1_2;
                    end
                    
                    else if(P1[4] && P2[0] && distance < 2)
                        state = Sx_0;
                    else if(P1[4])
                        state = S2_1;
                    else
                        state = S1_1;
                end

                S2_1: begin
                    if (~P1[2])
                        wait_counter = 1'b0;
                    
                    if (P1[2] && wait_counter && P2[0] && distance < 2) begin
                        wait_counter = ~wait_counter;
                        state = S2_1;
                    end
                    else if(P1[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S2_2;
                    end

                    else if(P1[3])
                        state = S1_1;
                    else if(P1[4] && P2[1] && distance == 0)
                        state = Sx_0;
                    else if(P1[4] && P2[0] && distance < 2)
                        state = Sx_0;
                    else if(P1[4])
                        state = S3_1;
                    
                    else if(P1[0] && P2[0] && distance < 2) begin
                        state = S1_1;
                        self_pos = 3'b001;
                        op_pos = op_pos + 3'b001;
                    end
                    else if(~P1[5] && P2[0] && distance < 2)
                        state = Sx_0;
                    else
                        state = S2_1;

                    if(P1[2] && ~wait_counter)
                        wait_counter = ~wait_counter;    
                end

                S3_1: begin
                    if (~P1[2])
                        wait_counter = 1'b0;

                    if (P1[2] && wait_counter && P2[1] && distance == 0) begin
                        wait_counter = ~wait_counter;
                        state = Sx_0;
                    end
                    else if(P1[2] && wait_counter && P2[0] && distance < 2) begin
                        wait_counter = ~wait_counter;
                        state = S3_1;
                    end
                    else if(P1[2] && wait_counter) begin
                        wait_counter = ~wait_counter;
                        state = S3_2;
                    end

                    else if(P1[3] && P2[0] && distance < 2)
                        state = Sx_0;
                    else if(P1[3])
                        state = S2_1;
                    
                    else if(P1[1] && P2[0] && distance == 0)
                        state = S3_1;
                    else if(P1[1] && P2[1] && distance == 0) begin
                        state = S2_1;
                        self_pos = 3'b010;
                        op_pos = op_pos + 3'b001;
                    end
                    else if(P1[0] && P2[0] && distance < 2) begin
                        state = S2_1;
                        self_pos = 3'b010;
                        op_pos = op_pos + 3'b001;
                    end
                    else if(~P1[5] && P2[1] && distance == 0)
                        state = Sx_0;
                    else if(~P1[5] && P2[0] && distance < 2)
                        state = Sx_0;
                    else
                        state = S3_1;

                    if(P1[2] && ~wait_counter)
                        wait_counter = ~wait_counter;    
                end
            endcase
        end
    end

    assign Health = state[1:0];
    assign position = {1'b0,state[3:2]};

endmodule