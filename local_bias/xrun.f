-clean                      // Deletes previous INCA_lins direcory, if it exists 
./models/local_bias.sv           // original digital vco
./tb/local_bias_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/local_bias/restore.tcl // Restore the simulation state
 