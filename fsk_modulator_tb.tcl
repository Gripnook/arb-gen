proc AddWaves {} {
    ;#Add waves we're interested in to the Wave window
    add wave -position end sim:/fsk_modulator_tb/clock
    add wave -position end sim:/fsk_modulator_tb/reset
    add wave -position end sim:/fsk_modulator_tb/nrz_data
    add wave -position end sim:/fsk_modulator_tb/frequency
}

vlib work

;# Compile components
vcom fsk_delay_equalizer.vhd
vcom accumulator.vhd
vcom fsk_bit_slice.vhd
vcom fsk_modulator.vhd
vcom fsk_modulator_tb.vhd

;# Start simulation
vsim -t ps fsk_modulator_tb

;# Generate a clock
force -deposit clock 0 0 ns, 1 7.8125 ns -repeat 15.625 ns

;# Add the waves
AddWaves

;# Run
run 16000ns
