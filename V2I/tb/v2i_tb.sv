module tb;
    // Señales wreal
    real vin_tb;
    real iout_tb;

    // Instancia del DUT
    v2i #(.R(500.0),.I_MIN(-10.0e-3),.I_MAX(10.0e-3),.V_MIN(-5.0),.V_MAX(5.0)) dut (
        .VIN(vin_tb),
        .IOUT(iout_tb)
    );

    //Señales temporales
    real vin_temp;
    real step;

    initial begin
        vin_tb = -4.0; //Valor inicial y final del barrido
        vin_temp = vin_tb;
        step = 0.1;
        repeat (80) begin
            #10;
            vin_tb = vin_temp + step;
            vin_temp = vin_tb;
        end
        repeat (10) #10;
        repeat (80) begin
            #10;
            vin_tb = vin_temp - step;
            vin_temp = vin_tb;
        end

        vin_tb = -6.0; // Valor fuera de rango
        vin_temp = vin_tb;
        repeat (120) begin
            #10;
            vin_tb = vin_temp + step;
            vin_temp = vin_tb;
        end
        repeat (120) begin
            #10;
            vin_tb = vin_temp - step;
            vin_temp = vin_tb;
        end
        $finish;
    end
endmodule
