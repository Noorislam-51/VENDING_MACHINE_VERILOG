`timescale 1ns/1ns

module vending_machine_tb;
reg clk,rst,start;
reg [1:0]coin;
reg select_line;  //drink/chocolate
wire product;
wire [3:0]change;
wire done;
parameter C0=2'b00, C1=2'b01,
          C2=2'b10 ,C5=2'b11;

vending_machine uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .coin(coin),
    .select_line(select_line),
    .product(product),
    .change(change),
    .done(done)
);
  
  initial clk=0;
  always #5 clk=~clk;
  initial begin 
  $dumpfile("vending_machine.vcd");
  $dumpvars(0,vending_machine_tb);

  $monitor("time=%d \t rst=%b \t clk=%b \t start=%b \t coin=%b \t select_line=%b \t product=%b \t change=%b \t ", $time,rst,clk,start,coin,select_line,product,change);

  // iniiallize
  clk=0;
  start=0;
  rst=1;
  #10 rst = 0;
  #10 start=1;
  #10 coin=C5;
  #10 select_line=1;
  #10 coin = C0;   // remove coin
  #10 start=1;
  #10 coin=C5;
  #10 select_line=0;
#20;
$finish;
end 
endmodule


