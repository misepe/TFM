-clean                      // Deletes previous INCA_lins direcory, if it exists 
//./eda/cadence/2024-25/RHELx86/XCELIUM_24.03.004/tools.lnx86/affirma_ams/etc/dms/cds_rnm_pkg.sv
//./models/currentSourceUnits.sv           // original digital vco
./models/currentSourceUnits_mismatch.sv           // original digital vco
//./models/currentSourceUnits_noise.sv           // original digital vco
./tb/currentSourceUnits_tb.sv             // Testbench
-access +rw                 // Turn on read/write object access 
//-gui                        // Performs simulation in graphical mode
-s -input /home/msegper/Documents/TFM/current_source_units/restore.tcl // Restore the simulation state
 