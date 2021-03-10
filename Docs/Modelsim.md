## Basic Workflow and Commands

### Init

`vlib work`创建名为work的design library，work在modelsim中默认映射到文件夹`./work`

modelsim.ini中会声明各个库(design library)如何映射，在文件夹中使用vmap命令可以查看

### Compile

可以从不同的地方取source code编译成某一个lib

`vlog module.sv`

### Load

To load the design 'module' from library 'work' `vsim work.module`

> The newest Modelsim versions are sometimes optimizing too greedily and you won't necessarily see all the signals. In those cases, just disable optimizations: `vsim -novopt work.module`

### Prepare

set up simulation/debug environment

`view objects` - See signals and their values

`view locals`   - See vars and their values

`view source`   - Trace code line-by-line

`view wave -undock` 



`add wave /sttran/count_v `

sttran is a process name



To generate the input stimuli:

`force -deposit /clk 1 0, 0 {10ns} -repeat 20`

The default time unit is defined in modelsim.ini and is **ns**

### Run

`run <time>` 

`force -deposit /keys_in 10#4, 10#1 20, 10#6 40, 10#9 60, 10#0 80`

10#1 20: to 10进制的1  20ns later

change the radix for some signals shown in waveform window

`property wave -radix unsigned /lock/keys_in`

use macro file(.do)

`do filename.do`



### Debug

`examine sig/var`

`examine -time 675 /curr_state_r`

`examine -binary /sttran/count_v`

`change sttran/count_v 12`



`bp lock.vhd 64`

`run`

`step`



Measuring Time

Add-> Cursor

