module hazard_unit(
    rst,
    RegWriteM,
    RegWriteW,
    ResultSrcE,
    RD_M,
    RD_W,
    RD_E,
    Rs1_E,
    Rs2_E,
    Rs1_D,
    Rs2_D,
    PCSrcE,
    ForwardAE,
    ForwardBE,
    StallF,
    StallD,
    FlushD,
    FlushE
);

    input rst, RegWriteM, RegWriteW, PCSrcE;
    input [1:0] ResultSrcE;
    input [4:0] RD_M, RD_W, RD_E, Rs1_E, Rs2_E, Rs1_D, Rs2_D;

    output [1:0] ForwardAE, ForwardBE;
    output StallF, StallD, FlushD, FlushE;

    wire LoadUseHazard;

    // load-use hazard:
    // instruction in EX is lw, and instruction in ID needs its rd
    assign LoadUseHazard =
            (ResultSrcE == 2'b01) &&
            (RD_E != 5'd0) &&
            ((RD_E == Rs1_D) || (RD_E == Rs2_D));

    // stall fetch and decode for load-use hazard
    assign StallF = LoadUseHazard;
    assign StallD = LoadUseHazard;

    // static branch prediction: predict not taken
    // if actually taken, flush wrong-path instructions
    assign FlushD = PCSrcE;
    assign FlushE = PCSrcE | LoadUseHazard;

    // forwarding to ALU source A
    assign ForwardAE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) && (RD_M != 5'h00) && (RD_M == Rs1_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) && (RD_W != 5'h00) && (RD_W == Rs1_E)) ? 2'b01 :
                                                                                       2'b00;

    // forwarding to ALU source B
    assign ForwardBE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) && (RD_M != 5'h00) && (RD_M == Rs2_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) && (RD_W != 5'h00) && (RD_W == Rs2_E)) ? 2'b01 :
                                                                                       2'b00;

endmodule