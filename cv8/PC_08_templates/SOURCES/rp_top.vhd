----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    clk             : IN  STD_LOGIC;
    btn_i           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    sw_i            : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    led_o           : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_seg_o      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT(
    clk                 : IN  STD_LOGIC;
    dig_1_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_2_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_3_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_4_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dp_i                : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    dots_i              : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    disp_seg_o          : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o          : OUT STD_LOGIC_VECTOR (4 DOWNTO 0));
  END COMPONENT;

  ------------------------------------------------------------------------------

  COMPONENT btn_in
  GENERIC(
    DEB_PERIOD          : INTEGER := 10);
  PORT(
    clk                 : IN  STD_LOGIC;
    ce                  : IN  STD_LOGIC;
    btn_i               : IN  STD_LOGIC;
    btn_deb_o           : OUT STD_LOGIC;
    btn_posedge_o       : OUT STD_LOGIC;
    btn_negedge_o       : OUT STD_LOGIC;
    btn_edge_o          : OUT STD_LOGIC);
  END COMPONENT;

  --------------------------------------------------------------------------------

  COMPONENT ce_gen
  GENERIC(
    DIV_FACT            : POSITIVE := 2);
  PORT (
    clk                 : IN  STD_LOGIC;
    srst                : IN  STD_LOGIC;
    ce                  : IN  STD_LOGIC;
    ce_o                : OUT STD_LOGIC);
  END COMPONENT;
  
  -------------------------------------------------------------------------------------
  
  COMPONENT pwm_driver
  PORT(
    CLK                 : IN  STD_LOGIC;
    PWM_REF_7           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_6           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_5           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_4           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_3           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_2           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_1           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_0           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    CNT_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
  END COMPONENT pwm_driver;
  
  ---------------------------------------------------------------------------
  
  COMPONENT vio_pwm
  PORT (
    clk         : IN STD_LOGIC;
    probe_in0   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_in1   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out0  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out1  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out2  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out3  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out4  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out5  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out6  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out7  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out8  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    probe_out9  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    probe_out10 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    probe_out11 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END COMPONENT;

---------------------------------------------------------------------------------

COMPONENT ila_pwm

PORT (
	clk : IN STD_LOGIC;
	probe0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	probe1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	probe2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	probe3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END COMPONENT  ;

  --------------------------------------------------------------------------------

  SIGNAL clk_en_100Hz       : STD_LOGIC;

  SIGNAL btn_deb_o          : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_posedge_o      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_negedge_o      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_edge_o         : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL PWM_OUT_s          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL CNT_OUT_s          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  
  SIGNAL PWM_REF_7          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL PWM_REF_6          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL PWM_REF_5          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL PWM_REF_4          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL PWM_REF_3          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL PWM_REF_2          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL PWM_REF_1          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL PWM_REF_0          : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  
  SIGNAL DIG_1_s            : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL DIG_2_s            : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL DIG_3_s            : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL DIG_4_s            : STD_LOGIC_VECTOR( 3 DOWNTO 0);

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  ce_gen_i : ce_gen
  GENERIC MAP(
    DIV_FACT            => 500000)
  PORT MAP(
    clk                 => clk,
    srst                => '0',
    ce                  => '1',
    ce_o                => clk_en_100Hz);

  --------------------------------------------------------------------------------

  GEN_btn_in: FOR i IN 0 TO 3 GENERATE
    btn_in_i : btn_in
    GENERIC MAP(
      DEB_PERIOD          => 5)
    PORT MAP(
      clk                 => clk,
      ce                  => clk_en_100Hz,
      btn_i               => btn_i(i),
      btn_deb_o           => btn_deb_o(i),
      btn_posedge_o       => btn_posedge_o(i),
      btn_negedge_o       => btn_negedge_o(i),
      btn_edge_o          => btn_edge_o(i));
  END GENERATE GEN_btn_in;

  --------------------------------------------------------------------------------
  --
  --       DIG 1       DIG 2       DIG 3       DIG 4
  --                                       L3
  --       -----       -----       -----   o   -----
  --      |     |     |     |  L1 |     |     |     |
  --      |     |     |     |  o  |     |     |     |
  --       -----       -----       -----       -----
  --      |     |     |     |  o  |     |     |     |
  --      |     |     |     |  L2 |     |     |     |
  --       -----  o    -----  o    -----  o    -----  o
  --             DP1         DP2         DP3         DP4
  --
  --------------------------------------------------------------------------------

  seg_disp_driver_i : seg_disp_driver
  PORT MAP(
    clk                 => clk,
    dig_1_i             => DIG_1_s,
    dig_2_i             => DIG_2_s,
    dig_3_i             => DIG_3_s,
    dig_4_i             => DIG_4_s,
    dp_i                => "0000",
    dots_i              => "011",
    disp_seg_o          => disp_seg_o,
    disp_dig_o          => disp_dig_o);

  --------------------------------------------------------------------------------
  
  pwm_driver_i : pwm_driver
  PORT MAP(
    CLK                 => clk,
    PWM_REF_7           => PWM_REF_7,
    PWM_REF_6           => PWM_REF_6,
    PWM_REF_5           => PWM_REF_5,
    PWM_REF_4           => PWM_REF_4,
    PWM_REF_3           => PWM_REF_3,
    PWM_REF_2           => PWM_REF_2,
    PWM_REF_1           => PWM_REF_1,
    PWM_REF_0           => PWM_REF_0,
    PWM_OUT             => PWM_OUT_s,
    CNT_OUT             => CNT_OUT_s
  );
  
  -------------------------------------------------------------------------------
  
  vio_pwm_i : vio_pwm
  PORT MAP (
    clk         => clk,
    probe_in0   => PWM_OUT_s,
    probe_in1   => CNT_OUT_s,
    probe_out0  => PWM_REF_0,
    probe_out1  => PWM_REF_1,
    probe_out2  => PWM_REF_2,
    probe_out3  => PWM_REF_3,
    probe_out4  => PWM_REF_4,
    probe_out5  => PWM_REF_5,
    probe_out6  => PWM_REF_6,
    probe_out7  => PWM_REF_7,
    probe_out8  => DIG_1_s,
    probe_out9  => DIG_2_s,
    probe_out10 => DIG_3_s,
    probe_out11 => DIG_4_s
  );
  
  --------------------------------------------------------------------------------
  
  ila_pwm_i : ila_pwm
PORT MAP (
	clk => clk,
	probe0 => PWM_OUT_s,
	probe1 => CNT_OUT_s,
	probe2 => btn_i,
	probe3 => sw_i
);

led_o <= PWM_OUT_s;

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
