/*`timescale 1ns / 1ps

module fetch_cycle_tb();

    // Declare inputs as registers and outputs as wires
    reg clk;
    reg rst;
    reg PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD;
    wire [31:0] PCD;
    wire [31:0] PCPlus4D;

    // Instantiate the Device Under Test (DUT)
    fetch_cycle dut (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Clock Generation Logic (Toggles every 50ns -> 100ns period)
    initial begin
        clk = 1'b0;
    end
    
    always begin
        #50;
        clk = ~clk;
    end

    // Stimulus Block
    initial begin
        // Apply active-low reset initially [00:31:26]
        rst = 1'b0;
        // Wait for 200 time units, then release reset [00:31:31]
        #200;
        rst = 1'b1;
        PCSrcE = 1'b0;
        PCTargetE = 32'h00000000;
        // Run simulation for an additional 500 time units [00:32:07]
        #500;
        $finish;
    end

 initial begin
        // Setup VCD Dumping for waveforms
        $dumpfile("dump.vcd");
        $dumpvars(0, fetch_cycle_tb);
 end


endmodule
*/