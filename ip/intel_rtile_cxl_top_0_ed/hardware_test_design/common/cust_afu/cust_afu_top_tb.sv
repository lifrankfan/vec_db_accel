module cust_afu_top_tb (

);

logic axi4_mm_clk, axi4_mm_rst_n;
logic        csr_avmm_clk;
always #1 axi4_mm_clk = ~axi4_mm_clk;
always #1 csr_avmm_clk = ~csr_avmm_clk;
logic        csr_avmm_rstn;  
logic        csr_avmm_waitrequest;            
logic [63:0] csr_avmm_readdata;            
logic        csr_avmm_readdatavalid;          
logic [63:0] csr_avmm_writedata;          
logic [21:0] csr_avmm_address;              
logic        csr_avmm_write;                
logic        csr_avmm_read;                  
logic [7:0]  csr_avmm_byteenable;

logic [11:0]               arid;
logic [63:0]               araddr;  // Read addr
// logic [9:0]                arlen,
// logic [2:0]                arsize,
// logic [1:0]                arburst,
// logic [2:0]                arprot,
// logic [3:0]                arqos,
logic [5:0]                aruser;
logic                      arvalid; // Read addr valid indicator
// logic [3:0]                arcache,
// logic [1:0]                arlock,
// logic [3:0]                arregion,
logic                      arready; // IP ready to accept read address

logic [11:0]                rid;
logic [511:0]              rdata;  // Read data
logic [1:0]                rresp;  // 00 - OKAY, 10 - ERROR
logic                       rlast;
// logic                       ruser,
logic                      rvalid; // Read data valid indicator
logic                      rready;  // AFU ready to accept read data

logic [11:0]              awid;
logic [63:0]               awaddr;  // Write addr
logic                      awvalid;
logic                     awready;
logic [5:0]               awuser;
logic [511:0]              wdata;
logic [(512/8)-1:0]        wstrb;
logic                     wlast;
logic                       wvalid;
logic                     wready;

logic [11:0]                bid;
logic [1:0]               bresp;
logic                     bvalid;
logic                     bready;


logic [63:0] result; 
logic [11:0] id_buffer [16384];
logic [63:0] id_cnt;
logic [63:0] test_case;
logic [63:0] pre_test_case; 

cust_afu_wrapper cust_afu_wrapper_inst
(
      // Clocks
  .axi4_mm_clk(axi4_mm_clk), 

    // Resets
  .axi4_mm_rst_n(axi4_mm_rst_n),
  
  // [harry] AVMM interface - imported from ex_default_csr_top
  .csr_avmm_clk(csr_avmm_clk),
  .csr_avmm_rstn(csr_avmm_rstn),  
  // .csr_avmm_waitrequest,  
  .csr_avmm_readdata(csr_avmm_readdata),
  .csr_avmm_readdatavalid(csr_avmm_readdatavalid),
  .csr_avmm_writedata(csr_avmm_writedata),
  .csr_avmm_address(csr_avmm_address),
  .csr_avmm_write(csr_avmm_write),
  .csr_avmm_read(csr_avmm_read), 
  .csr_avmm_byteenable(csr_avmm_byteenable),

  /*
    AXI-MM interface - write address channel
  */
  .awid(awid),
  .awaddr(awaddr), 
  // .awlen,
  // .awsize,
  // .awburst,
  // .awprot,
  // .awqos,
  .awuser(awuser),
  .awvalid(awvalid),
  // .awcache,
  // .awlock,
  // .awregion,
  .awready(awready),
  
  /*
    AXI-MM interface - write data channel
  */
  .wdata(wdata),
  .wstrb(wstrb),
  .wlast(wlast),
  // .wuser,
  .wvalid(wvalid),
  .wready(wready),
  
  /*
    AXI-MM interface - write response channel
  */ 
  .bid(bid),
  .bresp(bresp),
  //  .buser,
  .bvalid(bvalid),
  .bready(bready),
  
  /*
    AXI-MM interface - read address channel
  */
  .arid(arid),
  .araddr(araddr),
  // .arlen,
  // .arsize,
  // .arburst,
  // .arprot,
  // .arqos,
  .aruser(aruser),
  .arvalid(arvalid),
  // .arcache,
  // .arlock,
  // .arregion,
  .arready(arready),

  /*
    AXI-MM interface - read response channel
  */ 
  .rid(rid),
  .rdata(rdata),
  .rresp(rresp),
  .rlast(rlast),
  //  .ruser,
  .rvalid(rvalid),
  .rready(rready)
);

initial begin
    bresp = 2'b01; //OK signal 
	  rresp = 2'b00;
    axi4_mm_clk = 0;
    csr_avmm_clk = 0;
    axi4_mm_rst_n = 0;
    csr_avmm_rstn = 0;
#2  axi4_mm_rst_n = 1;
    csr_avmm_rstn = 1;
    csr_avmm_byteenable = '1;
    csr_avmm_read = 0;
    csr_avmm_write = 0;


/*###################################
NC RD sequential 64 times, host
########################################*/
// $display("-----------NC RD sequential 64 times, host");
// rdata = 512'd0;
// arready = 1;
// test_case = 0;
// rvalid = 0; 

// #20	csr_avmm_address = 22'h50; //write to seed_reg
// 	  csr_avmm_writedata = 64'd20231122;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;

// #20	csr_avmm_address = 22'h18; //write to test_case_reg
// 	  csr_avmm_writedata = 64'd1;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;

// #20	csr_avmm_address = 22'h58; //write to num_request_reg
// 	  csr_avmm_writedata = 64'd256;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;

// #20	csr_avmm_address = 22'h60; //write to addr_range_reg
// 	  csr_avmm_writedata = 64'd2;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;

// test_case = 64'd19;

// #2000	csr_avmm_address = 22'h8; //write to page_addr_0 reg
// 	  csr_avmm_writedata = 64'd0;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;

// @(negedge axi4_mm_clk iff id_cnt == 64'd1);

// for (int i = 0; i < id_cnt; i++) begin
//   #2
//   rvalid = 1;
//   rlast = 1;
//   rid = id_buffer[i];
//   #2 
//   rvalid = 0;
//   rlast = 0;
//   #10
//   rdata = rdata + 1;
// end


// #10
// if (arvalid) begin
//   $display("---------error---------");
// end

// #20	csr_avmm_address = 22'h10; //read from delay_out
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the latency for 16 read is %d", result);

// #200	csr_avmm_address = 22'h10; //read from delay_out
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the latency for 16 read is %d", result);

// #20	csr_avmm_address = 22'h20; //read from resp_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the first latency is %d", result);

// #20	csr_avmm_address = 22'h28; //read from addr_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the addr cnt is %d", result);


// #20	csr_avmm_address = 22'h30; //read from data_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the data cnt is %d", result);

// #20	csr_avmm_address = 22'h40; //read from id_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the id cnt is %h", result);

// #20	csr_avmm_address = 22'h48; //read from id_cnt1_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the id cnt 1 is %h", result);

/*###################################
NC WR sequential 16 times, host
########################################*/
$display("-----------NC WR sequential 64 times, host");
awready = 1;
wready = 1;
test_case = 0;

#20	csr_avmm_address = 22'h50; //write to seed_reg
	  csr_avmm_writedata = 64'd1548;
#2  csr_avmm_write = 1;
#2	csr_avmm_write = 0;

#20	csr_avmm_address = 22'h18; //write to test_case_reg
	  csr_avmm_writedata = 64'd12;
#2  csr_avmm_write = 1;
#2	csr_avmm_write = 0;

#20	csr_avmm_address = 22'h58; //write to num_request_reg
	  csr_avmm_writedata = 64'd512;
#2  csr_avmm_write = 1;
#2	csr_avmm_write = 0;

#20	csr_avmm_address = 22'h60; //write to addr_range_reg
	  csr_avmm_writedata = 64'd1;
#2  csr_avmm_write = 1;
#2	csr_avmm_write = 0;

test_case = 19;

#2	csr_avmm_address = 22'h8; //write to page_addr_0 reg
	  csr_avmm_writedata = 64'd0;
#2  csr_avmm_write = 1;
#2	csr_avmm_write = 0;


@(negedge axi4_mm_clk iff id_cnt == 64'd1);

for (int i = 0; i<id_cnt; i++) begin
  #10 bvalid = 1;
      bid = id_buffer[i];
  @(negedge csr_avmm_clk iff bready);
  #2  bvalid = 0; 
end

#10
if (awvalid) begin
  $display("---------error---------");
end

#20	csr_avmm_address = 22'h10; //read from delay_out
#2  csr_avmm_read = 1;
#2	csr_avmm_read = 0;
@(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
result = csr_avmm_readdata;
$display("the latency for 16 write is %d", result);

#20	csr_avmm_address = 22'h10; //read from delay_out
#2  csr_avmm_read = 1;
#2	csr_avmm_read = 0;
@(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
result = csr_avmm_readdata;
$display("the latency for 16 write is %d", result);

#20	csr_avmm_address = 22'h20; //read from resp_reg
#2  csr_avmm_read = 1;
#2	csr_avmm_read = 0;
@(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
result = csr_avmm_readdata;
$display("the bresp is %d", result);

#20	csr_avmm_address = 22'h28; //read from addr_cnt_reg
#2  csr_avmm_read = 1;
#2	csr_avmm_read = 0;
@(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
result = csr_avmm_readdata;
$display("the addr cnt is %d", result);


#20	csr_avmm_address = 22'h30; //read from data_cnt_reg
#2  csr_avmm_read = 1;
#2	csr_avmm_read = 0;
@(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
result = csr_avmm_readdata;
$display("the data cnt is %d", result);

#20	csr_avmm_address = 22'h38; //read from resp_cnt_reg
#2  csr_avmm_read = 1;
#2	csr_avmm_read = 0;
@(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
result = csr_avmm_readdata;
$display("the resp cnt is %d", result);

#20	csr_avmm_address = 22'h40; //read from id_cnt_reg
#2  csr_avmm_read = 1;
#2	csr_avmm_read = 0;
@(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
result = csr_avmm_readdata;
$display("the id cnt is %h", result);

#20	csr_avmm_address = 22'h48; //read from id_cnt1_reg
#2  csr_avmm_read = 1;
#2	csr_avmm_read = 0;
@(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
result = csr_avmm_readdata;
$display("the id cnt 1 is %h", result);


/*###################################
NC WR sequential 16 times, host, case 20
########################################*/
// $display("-----------NC WR sequential 16 times, host, case 20");
// awready = 1;
// wready = 1;

// #20	csr_avmm_address = 22'h18; //write to test_case_reg
// 	  csr_avmm_writedata = 64'd21;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;
// #2	csr_avmm_address = 22'h8; //write to page_addr_0 reg
// 	  csr_avmm_writedata = 64'd40;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;



// #200
// for (int i = 0; i<16; i++) begin
//   #10 bvalid = 1;
//       bid = id_buffer[15-i];
//   @(negedge csr_avmm_clk iff bready);
//   #2  bvalid = 0; 
// end

// #10
// if (awvalid) begin
//   $display("---------error---------");
// end


// #20	csr_avmm_address = 22'h10; //read from delay_out
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the latency for 16 write is %d", result);

// #20	csr_avmm_address = 22'h20; //read from resp_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the bresp is %b", result);

// #20	csr_avmm_address = 22'h28; //read from addr_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the addr cnt is %d", result);


// #20	csr_avmm_address = 22'h30; //read from data_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the data cnt is %d", result);

// #20	csr_avmm_address = 22'h38; //read from resp_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the resp cnt is %d", result);

// #20	csr_avmm_address = 22'h40; //read from id_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the id cnt is %h", result);

// #20	csr_avmm_address = 22'h48; //read from id_cnt1_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the id cnt 1 is %h", result);


/*###################################
NC WR sequential 16 times, host, case 24
########################################*/
// $display("-----------NC WR sequential 16 times, host, case 24");
// awready = 1;
// wready = 1;

// #20	csr_avmm_address = 22'h18; //write to test_case_reg
// 	  csr_avmm_writedata = 64'd24;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;
// #2	csr_avmm_address = 22'h8; //write to page_addr_0 reg
// 	  csr_avmm_writedata = 64'd40;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;



// #200
// for (int i = 0; i<16; i++) begin
//   #10 bvalid = 1;
//       bid = id_buffer[15-i];
//   @(negedge csr_avmm_clk iff bready);
//   #2  bvalid = 0; 
// end

// #10
// if (awvalid) begin
//   $display("---------error---------");
// end


// #20	csr_avmm_address = 22'h10; //read from delay_out
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the latency for 16 write is %d", result);

// #20	csr_avmm_address = 22'h20; //read from resp_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the bresp is %b", result);

// #20	csr_avmm_address = 22'h28; //read from addr_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the addr cnt is %d", result);


// #20	csr_avmm_address = 22'h30; //read from data_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the data cnt is %d", result);

// #20	csr_avmm_address = 22'h38; //read from resp_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the resp cnt is %d", result);

// #20	csr_avmm_address = 22'h40; //read from id_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the id cnt is %h", result);

// #20	csr_avmm_address = 22'h48; //read from id_cnt1_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the id cnt 1 is %h", result);





/*###################################
NC WR until awready is low
########################################*/
// $display("-----------NC WR until awready is low, host");
// awready = 1;
// wready = 1;
// test_case = 1;
// #10
// test_case = 2;
// #20	csr_avmm_address = 22'h18; //write to test_case_reg
// 	  csr_avmm_writedata = 64'd51;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;
// #2	csr_avmm_address = 22'h8; //write to page_addr_0 reg
// 	  csr_avmm_writedata = 64'd40;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;

// @(negedge csr_avmm_clk iff id_cnt == 64'd16777215);
// awready = 0;
// wready = 0;

// #10
// if (awvalid) begin
//   $display("---------error---------");
// end

// #20	csr_avmm_address = 22'h10; //read from delay_out
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the latency for 16 write is %d", result);

// #20	csr_avmm_address = 22'h20; //read from resp_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the bresp is %d", result);

// #20	csr_avmm_address = 22'h28; //read from addr_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the addr cnt is %d", result);


// #20	csr_avmm_address = 22'h30; //read from data_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the data cnt is %d", result);

// #20	csr_avmm_address = 22'h38; //read from resp_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the resp cnt is %d", result);



/*###################################
NC RD until arready is low
########################################*/
// $display("-----------NC RD until arready is low, host");
// rdata = 512'd0;
// arready = 1;
// test_case = 0;

// #20	csr_avmm_address = 22'h18; //write to test_case_reg
// 	  csr_avmm_writedata = 64'd21;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;

// test_case = 64'd21;

// #2	csr_avmm_address = 22'h8; //write to page_addr_0 reg
// 	  csr_avmm_writedata = 64'd20;
// #2  csr_avmm_write = 1;
// #2	csr_avmm_write = 0;

// @(negedge csr_avmm_clk iff arid == 64'd100);
// arready = 0;

// #10
// if (arvalid) begin
//   $display("---------error---------");
// end

// #20	csr_avmm_address = 22'h28; //read from addr_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the addr cnt is %d", result);


// #20	csr_avmm_address = 22'h30; //read from data_cnt_reg
// #2  csr_avmm_read = 1;
// #2	csr_avmm_read = 0;
// @(negedge csr_avmm_clk iff csr_avmm_readdatavalid);
// result = csr_avmm_readdata;
// $display("the data cnt is %d", result);


// id_cnt = {38'b0, 3'b0, 1'b0, 16'b0, 6'b0};
// $display("random write device min : %b",id_cnt);
// $display("random write device min : %d",id_cnt/1024/1024);
// #10
// id_cnt = {38'b0, 3'b111, 1'b0, 16'hffff, 6'b0};
// $display("random write device max : %b",id_cnt);
// $display("random write device max : %d",id_cnt/1024/1024);
// $display("------------------");

// id_cnt = {31'b0, 1'b0, 1'b1, 25'b0, 6'b0};
// $display("random read device min : %b",id_cnt);
// $display("random read device min : %d",id_cnt/1024/1024/1024);
// #10
// id_cnt = {31'b0, 1'b1, 1'b1, 25'h1ffffff, 6'b0};
// $display("random read device max : %b",id_cnt);
// $display("random read device max : %d",id_cnt/1024/1024/1024);
// $display("------------------");

// #10
// id_cnt = {27'b0, 4'b0, 1'b1, 26'b0, 6'b0};
// $display("random read host min : %b",id_cnt);
// $display("random read host min : %d",id_cnt/1024/1024/1024);
// #10
// id_cnt = {27'b0, 4'b1111, 1'b1, 26'h3ffffff, 6'b0};
// $display("random read host max : %b",id_cnt);
// $display("random read host max : %d",id_cnt/1024/1024/1024);
// $display("------------------");

// #10
// id_cnt = {27'b0, 3'b000, 1'b1, 27'b0, 6'b0};
// $display("random write host min : %b",id_cnt);
// $display("random write host min : %d",id_cnt/1024/1024/1024);
// #10
// id_cnt = {27'b0, 3'b111, 1'b1, 27'h7ffffff, 6'b0};
// $display("random write host max : %b",id_cnt);
// $display("random write host max : %d",id_cnt/1024/1024/1024);
// $display("------------------");

#20
$stop;

end

always_ff @(posedge axi4_mm_clk) begin
  pre_test_case <= test_case;
  if (pre_test_case != test_case) begin
    id_cnt = 0;
  end
  if (arready & arvalid) begin
    id_buffer[id_cnt] = arid;
    id_cnt = id_cnt + 1;
  end
  if (awready & awvalid) begin
    id_buffer[id_cnt] = awid;
    id_cnt = id_cnt + 1;
  end
end


always_ff @(posedge axi4_mm_clk) begin
  //write signal
  // if (awready & awvalid) begin
  //   $display("write adress");
  //   $display("awuser: %b", awuser);
  //   $display("awid: %d", awid);
  //   $display("id_cnt: %d", id_cnt);
  //   $display("--------------");
  // end
  if (wready & wvalid) begin
    // if ((id_cnt%2000 <= 10) && (id_cnt%2000 >0)) begin
      $display("awuser: %b", awuser);
      $display("awid: %d", awid);
      $display("id_cnt: %d", id_cnt);
      $display("write data %h at addr %d, wstrb: %h", wdata, awaddr/1024, wstrb);
      if (wlast) begin
        $display("write data end");
      end
      $display("--------------");
    // end
  end
  // if (bready & bvalid) begin
  //   $display("write response");
  //   $display("b id: %d", bid);
  //   $display("--------------");
  // end


  //read signal
  if (arready & arvalid) begin
    // if ((id_cnt%2000 <= 10) && (id_cnt%2000 >0)) begin
      $display("ready adress");
      $display("araddr: %d", araddr/1024);
      $display("aruser: %b", aruser);
      $display("arid: %d", arid);
      $display("id_cnt: %d", id_cnt);
      $display("--------------");
    // end
  end
  // if (rready & rvalid) begin
  //   $display("ready data: %2d", rdata);
  //   $display("ready id: %d", rid);
  //   if (rlast) begin
  //     $display("ready data end");
  //   end
  //   $display("--------------");
  // end

end

endmodule