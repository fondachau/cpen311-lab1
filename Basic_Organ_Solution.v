module Basic_Organ_Solution (input CLK_50M, input [2:0] SW,output newclock);


logic reset;
logic [31:0]d;
logic [10:0]desiredfreq;
	
getdesiredfreq getfreq (.clk(CLK_50M), .SW(SW[2:0]),.desiredfreq(desiredfreq));
counter counter1(.clk(CLK_50M), .reset(reset), .Q(d));
clockdiv clockdiv1(.d(d),.desiredfreq(desiredfreq),.clk(CLK_50M),.reset(reset),.newclock(newclock));

endmodule 
module counter(input clk, input reset, output [31:0] Q);
always_ff @ (posedge (clk), posedge reset)
begin 
	if (reset)
		begin
		Q<=32'b0;
		end
	else
		Q<=Q+32'b1;
end
endmodule

module clockdiv (input [31:0] d,input [10:0] desiredfreq,input clk, output reset, output newclock);
//#parameter (desiredfreq=587)
always_ff @ (posedge (clk))
begin
	if (d==(1/desiredfreq)*50000000/2)
		begin
		newclock<=1'b1;
		end
	else if (d==(1/desiredfreq)*50000000)
		begin
		newclock<=1'b0;
		reset<=1'b1;
		end
	else
		begin
		newclock<= newclock;
		reset<=1'b0;
		end
end
endmodule

module getdesiredfreq (input clk, input [2:0] SW,output [10:0] desiredfreq);
always_comb
	case(SW[2:0])
	3'b000: desiredfreq<=523;
	3'b001: desiredfreq<=587;
	3'b010: desiredfreq<=659;
	3'b011: desiredfreq<=598;
	3'b100: desiredfreq<=783;
	3'b101: desiredfreq<=987;
	3'b110: desiredfreq<=880;
	3'b111: desiredfreq<=1046;
	default: desiredfreq<=1000;
	endcase
endmodule 
