
`timescale 1 ns / 100 ps

module axi4l_design_TB();
//variable declarations
	reg [4:0] AWADDR, ARADDR;
	reg [31:0] WDATA;
	reg [3:0] WSTRB;

	reg AWVALID, WVALID, BREADY, ARVALID, RREADY, RESETN, clk;

	wire AWREADY, WREADY, BVALID, ARREADY, RVALID;
	wire [1:0] BRESP, RRESP;
	wire [31:0] RDATA;
	//DUT instance
	axi4l_design DUT (	.AWADDR(AWADDR),
						.AWVALID	(AWVALID),
						.AWREADY	(AWREADY),
						.WDATA	(WDATA),
						.WSTRB	(WSTRB),
						.WVALID	(WVALID),
						.WREADY	(WREADY),
						.BRESP	(BRESP),
						.BVALID	(BVALID),
						.BREADY	(BREADY),
						.ARADDR	(ARADDR),
						.ARVALID	(ARVALID),
						.ARREADY	(ARREADY),
						.RDATA	(RDATA),
						.RVALID	(RVALID),
						.RRESP	(RRESP),
						.RREADY	(RREADY),
						.RESETN	(RESETN),
						.clk	(clk) 		);
	
	initial begin
		clk = 1'b0;
		AWADDR = 0;
		ARADDR = 0;
		WDATA = 0;
		WDATA = 0;
		AWVALID = 0;
		WVALID = 0;
		BREADY = 0;
		ARVALID = 0;
		RREADY = 0;
		WSTRB = 0;

		forever begin
			#2.5 clk = ~clk; //clock of frequence 200 MHz
		end
	end

	initial begin
		//all valid signals has to be deasserted while reset
		RESETN = 1'b1;
		#1 RESETN = 1'b0;
		AWADDR = 0;
		ARADDR = 0;
		WDATA = 0;
		WDATA = 0;
		AWVALID = 0;
		WVALID = 0;
		BREADY = 0;
		ARVALID = 0;
		RREADY = 0;

		#10 RESETN = 1'b1;
	end

	integer i;
	initial begin
		#11;
		for (i=0; i <32; i++)
		begin
			write_transaction(i, ($urandom & 32'hFFFFFFFF), ($urandom & 4'hF)); //write to all the addres with random strobe and random data
		end
		#20;
		//$finish;
	end
	integer j;
	initial begin
		#35;
		for (j=0; j <32; j++)
		begin
			read_transaction(j); //read all addresses
		end
		#20;
		$finish;
	end

	//initial begin
	//	#9 
	//	write_transaction(1);
	//	read_transaction(1);
	//	#20;
	//	$finish;
	//end
	

	initial
	begin
		//Generates and dumps all the signals in vcd file
		$dumpfile("waveforms.vcd");		
		$dumpvars(0,DUT);
	end


	task write_transaction(input integer i, j, k);
	//This task starts 3 separate process in fork join, each representing sepatrate channel for write 
		fork
			begin	//Write address channel
				AWADDR <= i;
				AWVALID <= 1;
				@(posedge clk);
				wait(AWVALID && AWREADY);	//wait for handshake on write address channel
				@(posedge clk);
				AWVALID <= 1'b0;
			end

			begin		//write data channel
				WDATA <= j;
				WVALID <= 1;
				WSTRB <= k;
				@(posedge clk);
				wait(WVALID && WREADY); //wait for handshake on write data channel
				@(posedge clk);
				WVALID <= 1'b0;
			end

			begin 	//write response channel
				BREADY <= 1'b1;
				@(posedge clk);
				wait(BVALID && BREADY);	//wait for handshake on write response channel
				@(posedge clk);
				BREADY <= 1'b0;
			end
		join
	endtask

	task write_transaction_with_delay(input integer i, j, k);
	//This task starts 3 separate process in fork join, each representing sepatrate channel for write  but with timing violation in write data channel
		fork
			begin							//Write address channel
				AWADDR <= i;
				AWVALID <= 1;
				@(posedge clk);
				wait(AWVALID && AWREADY);		//wait for handshake on write address channel
				@(posedge clk);
				AWVALID <= 1'b0;
			end

			begin		//write data channel
				WDATA <= j;
				#20 WVALID <= 1;		//added delay of 2 clock cycle
				WSTRB <= k;
				@(posedge clk);
				wait(WVALID && WREADY); ////wait for handshake on write data channel
				@(posedge clk);
				WVALID <= 1'b0;
			end

			begin		//write response channel
				BREADY <= 1'b1;
				@(posedge clk);
				wait(BVALID && BREADY);	////wait for handshake on write response channel
				@(posedge clk);
				BREADY <= 1'b0;
			end
		join
	endtask

	task read_transaction(input integer i);
		//This task starts two separate process each represnting separate channel for read transaction.
		fork
			begin					//Read Address
				ARADDR <= i;
				ARVALID <= 1;
				@(posedge clk);
				wait(ARVALID && ARREADY);		//wait for handshake on read address channel
				@(posedge clk);
				ARVALID <= 1'b0;
			end

			begin					//Read data and response
				RREADY <= 1'b1;
				@(posedge clk);
				wait(RVALID && RREADY);		//wait for handshake on read data channel
				@(posedge clk);
				RREADY <= 1'b0;
			end
		join
	endtask
endmodule
