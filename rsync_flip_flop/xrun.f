-clean                      // Deletes previous INCA_lins direcory, if it exists 
//./models/rsync_flip_flop.sv           // original digital vco
//./models/rsync_flip_flop_mismatch.sv           // original digital vco
//./models/rsync_flip_flop_jitter.sv           // original digital vco
./models/rsync_flip_flop_all_non_linearities.sv           // original digital vco
./tb/rsync_flip_flop_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/rsync_flip_flop/restore.tcl // Restore the simulation state
 