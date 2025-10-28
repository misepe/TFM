
# XM-Sim Command File
# TOOL:	xmsim(64)	24.03-s004
#
#
# You can restore this configuration with:
#
#      xrun -f xrun.f -input restore.tcl
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
probe -create -database waves clock_distribution_tb.dut.atb0 clock_distribution_tb.dut.atb1 clock_distribution_tb.dut.atb_ena clock_distribution_tb.dut.clkin clock_distribution_tb.dut.clkinb clock_distribution_tb.dut.clkout_binary_0 clock_distribution_tb.dut.clkout_binary_0_red clock_distribution_tb.dut.clkout_binary_1 clock_distribution_tb.dut.clkout_binary_2 clock_distribution_tb.dut.clkout_binary_3 clock_distribution_tb.dut.clkout_binary_4 clock_distribution_tb.dut.clkout_binary_5 clock_distribution_tb.dut.clkout_therm_0 clock_distribution_tb.dut.clkout_therm_1 clock_distribution_tb.dut.clkout_therm_2 clock_distribution_tb.dut.clkout_therm_3 clock_distribution_tb.dut.clkout_therm_4 clock_distribution_tb.dut.clkout_therm_5 clock_distribution_tb.dut.clkout_therm_6 clock_distribution_tb.dut.clkout_therm_7 clock_distribution_tb.dut.clkout_therm_8 clock_distribution_tb.dut.clkout_therm_9 clock_distribution_tb.dut.clkout_therm_10 clock_distribution_tb.dut.clkout_therm_11 clock_distribution_tb.dut.clkout_therm_12 clock_distribution_tb.dut.clkout_therm_13 clock_distribution_tb.dut.clkout_therm_14 clock_distribution_tb.dut.clkout_therm_15 clock_distribution_tb.dut.clkout_therm_16 clock_distribution_tb.dut.clkoutb_binary_0 clock_distribution_tb.dut.clkoutb_binary_0_red clock_distribution_tb.dut.clkoutb_binary_1 clock_distribution_tb.dut.clkoutb_binary_2 clock_distribution_tb.dut.clkoutb_binary_3 clock_distribution_tb.dut.clkoutb_binary_4 clock_distribution_tb.dut.clkoutb_binary_5 clock_distribution_tb.dut.clkoutb_therm_0 clock_distribution_tb.dut.clkoutb_therm_1 clock_distribution_tb.dut.clkoutb_therm_2 clock_distribution_tb.dut.clkoutb_therm_3 clock_distribution_tb.dut.clkoutb_therm_4 clock_distribution_tb.dut.clkoutb_therm_5 clock_distribution_tb.dut.clkoutb_therm_6 clock_distribution_tb.dut.clkoutb_therm_7 clock_distribution_tb.dut.clkoutb_therm_8 clock_distribution_tb.dut.clkoutb_therm_9 clock_distribution_tb.dut.clkoutb_therm_10 clock_distribution_tb.dut.clkoutb_therm_11 clock_distribution_tb.dut.clkoutb_therm_12 clock_distribution_tb.dut.clkoutb_therm_13 clock_distribution_tb.dut.clkoutb_therm_14 clock_distribution_tb.dut.clkoutb_therm_15 clock_distribution_tb.dut.clkoutb_therm_16 clock_distribution_tb.dut.iref_25ua clock_distribution_tb.dut.pdb clock_distribution_tb.dut.vddana_0p8 clock_distribution_tb.dut.vssana

simvision -input restore.tcl.svcf
