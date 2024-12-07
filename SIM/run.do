# Step 1: Compile all source files from the RTL directory
vlog -sv ../RTL/M_7SEG_DECODER.sv
vlog -sv ../RTL/M_ADDER.sv
vlog -sv ../RTL/M_ARRAY_MULT.sv
vlog -sv ../RTL/M_DISPLAY_RESULTS_S1.sv
vlog -sv ../RTL/M_MIPS_CPU.sv
vlog -sv ../RTL/M_MEM_ASYNC.sv
vlog -sv ../RTL/M_MULT.sv
vlog -sv ../RTL/M_MEM_SYNC.sv
vlog -sv ../RTL/M_CONTROLLER.sv
vlog -sv ../RTL/M_ALU_CONTROLLER.sv
vlog -sv ../RTL/M_IF_ID_REG.sv
vlog -sv ../RTL/M_ID_EX_REG.sv
vlog -sv ../RTL/M_EX_MEM_REG.sv
vlog -sv ../RTL/M_MEM_WB_REG.sv
vlog -sv ../RTL/M_PC_REG.sv
vlog -sv ../RTL/M_PC_ADDER.sv
vlog -sv ../RTL/M_SLL2.sv
vlog -sv ../RTL/M_MUX_2_DONTCARE.sv
vlog -sv ../RTL/M_REG_FILE.sv
vlog -sv ../RTL/M_MUX_2.sv
vlog -sv ../RTL/M_SEXT_16.sv
vlog -sv ../RTL/M_MUX_3_DONTCARE.sv
vlog -sv ../RTL/M_ALU.sv
vlog -sv ../RTL/M_HAZARD_UNIT.sv
vlog -sv ../RTL/M_EQUAL.sv
vlog -sv TB_MIPS_CPU.sv

# Step 2: Load the simulation with full visibility
vsim -voptargs="+acc=rn" TB_MIPS_CPU

# Step 3: Load the waveform configuration from wave.do if it exists
if {[file exists wave.do]} {
    do wave.do
} else {
    puts "Warning: wave.do file not found. No waveforms were added."
}

# Step 4: Run the simulation
run -all

# Step 5: Zoom out to show the entire waveform
wave zoom full

# Optional: Save the waveform to a .wlf file
write wave -o mips_waveform.wlf
