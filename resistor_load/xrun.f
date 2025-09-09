-clean                      // Deletes previous INCA_lins direcory, if it exists 
./models/resistor_load.sv           // original digital vco
./tb/resistor_load_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/resistor_load/restore.tcl // Restore the simulation state
 