module gw_gao(
    \CPU/Reg/rf[2][15] ,
    \CPU/Reg/rf[2][14] ,
    \CPU/Reg/rf[2][13] ,
    \CPU/Reg/rf[2][12] ,
    \CPU/Reg/rf[2][11] ,
    \CPU/Reg/rf[2][10] ,
    \CPU/Reg/rf[2][9] ,
    \CPU/Reg/rf[2][8] ,
    \CPU/Reg/rf[2][7] ,
    \CPU/Reg/rf[2][6] ,
    \CPU/Reg/rf[2][5] ,
    \CPU/Reg/rf[2][4] ,
    \CPU/Reg/rf[2][3] ,
    \CPU/Reg/rf[2][2] ,
    \CPU/Reg/rf[2][1] ,
    \CPU/Reg/rf[2][0] ,
    \CPU/Reg/rf[1][15] ,
    \CPU/Reg/rf[1][14] ,
    \CPU/Reg/rf[1][13] ,
    \CPU/Reg/rf[1][12] ,
    \CPU/Reg/rf[1][11] ,
    \CPU/Reg/rf[1][10] ,
    \CPU/Reg/rf[1][9] ,
    \CPU/Reg/rf[1][8] ,
    \CPU/Reg/rf[1][7] ,
    \CPU/Reg/rf[1][6] ,
    \CPU/Reg/rf[1][5] ,
    \CPU/Reg/rf[1][4] ,
    \CPU/Reg/rf[1][3] ,
    \CPU/Reg/rf[1][2] ,
    \CPU/Reg/rf[1][1] ,
    \CPU/Reg/rf[1][0] ,
    \CPU/Reg/rs[2] ,
    \CPU/Reg/rs[1] ,
    \CPU/Reg/rs[0] ,
    \CPU/Reg/RS[15] ,
    \CPU/Reg/RS[14] ,
    \CPU/Reg/RS[13] ,
    \CPU/Reg/RS[12] ,
    \CPU/Reg/RS[11] ,
    \CPU/Reg/RS[10] ,
    \CPU/Reg/RS[9] ,
    \CPU/Reg/RS[8] ,
    \CPU/Reg/RS[7] ,
    \CPU/Reg/RS[6] ,
    \CPU/Reg/RS[5] ,
    \CPU/Reg/RS[4] ,
    \CPU/Reg/RS[3] ,
    \CPU/Reg/RS[2] ,
    \CPU/Reg/RS[1] ,
    \CPU/Reg/RS[0] ,
    \CPU/Reg/rs_forward ,
    \led[3] ,
    \led[2] ,
    \led[1] ,
    \led[0] ,
    \BUS/ctrl ,
    \CPU/Reg/RegWe ,
    clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \CPU/Reg/rf[2][15] ;
input \CPU/Reg/rf[2][14] ;
input \CPU/Reg/rf[2][13] ;
input \CPU/Reg/rf[2][12] ;
input \CPU/Reg/rf[2][11] ;
input \CPU/Reg/rf[2][10] ;
input \CPU/Reg/rf[2][9] ;
input \CPU/Reg/rf[2][8] ;
input \CPU/Reg/rf[2][7] ;
input \CPU/Reg/rf[2][6] ;
input \CPU/Reg/rf[2][5] ;
input \CPU/Reg/rf[2][4] ;
input \CPU/Reg/rf[2][3] ;
input \CPU/Reg/rf[2][2] ;
input \CPU/Reg/rf[2][1] ;
input \CPU/Reg/rf[2][0] ;
input \CPU/Reg/rf[1][15] ;
input \CPU/Reg/rf[1][14] ;
input \CPU/Reg/rf[1][13] ;
input \CPU/Reg/rf[1][12] ;
input \CPU/Reg/rf[1][11] ;
input \CPU/Reg/rf[1][10] ;
input \CPU/Reg/rf[1][9] ;
input \CPU/Reg/rf[1][8] ;
input \CPU/Reg/rf[1][7] ;
input \CPU/Reg/rf[1][6] ;
input \CPU/Reg/rf[1][5] ;
input \CPU/Reg/rf[1][4] ;
input \CPU/Reg/rf[1][3] ;
input \CPU/Reg/rf[1][2] ;
input \CPU/Reg/rf[1][1] ;
input \CPU/Reg/rf[1][0] ;
input \CPU/Reg/rs[2] ;
input \CPU/Reg/rs[1] ;
input \CPU/Reg/rs[0] ;
input \CPU/Reg/RS[15] ;
input \CPU/Reg/RS[14] ;
input \CPU/Reg/RS[13] ;
input \CPU/Reg/RS[12] ;
input \CPU/Reg/RS[11] ;
input \CPU/Reg/RS[10] ;
input \CPU/Reg/RS[9] ;
input \CPU/Reg/RS[8] ;
input \CPU/Reg/RS[7] ;
input \CPU/Reg/RS[6] ;
input \CPU/Reg/RS[5] ;
input \CPU/Reg/RS[4] ;
input \CPU/Reg/RS[3] ;
input \CPU/Reg/RS[2] ;
input \CPU/Reg/RS[1] ;
input \CPU/Reg/RS[0] ;
input \CPU/Reg/rs_forward ;
input \led[3] ;
input \led[2] ;
input \led[1] ;
input \led[0] ;
input \BUS/ctrl ;
input \CPU/Reg/RegWe ;
input clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \CPU/Reg/rf[2][15] ;
wire \CPU/Reg/rf[2][14] ;
wire \CPU/Reg/rf[2][13] ;
wire \CPU/Reg/rf[2][12] ;
wire \CPU/Reg/rf[2][11] ;
wire \CPU/Reg/rf[2][10] ;
wire \CPU/Reg/rf[2][9] ;
wire \CPU/Reg/rf[2][8] ;
wire \CPU/Reg/rf[2][7] ;
wire \CPU/Reg/rf[2][6] ;
wire \CPU/Reg/rf[2][5] ;
wire \CPU/Reg/rf[2][4] ;
wire \CPU/Reg/rf[2][3] ;
wire \CPU/Reg/rf[2][2] ;
wire \CPU/Reg/rf[2][1] ;
wire \CPU/Reg/rf[2][0] ;
wire \CPU/Reg/rf[1][15] ;
wire \CPU/Reg/rf[1][14] ;
wire \CPU/Reg/rf[1][13] ;
wire \CPU/Reg/rf[1][12] ;
wire \CPU/Reg/rf[1][11] ;
wire \CPU/Reg/rf[1][10] ;
wire \CPU/Reg/rf[1][9] ;
wire \CPU/Reg/rf[1][8] ;
wire \CPU/Reg/rf[1][7] ;
wire \CPU/Reg/rf[1][6] ;
wire \CPU/Reg/rf[1][5] ;
wire \CPU/Reg/rf[1][4] ;
wire \CPU/Reg/rf[1][3] ;
wire \CPU/Reg/rf[1][2] ;
wire \CPU/Reg/rf[1][1] ;
wire \CPU/Reg/rf[1][0] ;
wire \CPU/Reg/rs[2] ;
wire \CPU/Reg/rs[1] ;
wire \CPU/Reg/rs[0] ;
wire \CPU/Reg/RS[15] ;
wire \CPU/Reg/RS[14] ;
wire \CPU/Reg/RS[13] ;
wire \CPU/Reg/RS[12] ;
wire \CPU/Reg/RS[11] ;
wire \CPU/Reg/RS[10] ;
wire \CPU/Reg/RS[9] ;
wire \CPU/Reg/RS[8] ;
wire \CPU/Reg/RS[7] ;
wire \CPU/Reg/RS[6] ;
wire \CPU/Reg/RS[5] ;
wire \CPU/Reg/RS[4] ;
wire \CPU/Reg/RS[3] ;
wire \CPU/Reg/RS[2] ;
wire \CPU/Reg/RS[1] ;
wire \CPU/Reg/RS[0] ;
wire \CPU/Reg/rs_forward ;
wire \led[3] ;
wire \led[2] ;
wire \led[1] ;
wire \led[0] ;
wire \BUS/ctrl ;
wire \CPU/Reg/RegWe ;
wire clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i(\BUS/ctrl ),
    .trig1_i(\CPU/Reg/RegWe ),
    .data_i({\CPU/Reg/rf[2][15] ,\CPU/Reg/rf[2][14] ,\CPU/Reg/rf[2][13] ,\CPU/Reg/rf[2][12] ,\CPU/Reg/rf[2][11] ,\CPU/Reg/rf[2][10] ,\CPU/Reg/rf[2][9] ,\CPU/Reg/rf[2][8] ,\CPU/Reg/rf[2][7] ,\CPU/Reg/rf[2][6] ,\CPU/Reg/rf[2][5] ,\CPU/Reg/rf[2][4] ,\CPU/Reg/rf[2][3] ,\CPU/Reg/rf[2][2] ,\CPU/Reg/rf[2][1] ,\CPU/Reg/rf[2][0] ,\CPU/Reg/rf[1][15] ,\CPU/Reg/rf[1][14] ,\CPU/Reg/rf[1][13] ,\CPU/Reg/rf[1][12] ,\CPU/Reg/rf[1][11] ,\CPU/Reg/rf[1][10] ,\CPU/Reg/rf[1][9] ,\CPU/Reg/rf[1][8] ,\CPU/Reg/rf[1][7] ,\CPU/Reg/rf[1][6] ,\CPU/Reg/rf[1][5] ,\CPU/Reg/rf[1][4] ,\CPU/Reg/rf[1][3] ,\CPU/Reg/rf[1][2] ,\CPU/Reg/rf[1][1] ,\CPU/Reg/rf[1][0] ,\CPU/Reg/rs[2] ,\CPU/Reg/rs[1] ,\CPU/Reg/rs[0] ,\CPU/Reg/RS[15] ,\CPU/Reg/RS[14] ,\CPU/Reg/RS[13] ,\CPU/Reg/RS[12] ,\CPU/Reg/RS[11] ,\CPU/Reg/RS[10] ,\CPU/Reg/RS[9] ,\CPU/Reg/RS[8] ,\CPU/Reg/RS[7] ,\CPU/Reg/RS[6] ,\CPU/Reg/RS[5] ,\CPU/Reg/RS[4] ,\CPU/Reg/RS[3] ,\CPU/Reg/RS[2] ,\CPU/Reg/RS[1] ,\CPU/Reg/RS[0] ,\CPU/Reg/rs_forward ,\led[3] ,\led[2] ,\led[1] ,\led[0] }),
    .clk_i(clk)
);

endmodule
