-clean                      // Deletes previous INCA_lins direcory, if it exists 
./models/clock_distribution.sv           // original digital vco
./tb/clock_distribution_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/clock_distribution/restore.tcl // Restore the simulation state
 