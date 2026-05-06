module axi4l_design (
	//Write address channel - total address 32
	input [4:0] AWADDR,
	input AWVALID,
	output reg AWREADY,

	//Write data channel
	input [31:0] WDATA,
	input [3:0] WSTRB,
	input WVALID,
	output reg WREADY,

	//write response channel
	output reg [1:0] BRESP,
	output reg BVALID,
	input BREADY,

	//Read Address Channel
	input [4:0] ARADDR,
	input ARVALID,
	output reg ARREADY,

	//Read Data Channel
	output reg [31:0] RDATA,
	output reg RVALID,
	output reg [1:0] RRESP,
	input RREADY,

	//reset and clk
	input RESETN,
	input clk
);
	
	reg [31:0] stored_data[0:31]; //This is an array of 32 bit registers
	reg write_data_flag, write_resp_flag, read_data_flag; //used for synchronization between respected channels
	reg [4:0] write_addr, read_addr; //used for synchronization between respected channels
	
	reg [5:0] i;
	reg [31:0] count; 	//used to handle timing violations
	reg error_flag; 	////used to handle timing violations
	reg count_enable;	//used to handle timing violations
	always @(posedge clk or negedge RESETN) //Active low reset
	begin
		if(!RESETN)
		begin
			AWREADY <= 1'b0;
			WREADY <= 1'b0;
			BRESP <= 2'b0;
			BVALID <= 1'b0; 	////all valid signals has to be deasserted while reset
			ARREADY <= 1'b0;
			RDATA <= 32'b0;
			RVALID <= 1'b0; 	//all valid signals has to be deasserted while reset
			RRESP <= 2'b0;
			count <= 0;
			count_enable <= 0;
			error_flag <= 0;
			write_data_flag <= 0;
			write_resp_flag <= 0;
			read_data_flag<= 0;
			write_addr <= 0;
			read_addr <= 0;

			for (i=0; i<32; i++)
			begin
				stored_data[i] <= 0;
			end
			
		end

		else 
		begin
			//Write Address channel handshake
			if(AWVALID && ~AWREADY)	//slave can wait for AWVALID signal before asserting AWREADY
			begin
				AWREADY <= 1'b1;
				write_addr <= AWADDR;
				write_data_flag <= 1'b1;
			end
			else
			begin
				AWREADY <= 1'b0;
				write_data_flag <= 1'b0;
			end
			//enable counting for timing violation
			if(AWVALID & ~WVALID) 
			begin
				count_enable <= 1'b1;
			end

			//Write Data channel 
			if(WVALID && ~WREADY && AWVALID && ~write_data_flag) //when WVALID and AWVALID arrives at same time
			begin
				WREADY <= 1'b1;	////slave can wait for WVALID signal before asserting WREADY
				count_enable <= 1'b0;
				if (~error_flag) begin
					
					case (AWADDR) //stores data according to WSTRB values
						5'h0: 	begin
									if (WSTRB[0]) stored_data[5'h0][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h0][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h0][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h0][31:24] <= WDATA[31:24];
								end

						5'h1: 	begin
									if (WSTRB[0]) stored_data[5'h1][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1][31:24] <= WDATA[31:24];
								end

						5'h2: 	begin
									if (WSTRB[0]) stored_data[5'h2][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h2][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h2][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h2][31:24] <= WDATA[31:24];
								end

						5'h3: 	begin
									if (WSTRB[0]) stored_data[5'h3][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h3][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h3][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h3][31:24] <= WDATA[31:24];
								end

						5'h4: 	begin
									if (WSTRB[0]) stored_data[5'h4][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h4][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h4][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h4][31:24] <= WDATA[31:24];
								end

						5'h5: 	begin
									if (WSTRB[0]) stored_data[5'h5][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h5][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h5][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h5][31:24] <= WDATA[31:24];
								end

						5'h6: 	begin
									if (WSTRB[0]) stored_data[5'h6][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h6][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h6][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h6][31:24] <= WDATA[31:24];
								end

						5'h7: 	begin
									if (WSTRB[0]) stored_data[5'h7][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h7][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h7][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h7][31:24] <= WDATA[31:24];
								end

						5'h8: 	begin
									if (WSTRB[0]) stored_data[5'h8][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h8][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h8][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h8][31:24] <= WDATA[31:24];
								end

						5'h9: 	begin
									if (WSTRB[0]) stored_data[5'h9][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h9][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h9][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h9][31:24] <= WDATA[31:24];
								end

						5'hA: 	begin
									if (WSTRB[0]) stored_data[5'hA][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hA][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hA][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hA][31:24] <= WDATA[31:24];
								end

						5'hB: 	begin
									if (WSTRB[0]) stored_data[5'hB][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hB][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hB][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hB][31:24] <= WDATA[31:24];
								end

						5'hC: 	begin
									if (WSTRB[0]) stored_data[5'hC][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hC][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hC][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hC][31:24] <= WDATA[31:24];
								end

						5'hD: 	begin
									if (WSTRB[0]) stored_data[5'hD][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hD][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hD][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hD][31:24] <= WDATA[31:24];
								end

						5'hE: 	begin
									if (WSTRB[0]) stored_data[5'hE][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hE][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hE][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hE][31:24] <= WDATA[31:24];
								end

						5'hF: 	begin
									if (WSTRB[0]) stored_data[5'hF][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hF][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hF][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hF][31:24] <= WDATA[31:24];
								end

						5'h10: 	begin
									if (WSTRB[0]) stored_data[5'h10][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h10][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h10][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h10][31:24] <= WDATA[31:24];
								end

						5'h11: 	begin
									if (WSTRB[0]) stored_data[5'h11][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h11][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h11][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h11][31:24] <= WDATA[31:24];
								end

						5'h12: 	begin
									if (WSTRB[0]) stored_data[5'h12][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h12][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h12][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h12][31:24] <= WDATA[31:24];
								end

						5'h13: 	begin
									if (WSTRB[0]) stored_data[5'h13][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h13][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h13][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h13][31:24] <= WDATA[31:24];
								end

						5'h14: 	begin
									if (WSTRB[0]) stored_data[5'h14][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h14][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h14][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h14][31:24] <= WDATA[31:24];
								end

						5'h15: 	begin
									if (WSTRB[0]) stored_data[5'h15][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h15][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h15][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h15][31:24] <= WDATA[31:24];
								end

						5'h16: 	begin
									if (WSTRB[0]) stored_data[5'h16][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h16][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h16][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h16][31:24] <= WDATA[31:24];
								end

						5'h17: 	begin
									if (WSTRB[0]) stored_data[5'h17][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h17][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h17][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h17][31:24] <= WDATA[31:24];
								end

						5'h18: 	begin
									if (WSTRB[0]) stored_data[5'h18][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h18][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h18][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h18][31:24] <= WDATA[31:24];
								end

						5'h19: 	begin
									if (WSTRB[0]) stored_data[5'h19][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h19][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h19][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h19][31:24] <= WDATA[31:24];
								end

						5'h1A: 	begin
									if (WSTRB[0]) stored_data[5'h1A][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1A][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1A][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1A][31:24] <= WDATA[31:24];
								end

						5'h1B: 	begin
									if (WSTRB[0]) stored_data[5'h1B][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1B][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1B][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1B][31:24] <= WDATA[31:24];
								end

						5'h1C: 	begin
									if (WSTRB[0]) stored_data[5'h1C][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1C][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1C][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1C][31:24] <= WDATA[31:24];
								end

						5'h1D: 	begin
									if (WSTRB[0]) stored_data[5'h1D][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1D][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1D][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1D][31:24] <= WDATA[31:24];
								end

						5'h1E: 	begin
									if (WSTRB[0]) stored_data[5'h1E][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1E][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1E][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1E][31:24] <= WDATA[31:24];
								end

						5'h1F: 	begin
									if (WSTRB[0]) stored_data[5'h1F][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1F][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1F][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1F][31:24] <= WDATA[31:24];
								end
					endcase
				
				end
				
				write_resp_flag <= 1'b1;	//enable write response

			end
			else if(WVALID && ~WREADY && write_data_flag && ~error_flag) //when WVALID is delayed by 1 clock cycle
			begin
				WREADY <= 1'b1;		////slave can wait for WVALID signal before asserting WREADY
				count_enable <= 1'b0;
				if (~error_flag) begin
					
					case (write_addr)
						5'h0: 	begin
									if (WSTRB[0]) stored_data[5'h0][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h0][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h0][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h0][31:24] <= WDATA[31:24];
								end

						5'h1: 	begin
									if (WSTRB[0]) stored_data[5'h1][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1][31:24] <= WDATA[31:24];
								end

						5'h2: 	begin
									if (WSTRB[0]) stored_data[5'h2][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h2][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h2][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h2][31:24] <= WDATA[31:24];
								end

						5'h3: 	begin
									if (WSTRB[0]) stored_data[5'h3][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h3][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h3][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h3][31:24] <= WDATA[31:24];
								end

						5'h4: 	begin
									if (WSTRB[0]) stored_data[5'h4][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h4][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h4][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h4][31:24] <= WDATA[31:24];
								end

						5'h5: 	begin
									if (WSTRB[0]) stored_data[5'h5][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h5][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h5][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h5][31:24] <= WDATA[31:24];
								end

						5'h6: 	begin
									if (WSTRB[0]) stored_data[5'h6][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h6][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h6][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h6][31:24] <= WDATA[31:24];
								end

						5'h7: 	begin
									if (WSTRB[0]) stored_data[5'h7][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h7][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h7][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h7][31:24] <= WDATA[31:24];
								end

						5'h8: 	begin
									if (WSTRB[0]) stored_data[5'h8][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h8][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h8][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h8][31:24] <= WDATA[31:24];
								end

						5'h9: 	begin
									if (WSTRB[0]) stored_data[5'h9][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h9][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h9][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h9][31:24] <= WDATA[31:24];
								end

						5'hA: 	begin
									if (WSTRB[0]) stored_data[5'hA][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hA][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hA][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hA][31:24] <= WDATA[31:24];
								end

						5'hB: 	begin
									if (WSTRB[0]) stored_data[5'hB][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hB][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hB][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hB][31:24] <= WDATA[31:24];
								end

						5'hC: 	begin
									if (WSTRB[0]) stored_data[5'hC][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hC][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hC][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hC][31:24] <= WDATA[31:24];
								end

						5'hD: 	begin
									if (WSTRB[0]) stored_data[5'hD][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hD][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hD][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hD][31:24] <= WDATA[31:24];
								end

						5'hE: 	begin
									if (WSTRB[0]) stored_data[5'hE][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hE][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hE][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hE][31:24] <= WDATA[31:24];
								end

						5'hF: 	begin
									if (WSTRB[0]) stored_data[5'hF][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'hF][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'hF][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'hF][31:24] <= WDATA[31:24];
								end

						5'h10: 	begin
									if (WSTRB[0]) stored_data[5'h10][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h10][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h10][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h10][31:24] <= WDATA[31:24];
								end

						5'h11: 	begin
									if (WSTRB[0]) stored_data[5'h11][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h11][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h11][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h11][31:24] <= WDATA[31:24];
								end

						5'h12: 	begin
									if (WSTRB[0]) stored_data[5'h12][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h12][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h12][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h12][31:24] <= WDATA[31:24];
								end

						5'h13: 	begin
									if (WSTRB[0]) stored_data[5'h13][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h13][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h13][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h13][31:24] <= WDATA[31:24];
								end

						5'h14: 	begin
									if (WSTRB[0]) stored_data[5'h14][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h14][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h14][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h14][31:24] <= WDATA[31:24];
								end

						5'h15: 	begin
									if (WSTRB[0]) stored_data[5'h15][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h15][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h15][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h15][31:24] <= WDATA[31:24];
								end

						5'h16: 	begin
									if (WSTRB[0]) stored_data[5'h16][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h16][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h16][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h16][31:24] <= WDATA[31:24];
								end

						5'h17: 	begin
									if (WSTRB[0]) stored_data[5'h17][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h17][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h17][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h17][31:24] <= WDATA[31:24];
								end

						5'h18: 	begin
									if (WSTRB[0]) stored_data[5'h18][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h18][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h18][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h18][31:24] <= WDATA[31:24];
								end

						5'h19: 	begin
									if (WSTRB[0]) stored_data[5'h19][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h19][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h19][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h19][31:24] <= WDATA[31:24];
								end

						5'h1A: 	begin
									if (WSTRB[0]) stored_data[5'h1A][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1A][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1A][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1A][31:24] <= WDATA[31:24];
								end

						5'h1B: 	begin
									if (WSTRB[0]) stored_data[5'h1B][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1B][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1B][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1B][31:24] <= WDATA[31:24];
								end

						5'h1C: 	begin
									if (WSTRB[0]) stored_data[5'h1C][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1C][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1C][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1C][31:24] <= WDATA[31:24];
								end

						5'h1D: 	begin
									if (WSTRB[0]) stored_data[5'h1D][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1D][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1D][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1D][31:24] <= WDATA[31:24];
								end

						5'h1E: 	begin
									if (WSTRB[0]) stored_data[5'h1E][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1E][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1E][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1E][31:24] <= WDATA[31:24];
								end

						5'h1F: 	begin
									if (WSTRB[0]) stored_data[5'h1F][7:0]   <= WDATA[7:0];
                					if (WSTRB[1]) stored_data[5'h1F][15:8]  <= WDATA[15:8];
                					if (WSTRB[2]) stored_data[5'h1F][23:16] <= WDATA[23:16];
                					if (WSTRB[3]) stored_data[5'h1F][31:24] <= WDATA[31:24];
								end
					endcase
				end
				write_resp_flag <= 1'b1; //enables write response channel
			end

			else if(WVALID && ~WREADY) //timing violation happens but handshake has to be completed and data is discarded
			begin
				WREADY <= 1'b1;
				count_enable <= 1'b0;
				write_resp_flag <= 1'b1;
			end
			else
			begin
				WREADY <= 1'b0;
				write_resp_flag <= 1'b0;
			end

			//Write Response
			if(write_resp_flag)
			begin
				if(error_flag)
				begin
					BVALID <=1'b1;
					BRESP <= 2'b10;		//slave error
				end
				else
				begin
					BVALID <=1'b1;
					BRESP <= 2'b00;		//OKAY Response
				end
			end
			else if (BVALID && ~BREADY) //latch previous values if handshake is not yet completed
			begin
				BVALID <= BVALID;
				BRESP <= BRESP;
			end
			else
			begin
				BVALID <= 1'b0;
				BRESP <= 2'b00;
			end


			//Read Address cahnnel handshake
			if(ARVALID && ~ARREADY)
			begin
				ARREADY <= 1'b1;		////slave can wait for ARVALID signal before asserting ARREADY
				read_addr <= ARADDR;
				read_data_flag <= 1'b1;
			end
			else
			begin
				ARREADY <= 1'b0;
				read_data_flag <= 1'b0;
			end

			//Read Data channel
			if(read_data_flag)
			begin
				RVALID <= 1'b1;
				RDATA <= stored_data[read_addr];
				RRESP <= 2'b00;
			end
			else if (RVALID && ~RREADY) //latch if handshake is not yet completed
			begin
				RVALID <= 1'b1;
				RDATA <= stored_data[read_addr];
				RRESP <= 2'b00;
			end
			else
			begin
				RVALID <= 1'b0;
				RDATA <= 0;
			end

			if(count_enable) //count no. of clock cycle for timing violations and assert error_flag
			begin
				count <= count +1;
				if(count >= 1)
				begin
					error_flag <= 1;
				end
			end
			else
			begin
				count <= 0;
				error_flag <= 0;
			end


		end
	end





endmodule
