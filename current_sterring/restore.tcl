
# XM-Sim Command File
# TOOL:	xmsim(64)	24.03-s004
#
#
# You can restore this configuration with:
#
#      xrun -f xrun.f -input /home/msegper/Documents/TFM/current_sterring/restore.tcl
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
probe -create -database waves currentSterring_tb.dut.Ical currentSterring_tb.dut.Iout currentSterring_tb.dut.Iout_binary_0 currentSterring_tb.dut.Iout_binary_0_red currentSterring_tb.dut.Iout_binary_1 currentSterring_tb.dut.Iout_binary_2 currentSterring_tb.dut.Iout_binary_3 currentSterring_tb.dut.Iout_binary_4 currentSterring_tb.dut.Iout_binary_5 currentSterring_tb.dut.Iout_them_0 currentSterring_tb.dut.Iout_them_1 currentSterring_tb.dut.Iout_them_2 currentSterring_tb.dut.Iout_them_3 currentSterring_tb.dut.Iout_them_4 currentSterring_tb.dut.Iout_them_5 currentSterring_tb.dut.Iout_them_6 currentSterring_tb.dut.Iout_them_7 currentSterring_tb.dut.Iout_them_8 currentSterring_tb.dut.Iout_them_9 currentSterring_tb.dut.Iout_them_10 currentSterring_tb.dut.Iout_them_11 currentSterring_tb.dut.Iout_them_12 currentSterring_tb.dut.Iout_them_13 currentSterring_tb.dut.Iout_them_14 currentSterring_tb.dut.Iout_them_15 currentSterring_tb.dut.Iout_them_16 currentSterring_tb.dut.Ioutb currentSterring_tb.dut.Vcas currentSterring_tb.dut.atb0 currentSterring_tb.dut.atb1 currentSterring_tb.dut.atb_ena currentSterring_tb.dut.atest_ena currentSterring_tb.dut.dataical currentSterring_tb.dut.datain currentSterring_tb.dut.datainb currentSterring_tb.dut.datatherm currentSterring_tb.dut.datathermb currentSterring_tb.dut.iref_500ua currentSterring_tb.dut.pdb currentSterring_tb.dut.vddana_0p8 currentSterring_tb.dut.vddana_1p8 currentSterring_tb.dut.vssana
probe -create -database waves currentSterring_tb.dut.enable_funcionality currentSterring_tb.dut.input_check

simvision -input restore.tcl.svcf
