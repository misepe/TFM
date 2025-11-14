
# XM-Sim Command File
# TOOL:	xmsim(64)	24.03-s004
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
set vcd_compact_mode 0
set vhdl_forgen_loopindex_enum_pos 0
set xmreplay_dc_debug 0
set tcl_runcmd_interrupt next_command
set tcl_sigval_prefix {#}
alias . run
alias indago verisium
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves rsync_latch_tb.dut.vssana rsync_latch_tb.dut.vddana_0p8 rsync_latch_tb.dut.pdb rsync_latch_tb.dut.iref_25ua rsync_latch_tb.dut.dataoutthermb rsync_latch_tb.dut.dataouttherm rsync_latch_tb.dut.dataoutbinb rsync_latch_tb.dut.dataoutbin rsync_latch_tb.dut.datainthermb rsync_latch_tb.dut.dataintherm rsync_latch_tb.dut.datainbinb rsync_latch_tb.dut.datainbin rsync_latch_tb.dut.clkinb_therm_16 rsync_latch_tb.dut.clkinb_therm_15 rsync_latch_tb.dut.clkinb_therm_14 rsync_latch_tb.dut.clkinb_therm_13 rsync_latch_tb.dut.clkinb_therm_12 rsync_latch_tb.dut.clkinb_therm_11 rsync_latch_tb.dut.clkinb_therm_10 rsync_latch_tb.dut.clkinb_therm_9 rsync_latch_tb.dut.clkinb_therm_8 rsync_latch_tb.dut.clkinb_therm_7 rsync_latch_tb.dut.clkinb_therm_6 rsync_latch_tb.dut.clkinb_therm_5 rsync_latch_tb.dut.clkinb_therm_4 rsync_latch_tb.dut.clkinb_therm_3 rsync_latch_tb.dut.clkinb_therm_2 rsync_latch_tb.dut.clkinb_therm_1 rsync_latch_tb.dut.clkinb_therm_0 rsync_latch_tb.dut.clkinb_binary_5 rsync_latch_tb.dut.clkinb_binary_4 rsync_latch_tb.dut.clkinb_binary_3 rsync_latch_tb.dut.clkinb_binary_2 rsync_latch_tb.dut.clkinb_binary_1 rsync_latch_tb.dut.clkinb_binary_0_red rsync_latch_tb.dut.clkinb_binary_0 rsync_latch_tb.dut.clkin_therm_16 rsync_latch_tb.dut.clkin_therm_15 rsync_latch_tb.dut.clkin_therm_14 rsync_latch_tb.dut.clkin_therm_13 rsync_latch_tb.dut.clkin_therm_12 rsync_latch_tb.dut.clkin_therm_11 rsync_latch_tb.dut.clkin_therm_10 rsync_latch_tb.dut.clkin_therm_9 rsync_latch_tb.dut.clkin_therm_8 rsync_latch_tb.dut.clkin_therm_7 rsync_latch_tb.dut.clkin_therm_6 rsync_latch_tb.dut.clkin_therm_5 rsync_latch_tb.dut.clkin_therm_4 rsync_latch_tb.dut.clkin_therm_3 rsync_latch_tb.dut.clkin_therm_2 rsync_latch_tb.dut.clkin_therm_1 rsync_latch_tb.dut.clkin_therm_0 rsync_latch_tb.dut.clkin_binary_5 rsync_latch_tb.dut.clkin_binary_4 rsync_latch_tb.dut.clkin_binary_3 rsync_latch_tb.dut.clkin_binary_2 rsync_latch_tb.dut.clkin_binary_1 rsync_latch_tb.dut.clkin_binary_0_red rsync_latch_tb.dut.clkin_binary_0 rsync_latch_tb.dut.atb_ena rsync_latch_tb.dut.atb1 rsync_latch_tb.dut.atb0
probe -create -database waves rsync_latch_tb.dut.vssana rsync_latch_tb.dut.vddana_0p8 rsync_latch_tb.dut.pdb rsync_latch_tb.dut.iref_25ua rsync_latch_tb.dut.dataoutthermb rsync_latch_tb.dut.dataouttherm rsync_latch_tb.dut.dataoutbinb rsync_latch_tb.dut.dataoutbin rsync_latch_tb.dut.datainthermb rsync_latch_tb.dut.dataintherm rsync_latch_tb.dut.datainbinb rsync_latch_tb.dut.datainbin rsync_latch_tb.dut.clkinb_therm_16 rsync_latch_tb.dut.clkinb_therm_15 rsync_latch_tb.dut.clkinb_therm_14 rsync_latch_tb.dut.clkinb_therm_13 rsync_latch_tb.dut.clkinb_therm_12 rsync_latch_tb.dut.clkinb_therm_11 rsync_latch_tb.dut.clkinb_therm_10 rsync_latch_tb.dut.clkinb_therm_9 rsync_latch_tb.dut.clkinb_therm_8 rsync_latch_tb.dut.clkinb_therm_7 rsync_latch_tb.dut.clkinb_therm_6 rsync_latch_tb.dut.clkinb_therm_5 rsync_latch_tb.dut.clkinb_therm_4 rsync_latch_tb.dut.clkinb_therm_3 rsync_latch_tb.dut.clkinb_therm_2 rsync_latch_tb.dut.clkinb_therm_1 rsync_latch_tb.dut.clkinb_therm_0 rsync_latch_tb.dut.clkinb_binary_5 rsync_latch_tb.dut.clkinb_binary_4 rsync_latch_tb.dut.clkinb_binary_3 rsync_latch_tb.dut.clkinb_binary_2 rsync_latch_tb.dut.clkinb_binary_1 rsync_latch_tb.dut.clkinb_binary_0_red rsync_latch_tb.dut.clkinb_binary_0 rsync_latch_tb.dut.clkin_therm_16 rsync_latch_tb.dut.clkin_therm_15 rsync_latch_tb.dut.clkin_therm_14 rsync_latch_tb.dut.clkin_therm_13 rsync_latch_tb.dut.clkin_therm_12 rsync_latch_tb.dut.clkin_therm_11 rsync_latch_tb.dut.clkin_therm_10 rsync_latch_tb.dut.clkin_therm_9 rsync_latch_tb.dut.clkin_therm_8 rsync_latch_tb.dut.clkin_therm_7 rsync_latch_tb.dut.clkin_therm_6 rsync_latch_tb.dut.clkin_therm_5 rsync_latch_tb.dut.clkin_therm_4 rsync_latch_tb.dut.clkin_therm_3 rsync_latch_tb.dut.clkin_therm_2 rsync_latch_tb.dut.clkin_therm_1 rsync_latch_tb.dut.clkin_therm_0 rsync_latch_tb.dut.clkin_binary_5 rsync_latch_tb.dut.clkin_binary_4 rsync_latch_tb.dut.clkin_binary_3 rsync_latch_tb.dut.clkin_binary_2 rsync_latch_tb.dut.clkin_binary_1 rsync_latch_tb.dut.clkin_binary_0_red rsync_latch_tb.dut.clkin_binary_0 rsync_latch_tb.dut.atb_ena rsync_latch_tb.dut.atb1 rsync_latch_tb.dut.atb0

simvision -input /home/msegper/Documents/TFM/rsync_latch/.simvision/2919246_msegper__autosave.tcl.svcf
