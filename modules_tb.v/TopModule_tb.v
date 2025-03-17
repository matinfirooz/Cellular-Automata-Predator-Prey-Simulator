`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: TopLevel_tb
// Project Name: Cellular Automata Predator Prey Simulator
//////////////////////////////////////////////////////////////////////////////////
module TopLevel_tb;
    reg clk;
    reg reset;
    reg start;
    reg [7:0] seed;
    wire done;

    parameter NUM_GENERATIONS = 20;

    TopLevel #(
        .NUM_GENERATIONS(NUM_GENERATIONS)
    ) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .seed(seed),
        .done(done)
    );

    always #5 clk = ~clk;

    task load_initial_values;
        begin
            $display("Loading initial values...");
            uut.load_initial_values();
            $display("Initial values loaded.");
        end
    endtask

    task write_final_values;
        begin
            $display("Writing final values...");
            uut.write_final_values();
            $display("Final values written.");
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        seed = 8'b10101010;

        #10;
        reset = 0;
        #10;
        reset = 1;
        #10;
        reset = 0;

        load_initial_values();

        #10;
        start = 1;

        wait(done);

        write_final_values();

        $finish;
    end

endmodule








