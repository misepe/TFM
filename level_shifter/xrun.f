-clean                      // Deletes previous INCA_lins direcory, if it exists 
./models/level_shifter.sv           // original digital vco
./tb/level_shifter_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/level_shifter/restore.tcl // Restore the simulation state
 