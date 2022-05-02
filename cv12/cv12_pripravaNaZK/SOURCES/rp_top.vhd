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
  
  COMPONENT ce_gen
  GENERIC(
    DIV_FACT        : POSITIVE := 500000 
  );
  PORT(
    clk     :  IN STD_LOGIC;
    srst    :  IN STD_LOGIC;
    ce_in   :  IN STD_LOGIC;
    ce_out  :  OUT STD_LOGIC := '0'            
  );
  END COMPONENT ce_gen;
  
  COMPONENT btn_in
  GENERIC(
    DEB_PERIOD                  : POSITIVE := 5
  );
  PORT(
    clk                         : IN  STD_LOGIC;
    ce                          : IN  STD_LOGIC;
    btn                         : IN  STD_LOGIC;
    btn_debounced               : OUT STD_LOGIC := '0';
    btn_edge_pos                : OUT STD_LOGIC := '0';
    btn_edge_neg                : OUT STD_LOGIC := '0';
    btn_edge_any                : OUT STD_LOGIC := '0'
  );
  END COMPONENT btn_in;
  
  COMPONENT key_fsm
    PORT (
      btn_1      : IN STD_LOGIC;
      btn_2      : IN STD_LOGIC;
      btn_3      : IN STD_LOGIC;
      btn_4      : IN STD_LOGIC;
      state_rst  : IN STD_LOGIC;
      clk        : IN STD_LOGIC;
      state_out  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
      wd_en      : OUT STD_LOGIC := '0'
    );
  END COMPONENT key_fsm;
  
  COMPONENT watchdog
    PORT(
      clk     : IN STD_LOGIC;
      ce      : IN STD_LOGIC;
      wd_en   : IN STD_LOGIC;
      wd_time : OUT STD_LOGIC := '0'
    );
  END COMPONENT watchdog;

  ------------------------------------------------------------------------------

  SIGNAL ce_100Hz           : STD_LOGIC;
  SIGNAL wd_time_sig        : STD_LOGIC;
  SIGNAL wd_rst             : STD_LOGIC;
  SIGNAL btn_debounced      : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
  SIGNAL btn_edge_pos       : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
  SIGNAL btn_edge_neg       : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
  SIGNAL btn_edge_any       : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  -- clock enable generator
  ce_gen_i : ce_gen
  GENERIC MAP(
    DIV_FACT  =>  500000
  )
  PORT MAP(
    clk    => clk,
    srst   => '0',
    ce_in  => '1',
    ce_out => ce_100Hz
  );
  
  --------------------------------------------------------------------------------
  -- button input module
  gen_btn_in: FOR i IN 0 TO 3 GENERATE
    btn_in_inst : btn_in
    GENERIC MAP(
      DEB_PERIOD => 5
    )
    PORT MAP(
      clk => clk,
      ce => ce_100Hz,
      btn => btn_i(i),
      btn_debounced => btn_debounced(i),
      btn_edge_pos => btn_edge_pos(i),
      btn_edge_neg => btn_edge_neg(i),
      btn_edge_any => btn_edge_any(i)
    );
  END GENERATE gen_btn_in;
  
  --------------------------------------------------------------------------------
  -- FSM
  key_fsm_i : key_fsm
    PORT MAP(
      btn_1      => btn_edge_pos(0),
      btn_2      => btn_edge_pos(1),    
      btn_3      => btn_edge_pos(2),    
      btn_4      => btn_edge_pos(3),   
      state_rst  => wd_time_sig, 
      clk        => clk,
      state_out  => led_o,
      wd_en      => wd_rst
    );
    
    watchdog_i : watchdog
      PORT MAP(
        clk     => clk,
        ce      => ce_100Hz,
        wd_en   => wd_rst,
        wd_time => wd_time_sig
      );
      
    led_o <= "0000000" & wd_time_sig;  
----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
