module top_uart_de10lite(
	input wire CLOCK_50,
	input wire RESET_N,
	input wire UART_RX,
	output wire UART_TX
);
	
	wire reset;
	assign reset = ~RESET_N;
	
	wire [7:0] rx_data;
	wire rx_done;
	
	reg [7:0] tx_data;
	reg tx_start;
	wire tx_busy;
	

	uart_rx #(
		.CLK_FREQ(50000000),
		.BAUD_RATE(9600)
	) RX0 (
		.clk(CLOCK_50),
		.reset(reset),
		.rx(UART_RX),
		.data_out(rx_data),
		.data_valid(rx_done)
	);


	wire [31:0] resultado;
	
	operacion LUT (.in_val(rx_data),.out_val(resultado));


	uart_tx #(
		.CLK_FREQ(50000000),
		.BAUD_RATE(9600)
	) TX0 (
		.clk(CLOCK_50),
		.reset(reset),
		.tx_start(tx_start),
		.data_in(tx_data), 
		.tx(UART_TX),
		.busy(tx_busy)
	);
	
	
	reg [31:0] data_to_send;
	reg [2:0] tx_state;//casos de bytes     
	reg tx_busy_prev;//trabajo anterior        
	
	always @(posedge CLOCK_50 or posedge reset) begin
		if (reset) begin
			tx_data <= 8'd0;
			tx_start <= 1'b0;
			tx_state <= 2'd0;
			data_to_send <= 32'd0;
			tx_busy_prev <= 1'b0;
		end else begin
			tx_busy_prev <= tx_busy; +//estado anterior
			tx_start <= 1'b0;        
			
			case (tx_state)
				2'd0: begin 
					if (rx_done && !tx_busy) begin
						data_to_send <= resultado;    
						tx_data <= resultado[31:24];//Byte 4
						tx_start <= 1'b1;                 
						tx_state <= 2'd1;                 
					end
				end
				
				2'd1: begin 
					if (tx_busy_prev && !tx_busy) begin
						tx_data <= data_to_send[23:16];//Byte 3
						tx_start <= 1'b1;
						tx_state <= 2'd2;
					end
				end
				
				2'd2: begin 
					if (tx_busy_prev && !tx_busy) begin
						tx_data <= data_to_send[15:8];//Byte 2
						tx_start <= 1'b1;
						tx_state <= 2'd3;
					end
				end
				
				2'd3: begin 
					if (tx_busy_prev && !tx_busy) begin
						tx_data <= data_to_send[7:0];//Byte 1
						tx_start <= 1'b1;
						tx_state <= 2'd0;           
					end
				end
			endcase
		end
	end
endmodule
