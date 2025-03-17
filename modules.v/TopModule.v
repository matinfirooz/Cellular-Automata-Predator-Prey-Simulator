`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: TopLevel
// Project Name: Cellular Automata Predator Prey Simulator
//////////////////////////////////////////////////////////////////////////////////
module TopLevel (
    input clk,
    input reset,
    input start,
    input [7:0] seed,
    output reg done
);
    parameter NUM_GENERATIONS = 20;
    parameter SIZE = 50;

    reg [1:0] grid_state[0:SIZE-1][0:SIZE-1];
    reg [3:0] grid_age[0:SIZE-1][0:SIZE-1];
    wire [1:0] next_grid_state[0:SIZE-1][0:SIZE-1];
    wire [3:0] next_grid_age[0:SIZE-1][0:SIZE-1];
    wire [4:0] random_value;
    reg [15:0] generation_count;

    reg [7:0] lfsr;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
        end else begin
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
        end
    end
    assign random_value = lfsr[4:0];

    genvar i, j;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin: rows
            for (j = 0; j < SIZE; j = j + 1) begin: cols
                wire [1:0] north_state = (i > 0) ? grid_state[i-1][j] : grid_state[SIZE-1][j];
                wire [3:0] north_age = (i > 0) ? grid_age[i-1][j] : grid_age[SIZE-1][j];
                wire [1:0] south_state = (i < SIZE-1) ? grid_state[i+1][j] : grid_state[0][j];
                wire [3:0] south_age = (i < SIZE-1) ? grid_age[i+1][j] : grid_age[0][j];
                wire [1:0] east_state = (j < SIZE-1) ? grid_state[i][j+1] : grid_state[i][0];
                wire [3:0] east_age = (j < SIZE-1) ? grid_age[i][j+1] : grid_age[i][0];
                wire [1:0] west_state = (j > 0) ? grid_state[i][j-1] : grid_state[i][SIZE-1];
                wire [3:0] west_age = (j > 0) ? grid_age[i][j-1] : grid_age[i][SIZE-1];
                
                Cell cell_inst (
                    .clk(clk),
                    .north(north_state),
                    .south(south_state),
                    .east(east_state),
                    .west(west_state),
                    .north_age(north_age),
                    .south_age(south_age),
                    .east_age(east_age),
                    .west_age(west_age),
                    .current_state(grid_state[i][j]),
                    .current_age(grid_age[i][j]),
                    .random(random_value),
                    .next_state(next_grid_state[i][j]),
                    .next_age(next_grid_age[i][j])
                );
            end
        end
    endgenerate

    integer x, y;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            generation_count <= 0;
            done <= 0;
            load_initial_values();
        end else if (start && !done) begin
            // Update the grid with the next states
            for (x = 0; x < SIZE; x = x + 1) begin
                for (y = 0; y < SIZE; y = y + 1) begin
                    grid_state[x][y] <= next_grid_state[x][y];
                    grid_age[x][y] <= next_grid_age[x][y];
                end
            end

            // Print the grid
            for (x = 0; x < SIZE; x = x + 1) begin
                for (y = 0; y < SIZE; y = y + 1) begin
                    $write("%s ", (grid_state[x][y] == 2'b00) ? "E" : (grid_state[x][y] == 2'b01) ? "F" : "S");
                end
                $write("\n");
            end

            generation_count <= generation_count + 1;
            $display("Generation: %d", generation_count);

            if (generation_count >= NUM_GENERATIONS) begin
                done <= 1;
                write_final_values();
            end
        end
    end

    task load_initial_values;
        integer file, i, j, value;
        begin
            file = $fopen("C:/Users/surface/Documents/Term2/2.Bio/2.Homework/HW3/TripleP/initial_values.txt", "r");
            if (file == 0) begin
                $display("Error: Cannot open input file.");
                $finish;
            end
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    if (!$feof(file)) begin
                        $fscanf(file, "%d", value);
                        if (value == 1) begin
                            grid_state[i][j] <= 2'b01;
                            grid_age[i][j] <= 4'b0001;
                        end else if (value == 2) begin
                            grid_state[i][j] <= 2'b10;
                            grid_age[i][j] <= 4'b1111; // -1 in 4-bit 2's complement
                        end else begin
                            grid_state[i][j] <= 2'b00;
                            grid_age[i][j] <= 4'b0000;
                        end
                    end
                end
            end
            $fclose(file);
            $display("Initial values loaded successfully.");
        end
    endtask

    task write_final_values;
        integer file, i, j;
        begin
            file = $fopen("C:/Users/surface/Documents/Term2/2.Bio/2.Homework/HW3/TripleP/final_values.txt", "w");
            if (file == 0) begin
                $display("Error: Cannot open output file.");
                $finish;
            end
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    if (grid_state[i][j] == 2'b01) begin
                        $fwrite(file, "F%d ", grid_age[i][j]);
                    end else if (grid_state[i][j] == 2'b10) begin
                        $fwrite(file, "S%d ", grid_age[i][j]);
                    end else begin
                        $fwrite(file, "E ");
                    end
                end
                $fwrite(file, "\n");
            end
            $fclose(file);
            $display("Final values written successfully.");
        end
    endtask

endmodule


