module vending_machine(
input clk,rst,start,
input [1:0]coin,
input select_line,  //drink/chocolate
output reg product,
output reg [3:0]change,
output reg done
);
reg [3:0]sum;
reg [2:0] pr_state, next_state;

parameter S0= 3'b000,S1=3'b001,  
          S2=3'b010,S3=3'b011,
          S4 =3'b100,S5=3'b101,
          S6=3'b110 ;
parameter C0=2'b00, C1=2'b01,
          C2=2'b10 ,C5=2'b11;
          
// 3 block 1for reset 1for state operation and 1for sum operation
// product=0 chocolate$3
// product=1 drink$5
parameter DRINK_PRICE = 5;
parameter CHOC_PRICE  = 3;


// for reset---------------------------------------------
always @(posedge clk or posedge rst) begin
    if (rst)
        pr_state <= S0;
    else
        pr_state <= next_state;
end

// for state operation not sum-------------------------
//// NEXT STATE LOGIC
always @(*) begin
    next_state = pr_state;
    case(pr_state)
        S0: if(start) next_state = S1;

        S1: if(select_line) next_state = S2;
            else            next_state = S3;

        S2: if(sum >= DRINK_PRICE) next_state = S4;

        S3: if(sum >= CHOC_PRICE)  next_state = S5;

        S4, S5: next_state = S0;

        default: next_state = S0;
    endcase
end

// for summing the coin amount----------------------
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sum     <= 0;
        product <= 0;
        done    <= 0;
        change  <= 0;
    end
    else begin
        done   <= 0;
        change <= 0;
        case (pr_state)

        S0: sum <= 0;

        S2: begin
            if (coin == C1) sum <= sum + 1;
            else if (coin == C2) sum <= sum + 2;
            else if (coin == C5) sum <= sum + 5;
        end

        S3: begin
            if (coin == C5) sum <= sum + 5;
        end

        S4: begin
            product <= 1; // drink
            done <= 1;
            if(sum>DRINK_PRICE)
              change<=sum-DRINK_PRICE;
        end

        S5: begin
            product <= 0; // chocolate
            done <= 1;
            if(sum>CHOC_PRICE)
              change<=sum-CHOC_PRICE;
        end

        endcase
    end
end

endmodule
