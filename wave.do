onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/instr
add wave -noupdate /system_tb/DUT/CPU/DP/pc
add wave -noupdate -expand /system_tb/DUT/CPU/DP/RF/reg_file
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/ALU/aluif/portA
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/ALU/aluif/portB
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/ALU/aluif/portOut
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/ALU/aluif/neg_flag
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/ALU/aluif/zero_flag
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/ALU/aluif/of_flag
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/ALU/aluif/ALUOP
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/dhit
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/ihit
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/halt
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/ptAScr
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/ptBScr
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/regwrite_mem
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/regwrite_wb
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/rs
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/rt
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/rs_ex
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/rt_ex
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/regwen_mem
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/regwen_wb
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/memren_ex
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/ifid_en
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/idex_en
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/exmem_en
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/memwb_en
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/pc_en
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/flush_idex
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/flush_ifid
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/flush_exmem
add wave -noupdate -expand -group hu /system_tb/DUT/CPU/DP/huif/flush_memwb
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -expand -group ram /system_tb/DUT/RAM/ramif/memstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4872044 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1147856 ps} {8028208 ps}
