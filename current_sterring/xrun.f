-clean                      // Deletes previous INCA_lins direcory, if it exists 
./models/current_sterring.sv           // original digital vco
//./models/current_sterring_noise.sv           // original digital vco
./tb/current_sterring_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/current_sterring/restore.tcl // Restore the simulation state
 