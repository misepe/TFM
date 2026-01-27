-clean                      // Deletes previous INCA_lins direcory, if it exists 
-access +rw                 // Turn on read/write object access 
//-gui                        // Performs simulation in graphical mode
//-input restore.tcl

+define+DEBUG_DISPLAY

-incdir ../clock_distribution
-incdir ../current_source_units
-incdir ../current_sterring
-incdir ../driver_cell
-incdir ../level_shifter
-incdir ../local_bias
-incdir ../resistor_load
-incdir ../rsync_latch

../clock_distribution/models/clock_distribution_jitter.sv
../current_source_units/models/currentSourceUnits.sv
../current_sterring/models/current_sterring.sv
../driver_cell/models/driver_cell_jitter.sv
../level_shifter/models/level_shifter.sv
../local_bias/models/local_bias.sv
../resistor_load/models/resistor_load.sv
../rsync_latch/models/rsync_latch_jitter.sv

//./thermometer_decoder.sv
./top_level_schematic.sv 
./tb_dac_top.sv


+SVSEED=0


