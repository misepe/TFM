-clean                      // Deletes previous INCA_lins direcory, if it exists 
//./models/rsync_latch.sv           // original digital vco
//./models/rsync_latch_mismatch.sv           // original digital vco
./models/rsync_latch_jitter.sv           // original digital vco
./tb/rsync_latch_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/rsync_latch/restore.tcl // Restore the simulation state
 