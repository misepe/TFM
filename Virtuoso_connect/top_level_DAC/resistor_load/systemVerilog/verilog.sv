//systemVerilog HDL for "top_level_DAC", "resistor_load" "systemVerilog"


module resistor_load (
    input  Iin, // Input current coming from the switching pairs (analog current)
    input Iinb, // Input current coming from the switching pairs (analog current)
    input vssana, // Ground connection for the block (ground)
    output  vout, // Output voltage (analog voltage)
    output  voutb // Output voltage (analog voltage)
    );
  
endmodule