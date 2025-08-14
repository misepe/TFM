-clean                      // Deletes previous INCA_lins direcory, if it exists 
./models/currentSourceUnits.sv           // original digital vco
./tb/currentSourceUnits_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/current_source_units/restore.tcl // Restore the simulation state
 