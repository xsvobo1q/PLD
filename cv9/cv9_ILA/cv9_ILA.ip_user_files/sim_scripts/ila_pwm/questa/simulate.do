onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ila_pwm_opt

do {wave.do}

view wave
view structure
view signals

do {ila_pwm.udo}

run -all

quit -force
