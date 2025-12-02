// Library - top_level_DAC, Cell - top_level_schematic, View -
//schematic
// LAST TIME SAVED: Dec  2 16:35:43 2025
// NETLIST TIME: Dec  2 16:45:47 2025
`timescale 1ns / 1ps 

//Falta conectar bien el level_shifter

module top_level_schematic ( Ical, Iout, Ioutb, atb, Vcas, atb_ena,
     atest_ena, clkin, clkinb, dataical, datainbin, datainbinb,
     dataintherm, datainthermb, pdb, vddana_0p8, vddana_1p8, vssana );

output  Ical, Iout, Ioutb;

input  Vcas, atb_ena, atest_ena, clkin, clkinb, dataical, datainbin,
     datainbinb, dataintherm, datainthermb, pdb, vddana_0p8,
     vddana_1p8, vssana;

output [0:9]  atb;

// Buses in the design

wire  [0:6]  net3;

wire  [0:6]  net4;

wire  [0:6]  net37;

wire  [0:6]  net36;

wire  [0:16]  net35;

wire  [0:16]  net34;

wire  [0:16]  net1;

wire  [0:16]  net2;


specify 
    specparam CDS_LIBNAME  = "top_level_DAC";
    specparam CDS_CELLNAME = "top_level_schematic";
    specparam CDS_VIEWNAME = "schematic";
endspecify

currentSourceUnits CurrentSourceUnits_inst ( .Iout_binary_0(net32),
     .Iout_binary_0_red(net31), .Iout_binary_1(net30),
     .Iout_binary_2(net29), .Iout_binary_3(net28),
     .Iout_binary_4(net27), .Iout_binary_5(net26), .Iout_them_0(net25),
     .Iout_them_1(net24), .Iout_them_2(net23), .Iout_them_3(net22),
     .Iout_them_4(net21), .Iout_them_5(net20), .Iout_them_6(net19),
     .Iout_them_7(net18), .Iout_them_8(net17), .Iout_them_9(net16),
     .Iout_them_10(net15), .Iout_them_11(net14), .Iout_them_12(net13),
     .Iout_them_13(net12), .Iout_them_14(net11), .Iout_them_15(net10),
     .Iout_them_16(net9), .atb0(atb[0]), .atb1(atb[1]),
     .atb_ena({atb_ena, atb_ena}), .iref_500ua(net38), .pdb(pdb),
     .vddana_0p8(vddana_0p8), .vddana_1p8(vddana_1p8),
     .vssana(vssana));
currentSterring currentSterring_inst ( .Ical(Ical), .Iout(Iout),
     .Ioutb(Ioutb), .atb0(atb[8]), .atb1(atb[9]),
     .Iout_binary_0(net32), .Iout_binary_0_red(net31),
     .Iout_binary_1(net30), .Iout_binary_2(net29),
     .Iout_binary_3(net28), .Iout_binary_4(net27),
     .Iout_binary_5(net26), .Iout_them_0(net25), .Iout_them_1(net24),
     .Iout_them_2(net23), .Iout_them_3(net22), .Iout_them_4(net21),
     .Iout_them_5(net20), .Iout_them_6(net19), .Iout_them_7(net18),
     .Iout_them_8(net17), .Iout_them_9(net16), .Iout_them_10(net15),
     .Iout_them_11(net14), .Iout_them_12(net13), .Iout_them_13(net12),
     .Iout_them_14(net11), .Iout_them_15(net10), .Iout_them_16(net9),
     .Vcas(Vcas), .atb_ena({atb_ena, atb_ena}), .atest_ena(atest_ena),
     .dataical({dataical, dataical, dataical, dataical, dataical}),
     .datain(net37[0:6]), .datainb(net36[0:6]),
     .datatherm(net35[0:16]), .datathermb(net34[0:16]),
     .iref_500ua(net53), .pdb(pdb), .vddana_0p8(vddana_0p8),
     .vddana_1p8(vddana_1p8), .vssana(vssana));
local_bias local_bias_inst ( .atb0(atb[2]), .atb1(atb[3]),
     .iclkdist_25ua(net83), .icurrentsource_500ua(net38),
     .icurrentsterring_500ua(net53), .isynclatch_25ua(net33),
     .atb_ena({atb_ena, atb_ena}), .pdb(pdb), .vddana_0p8(vddana_0p8),
     .vddana_1p8(vddana_1p8), .vssana(vssana));
driver_cell driver_cell_inst ( .datain(net3[0:6]), .datainb(net4[0:6]),
     .databinout(net37[0:6]), .datathermout(net35[0:16]),
     .datathermoutb(net34[0:16]), .databinoutb(net36[0:6]),
     .datatherm(net2[0:16]), .datathermb(net1[0:16]), .pdb(pdb),
     .vddana_0p8(vddana_0p8), .vddana_1p8(vddana_1p8),
     .vssana(vssana));
rsync_latch rsync_latch_inst ( .atb0(atb[6]), .atb1(atb[7]),
     .dataoutbin(net3[0:6]), .dataoutbinb(net4[0:6]),
     .dataouttherm(net2[0:16]), .dataoutthermb(net1[0:16]),
     .atb_ena({atb_ena, atb_ena}), .clkin_binary_0(net102),
     .clkin_binary_0_red(net101), .clkin_binary_1(net100),
     .clkin_binary_2(net99), .clkin_binary_3(net98),
     .clkin_binary_4(net134), .clkin_binary_5(net133),
     .clkin_therm_0(net132), .clkin_therm_1(net131),
     .clkin_therm_2(net130), .clkin_therm_3(net129),
     .clkin_therm_4(net128), .clkin_therm_5(net127),
     .clkin_therm_6(net126), .clkin_therm_7(net125),
     .clkin_therm_8(net124), .clkin_therm_9(net123),
     .clkin_therm_10(net122), .clkin_therm_11(net121),
     .clkin_therm_12(net120), .clkin_therm_13(net119),
     .clkin_therm_14(net118), .clkin_therm_15(net117),
     .clkin_therm_16(net116), .clkinb_binary_0(net115),
     .clkinb_binary_0_red(net114), .clkinb_binary_1(net113),
     .clkinb_binary_2(net112), .clkinb_binary_3(net111),
     .clkinb_binary_4(net110), .clkinb_binary_5(net160),
     .clkinb_therm_0(net159), .clkinb_therm_1(net158),
     .clkinb_therm_2(net157), .clkinb_therm_3(net156),
     .clkinb_therm_4(net155), .clkinb_therm_5(net154),
     .clkinb_therm_6(net153), .clkinb_therm_7(net152),
     .clkinb_therm_8(net151), .clkinb_therm_9(net150),
     .clkinb_therm_10(net149), .clkinb_therm_11(net148),
     .clkinb_therm_12(net147), .clkinb_therm_13(net146),
     .clkinb_therm_14(net145), .clkinb_therm_15(net144),
     .clkinb_therm_16(net143), .datainbin({datainbin, datainbin,
     datainbin, datainbin, datainbin, datainbin, datainbin}),
     .datainbinb({datainbinb, datainbinb, datainbinb, datainbinb,
     datainbinb, datainbinb, datainbinb}), .dataintherm({dataintherm,
     dataintherm, dataintherm, dataintherm, dataintherm, dataintherm,
     dataintherm, dataintherm, dataintherm, dataintherm, dataintherm,
     dataintherm, dataintherm, dataintherm, dataintherm, dataintherm,
     dataintherm}), .datainthermb({datainthermb, datainthermb,
     datainthermb, datainthermb, datainthermb, datainthermb,
     datainthermb, datainthermb, datainthermb, datainthermb,
     datainthermb, datainthermb, datainthermb, datainthermb,
     datainthermb, datainthermb, datainthermb}), .iref_25ua(net33),
     .pdb(pdb), .vddana_0p8(vddana_0p8), .vssana(vssana));
clock_distribution clock_distribution_inst ( .atb0(atb[4]),
     .atb1(atb[5]), .clkout_binary_0(net102),
     .clkout_binary_0_red(net101), .clkout_binary_1(net100),
     .clkout_binary_2(net99), .clkout_binary_3(net98),
     .clkout_binary_4(net134), .clkout_binary_5(net133),
     .clkout_therm_0(net132), .clkout_therm_1(net131),
     .clkout_therm_2(net130), .clkout_therm_3(net129),
     .clkout_therm_4(net128), .clkout_therm_5(net127),
     .clkout_therm_6(net126), .clkout_therm_7(net125),
     .clkout_therm_8(net124), .clkout_therm_9(net123),
     .clkout_therm_10(net122), .clkout_therm_11(net121),
     .clkout_therm_12(net120), .clkout_therm_13(net119),
     .clkout_therm_14(net118), .clkout_therm_15(net117),
     .clkout_therm_16(net116), .clkoutb_binary_0(net115),
     .clkoutb_binary_0_red(net114), .clkoutb_binary_1(net113),
     .clkoutb_binary_2(net112), .clkoutb_binary_3(net111),
     .clkoutb_binary_4(net110), .clkoutb_binary_5(net160),
     .clkoutb_therm_0(net159), .clkoutb_therm_1(net158),
     .clkoutb_therm_2(net157), .clkoutb_therm_3(net156),
     .clkoutb_therm_4(net155), .clkoutb_therm_5(net154),
     .clkoutb_therm_6(net153), .clkoutb_therm_7(net152),
     .clkoutb_therm_8(net151), .clkoutb_therm_9(net150),
     .clkoutb_therm_10(net149), .clkoutb_therm_11(net148),
     .clkoutb_therm_12(net147), .clkoutb_therm_13(net146),
     .clkoutb_therm_14(net145), .clkoutb_therm_15(net144),
     .clkoutb_therm_16(net143), .atb_ena({atb_ena, atb_ena}),
     .clkin(clkin), .clkinb(clkinb), .iref_25ua(net83), .pdb(pdb),
     .vddana_0p8(vddana_0p8), .vssana(vssana));

endmodule
