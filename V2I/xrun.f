-clean                      // Deletes previous INCA_lins direcory, if it exists 
./models/v2i.sv           // original digital vco
./tb/v2i_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/V2I/restore.tcl // Restore the simulation state
