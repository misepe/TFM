-clean                      // Deletes previous INCA_lins direcory, if it exists 
//./models/driver_cell.sv           // original digital vco
//./models/driver_cell_mismatch.sv           // original digital vco
//./models/driver_cell_jitter.sv           // original digital vco
./models/driver_cell_all_non_linearities.sv           // original digital vco
./tb/driver_cell_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/driver_cell/restore.tcl // Restore the simulation state
 