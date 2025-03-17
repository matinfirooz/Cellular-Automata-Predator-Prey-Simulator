`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: Cell
// Project Name: Cellular Automata Predator Prey Simulator
//////////////////////////////////////////////////////////////////////////////////
module Cell (
    input clk,
    input [1:0] north, south, east, west, // Neighbor states
    input [3:0] north_age, south_age, east_age, west_age, // Neighbor ages
    input [1:0] current_state, // Current state of the cell
    input [3:0] current_age, // Current age of the cell
    input [4:0] random, // Random number input
    output reg [1:0] next_state, // Next state of the cell
    output reg [3:0] next_age // Next age of the cell
);

// State definitions
localparam EMPTY = 2'b00;
localparam FISH = 2'b01;
localparam SHARK = 2'b10;

// Parameters for fish and shark survival/reproduction
parameter PUBERTY_AGE_FISH = 2;
parameter PUBERTY_AGE_SHARK = 4;
parameter MAX_AGE_FISH = 8;
parameter MAX_AGE_SHARK = 16;

integer fish_count, shark_count, puberty_fish_count, puberty_shark_count;

always @(posedge clk) begin
    // Count neighbors
    fish_count = 0;
    shark_count = 0;
    puberty_fish_count = 0;
    puberty_shark_count = 0;

    // Count neighboring species and puberty ages
    if (north == FISH) begin
        fish_count = fish_count + 1;
        if (north_age >= PUBERTY_AGE_FISH) puberty_fish_count = puberty_fish_count + 1;
    end
    if (south == FISH) begin
        fish_count = fish_count + 1;
        if (south_age >= PUBERTY_AGE_FISH) puberty_fish_count = puberty_fish_count + 1;
    end
    if (east == FISH) begin
        fish_count = fish_count + 1;
        if (east_age >= PUBERTY_AGE_FISH) puberty_fish_count = puberty_fish_count + 1;
    end
    if (west == FISH) begin
        fish_count = fish_count + 1;
        if (west_age >= PUBERTY_AGE_FISH) puberty_fish_count = puberty_fish_count + 1;
    end

    if (north == SHARK) begin
        shark_count = shark_count + 1;
        if (north_age >= PUBERTY_AGE_SHARK) puberty_shark_count = puberty_shark_count + 1;
    end
    if (south == SHARK) begin
        shark_count = shark_count + 1;
        if (south_age >= PUBERTY_AGE_SHARK) puberty_shark_count = puberty_shark_count + 1;
    end
    if (east == SHARK) begin
        shark_count = shark_count + 1;
        if (east_age >= PUBERTY_AGE_SHARK) puberty_shark_count = puberty_shark_count + 1;
    end
    if (west == SHARK) begin
        shark_count = shark_count + 1;
        if (west_age >= PUBERTY_AGE_SHARK) puberty_shark_count = puberty_shark_count + 1;
    end

    case (current_state)
        EMPTY: begin
            // Rule 1: Empty cell
            if ((fish_count > 3 && puberty_fish_count > 1 && shark_count < 4) ||
                (shark_count > 3 && puberty_shark_count > 1 && fish_count < 4)) begin
                if (fish_count > shark_count) begin
                    next_state = FISH;
                    next_age = 1;
                end else begin
                    next_state = SHARK;
                    next_age = -1;
                end
            end else begin
                next_state = EMPTY;
                next_age = 0;
            end
        end
        FISH: begin
            // Rule 2: Fish cell
            if (shark_count > 3 || fish_count > 6 || current_age >= MAX_AGE_FISH) begin
                next_state = EMPTY;
                next_age = 0;
            end else begin
                next_state = FISH;
                next_age = current_age + 1;
            end
        end
        SHARK: begin
            // Rule 3: Shark cell
            if ((shark_count > 3 && fish_count < 2) || (random % 32 == 0) || current_age >= MAX_AGE_SHARK) begin
                next_state = EMPTY;
                next_age = 0;
            end else begin
                next_state = SHARK;
                next_age = current_age + 1;
            end
        end
        default: begin
            next_state = EMPTY;
            next_age = 0;
        end
    endcase
end

endmodule


