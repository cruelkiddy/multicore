onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate /system_tb/DUT/CPU/dcif1/datomic
add wave -noupdate -group CC /system_tb/DUT/CPU/CC/CLK
add wave -noupdate -group CC /system_tb/DUT/CPU/CC/nRST
add wave -noupdate -group CC /system_tb/DUT/CPU/CC/instr
add wave -noupdate -group CC /system_tb/DUT/CPU/CC/instr_nxt
add wave -noupdate -group CC /system_tb/DUT/CPU/CC/final_iaddr
add wave -noupdate -group CC /system_tb/DUT/CPU/CC/final_iREN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -expand -group exmem0 /system_tb/DUT/CPU/DP0/prif/opcode_id
add wave -noupdate -expand -group exmem0 /system_tb/DUT/CPU/DP0/PR/prif/opcode_mem
add wave -noupdate -expand -group exmem0 /system_tb/DUT/CPU/DP0/PR/prif/pc_mem
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/dmemstore
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iaddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccinv
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwrite
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/cctrans
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccsnoopaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/datomic
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -group exmem1 /system_tb/DUT/CPU/DP1/prif/opcode_id
add wave -noupdate -group exmem1 /system_tb/DUT/CPU/DP1/PR/prif/opcode_mem
add wave -noupdate -group exmem1 /system_tb/DUT/CPU/DP1/PR/prif/pc_mem
add wave -noupdate /system_tb/DUT/CPU/DP1/dpif/dmemstore
add wave -noupdate -expand /system_tb/DUT/CPU/DP0/RF/reg_file
add wave -noupdate /system_tb/DUT/CPU/DP1/RF/reg_file
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/n_state
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/linkreg
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/dmemWEN
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/vlink
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/vlink_n
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/DP0/dpif/dmemREN
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/DP0/dpif/datomic
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/s1_data1
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/s1_data2
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/s2_data1
add wave -noupdate -expand -group {Cache data} /system_tb/DUT/CPU/CM0/DCACHE/s2_data2
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/n_state
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/cif/ccsnoopaddr
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/linkreg
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/cif/ccinv
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/dmemWEN
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/vlink
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/vlink_n
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/DP1/dpif/dmemREN
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/DP1/dpif/datomic
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/DP1/dpif/dmemaddr
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/DP1/dpif/dmemstore
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/n_s1_data1
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/n_s1_data2
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/s2_data1
add wave -noupdate -expand -group cache2 /system_tb/DUT/CPU/CM1/DCACHE/s2_data2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1830168 ps} 0}
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
WaveRestoreZoom {0 ps} {4200 ns}
