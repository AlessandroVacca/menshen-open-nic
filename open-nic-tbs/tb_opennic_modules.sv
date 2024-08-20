
`timescale 1ns / 1ps

module tb_opennic_modules #()();

wire                        clk;
wire                        axil_clk;
reg                         aresetn;
wire [31:0]                 shell_rst_done;
wire [31:0]                 user_rst_done;
wire                        rst_done;

reg [511:0]                 s_axis_tdata;
reg [5:0]                   s_axis_tuser_mty;
reg [31:0]                  s_axis_tuser;
reg                         s_axis_tvalid;
wire                        s_axis_tready;
reg                         s_axis_tlast;
reg [31:0]                  s_axis_tcrc;

wire [511:0]                m_axis_tdata;
wire [((512/8))-1:0]        m_axis_tkeep;
wire                        m_axis_tuser;
wire                        m_axis_tvalid;
reg                         m_axis_tready;
wire                        m_axis_tlast;
reg                         finished_config;
reg                         value_detected_add;
reg                         value_detected_sub;
reg                         tuser_error;
reg                         tuser_zero_byte;
reg [10:0]                  tuser_qid;
reg [2:0]                   tuser_port_id;

reg                         axil_awvalid;
reg [31:0]                  axil_awaddr;
wire                        axil_awready;
reg                         axil_wvalid;
reg [31:0]                  axil_wdata;
wire                        axil_wready;
wire                        axil_bvalid;
wire [1:0]                  axil_bresp;
reg                         axil_bready;
reg                         axil_arvalid;
reg [31:0]                  axil_araddr;
wire                        axil_arready;
wire                        axil_rvalid;
wire [31:0]                 axil_rdata;
wire [1:0]                  axil_rresp;
reg                         axil_rready;

assign rst_done = (&shell_rst_done) & (&user_rst_done);


// Output validation
// Define the target value you are looking for
// SUB EXPECTED OUTPUT
localparam logic [512-1:0] TARGET_VALUE_SUB = 512'h000000000100000002000000030000001a004c4d1a00e110d204dededede6f6f6f6f22de1140000001002e000045000801000081050403020100090000000000;
// ADD EXPECTED OUTPUT
localparam logic [512-1:0] TARGET_VALUE_ADD = 512'h000000000500000002000000030000000d00594d1a00e110d204dededede6f6f6f6f22de1140000001002e000045000801000081050403020100090000000000;
// TB_STAGES EXPECTED OUTPUT
localparam logic [512-1:0] TARGET_VALUE_STAGES = 512'h0000000050000000050000000a0000000d004c4d1a00e110d204dededede6f6f6f6f22de1140000001002e000045000803000081050403020100090000000000;


initial begin
    finished_config = 0;
    tuser_error = 0;
    tuser_zero_byte = 0;
    tuser_port_id = 0;
    tuser_qid = 0;
    
    axil_awvalid <= 0;
    axil_awaddr <= 0;
    axil_wvalid <= 0;
    axil_wdata <= 0;
    axil_bready <= 0;
    axil_arvalid <= 0;
    axil_araddr <= 0;
    axil_rready <= 0;
    
    aresetn = 1;
    @(clk == 1'b0);
    @(clk == 1'b1);
    aresetn = 0;
    @(posedge clk);
    aresetn = 1;
    @(rst_done == 1'b1);
    repeat(40)
        @(posedge clk);
    
    // set register for qdma with axi4 lite     
    axil_awvalid <= 1'b1;
    axil_awaddr <= 32'h00001000;
    axil_wvalid <= 1'b1;
    axil_wdata <= 32'h00000001;
    axil_bready <= 1'b1;
    @(axil_awready == 1'b1);
    @(posedge axil_clk);
    axil_awvalid <= 1'b0;
    @(axil_wready == 1'b1);
    @(posedge axil_clk);
    axil_wvalid <= 1'b0;
    axil_awaddr <= 32'h00000000;
    axil_wdata <= 32'h00000000;
    axil_bready <= 1'b0;
    @(axil_bvalid == 1'b1);
    
    
    repeat(40)
        @(posedge clk);
    s_axis_tcrc <= 32'b0;
    m_axis_tready <= 1'b1;
    s_axis_tuser <= 32'h0000004A;
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    repeat(3)
        @(posedge clk);
    // conf1.txt:
    s_axis_tdata <= 512'h000000000000000000000000000000010000902f2e00f2f1d204dededede6f6f6f6f0ede1140000001004200004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000270e250d230c910ba108;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00101100;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b11100001101100101001011100101101;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h000000000000000000000000000000010005902a2e00f2f1d204dededede6f6f6f6f0ede1140000001004200004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000270e250d230c910ba108;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00101100;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b01001000010011110100011000011100;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h0000000000000000000000000000000100014f5e1f00f2f1d204dededede6f6f6f6f1dde1140000001003300004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00111011;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b10000101011110010101010101000111;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h000000000000000000000000000000010f0117ea3300f2f1d204dededede6f6f6f6f09de1140000001004700004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000080ffff0000ffffffffffffffffffffffffffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00100111;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b01010011110101110111011110101000;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000275683400f2f1d204dededede6f6f6f6f08de1140000001004800004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000a00100000000000000000000000000000000000000001000;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00100110;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b00000111101011000111101100010100;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h000000000000000000000000000000000f02e83c6900f2f1d204dededede6f6f6f6fd3dd1140000001007d00004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h000f00001e00003c0000780000f00000e00100c003008007808c0200001e00003c0000780000f00000e00100c00300800700000f00001e00003c0000780000f0;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00000e00100c00300800700;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00110001;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b11100101101100110000111100011010;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000001000245683400f2f1d204dededede6f6f6f6f08de1140000001004800004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000d00000000000000000000000000000000000000000001000;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00100110;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b00000000100011010001010100011101;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h000000000000000000000000000000010f02e93b6900f2f1d204dededede6f6f6f6fd3dd1140000001007d00004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h000f00001e00003c0000780000f00000e00100c003008007808c0100001e00003c0000780000f00000e00100c00300800700000f00001e00003c0000780000f0;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00000e00100c00300800700;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00110001;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b01110110100001110001111100011111;
    repeat(30)
        @(posedge clk);


    // stateconf.txt:
    s_axis_tdata <= 512'h00000000000000000000000000000001001355541c00f2f1d204dededede6f6f6f6f20de1140000001003000004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00111110;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b10011010011001110000000000000101;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000002001351531c00f2f1d204dededede6f6f6f6f20de1140000001003000004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00111110;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b00000000101011000010001110000101;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h0000000000000000000000000000000300134d521c00f2f1d204dededede6f6f6f6f20de1140000001003000004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000804;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00111110;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b10001101100011111010001010101110;
    repeat(30)
        @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000004001349511c00f2f1d204dededede6f6f6f6f20de1140000001003000004500080f0000810504030201000b0a09080706;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tlast <= 1'b0;
    @(posedge clk);
    s_axis_tdata <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c04;
    s_axis_tvalid <= 1'b1;
    s_axis_tuser_mty <= 6'b00111110;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tcrc <= 32'b01000000010011011100010100101000;
    repeat(30)
        @(posedge clk);
    
    
    // TEST SUB    
    s_axis_tdata <= 512'h000000000000000002000000030000001a004c4d1a00e110d204dededede6f6f6f6f22de1140000001002e000045000801000081050403020100090000000000;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    @(m_axis_tvalid == 1'b1)
    //#(CYCLE/2)
    @(posedge clk);
	if (m_axis_tdata == TARGET_VALUE_SUB) begin 
        $display ("SUB TEST PASSED"); 
    end else begin
        $display ("SUB TEST FAILED");
    end
    repeat(100)
        @(posedge clk);
    // TEST ADD
    s_axis_tdata <= 512'h000000000000000002000000030000000d00594d1a00e110d204dededede6f6f6f6f22de1140000001002e000045000801000081050403020100090000000000;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    @(m_axis_tvalid == 1'b1)
    //#(CYCLE/2)
    @(posedge clk);
	if (m_axis_tdata == TARGET_VALUE_ADD) begin 
        $display ("ADD TEST PASSED"); 
    end else begin
        $display ("ADD TEST FAILED");
    end
    repeat(100)
        @(posedge clk);
    
    s_axis_tdata <= 512'h0000000028000000050000000a0000000d004c4d1a00e110d204dededede6f6f6f6f22de1140000001002e000045000803000081050403020100090000000000;	
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    @(m_axis_tvalid == 1'b1)
    //#(CYCLE/2)
    @(posedge clk);
	if (m_axis_tdata == TARGET_VALUE_STAGES) begin 
        $display ("STAGES TEST PASSED"); 
    end else begin
        $display ("STAGES TEST FAILED");
    end
    repeat(100)
        @(posedge clk);
    
    s_axis_tdata <= 512'h000000000000000002000000030000001a004c4d1a00e110d204dededede6f6f6f6f22de1140000001002e000045000802000081050403020100090000000000;
    s_axis_tuser_mty <= 6'b000000;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b1;
    @(posedge clk);
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    repeat(4)
        @(posedge clk);
    finished_config <= 1'b1;
    repeat(100)
        @(posedge clk);
    
    $finish(0);
end

property no_output_sim;
    @(posedge clk) finished_config |-> !m_axis_tvalid;
endproperty

assert property (no_output_sim) else $fatal("The module tries to write an output, it should discard everything!");


open_nic_shell #()
open_nic_shell_ins
(
	.axis_aclk(clk),		// axis clk
	.axil_aclk(axil_clk),		// axis clk
	.powerup_rstn(aresetn),
	.shell_rst_done(shell_rst_done),
	.user_rst_done(user_rst_done),

	// input Slave AXI Stream
	.s_axis_qdma_h2c_sim_tdata(s_axis_tdata),
	.s_axis_qdma_h2c_sim_tvalid(s_axis_tvalid),
	.s_axis_qdma_h2c_sim_tready(s_axis_tready),
	.s_axis_qdma_h2c_sim_tlast(s_axis_tlast),
	.s_axis_qdma_h2c_sim_tuser_err(tuser_error),
	.s_axis_qdma_h2c_sim_tuser_zero_byte(tuser_zero_byte),
	.s_axis_qdma_h2c_sim_tuser_mty(s_axis_tuser_mty),
	.s_axis_qdma_h2c_sim_tuser_mdata(s_axis_tuser),
	.s_axis_qdma_h2c_sim_tuser_qid(tuser_qid),
	.s_axis_qdma_h2c_sim_tuser_port_id(tuser_port_id),
	.s_axis_qdma_h2c_sim_tcrc(s_axis_tcrc),

	// output Master AXI Stream
	.m_axis_cmac_tx_sim_tdata(m_axis_tdata),
	.m_axis_cmac_tx_sim_tkeep(m_axis_tkeep),
	.m_axis_cmac_tx_sim_tvalid(m_axis_tvalid),
	.m_axis_cmac_tx_sim_tuser_err(m_axis_tuser),
	.m_axis_cmac_tx_sim_tready(m_axis_tready),
	.m_axis_cmac_tx_sim_tlast(m_axis_tlast),
	
	.s_axil_sim_awvalid(axil_awvalid),
	.s_axil_sim_awaddr(axil_awaddr),
	.s_axil_sim_awready(axil_awready),
	.s_axil_sim_wvalid(axil_wvalid),
	.s_axil_sim_wdata(axil_wdata),
	.s_axil_sim_wready(axil_wready),
	.s_axil_sim_bvalid(axil_bvalid),
	.s_axil_sim_bresp(axil_bresp),
	.s_axil_sim_bready(axil_bready),
	.s_axil_sim_arvalid(axil_arvalid),
	.s_axil_sim_araddr(axil_araddr),
	.s_axil_sim_arready(axil_arready),
	.s_axil_sim_rvalid(axil_rvalid),
	.s_axil_sim_rdata(axil_rdata),
	.s_axil_sim_rresp(axil_rresp),
	.s_axil_sim_rready(axil_rready)
);

endmodule
