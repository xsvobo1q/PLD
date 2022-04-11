onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib FIR_50k_opt

do {wave.do}

view wave
view structure
view signals

do {FIR_50k.udo}

run -all

quit -force
