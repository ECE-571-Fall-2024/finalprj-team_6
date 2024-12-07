onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/pc
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/instr
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/instrD
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/pcplus4D
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/branch
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/jump
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/regwrite
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/srca
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/srcb
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/signimmD
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/equalD
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/stallD
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/forwardAD
add wave -noupdate /TB_MIPS_CPU/MIPS_DUT/forwardBD
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {191 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 248
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2638 ps}
