proc AddWaves {} {
	;#Add waves we're interested in to the Wave window

	add wave -position end sim:/cache/clock
	add wave -position end sim:/cache/reset

	add wave -position end sim:/cache/s_addr
	add wave -position end sim:/cache/s_read
	add wave -position end sim:/cache/s_readdata
	add wave -position end sim:/cache/s_write
	add wave -position end sim:/cache/s_writedata
	add wave -position end sim:/cache/s_waitrequest

	add wave -position end sim:/cache/m_addr
	add wave -position end sim:/cache/m_read
	add wave -position end sim:/cache/m_readdata
	add wave -position end sim:/cache/m_write
	add wave -position end sim:/cache/m_writedata
	add wave -position end sim:/cache/m_waitrequest

	add wave -position end sim:/cache/cache_block

	add wave -position end sim:/cache/state
	add wave -position end sim:/cache/next_state

	add wave -position end sim:/cache/mem_state
	add wave -position end sim:/cache/next_mem_state

	add wave -position end sim:/cache/block_number
	add wave -position end sim:/cache/Read_NotWrite
}

vlib work

;# Compile components if any
vcom cache.vhd
vcom cache_tb.vhd
vcom memory.vhd

;# Start simulation
vsim cache_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 50 ns
run 50ns
