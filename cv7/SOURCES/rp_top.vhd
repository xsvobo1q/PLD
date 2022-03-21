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
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    uart_txd_out    : OUT STD_LOGIC
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------
  
  COMPONENT ce_gen
  GENERIC(
    DIV_FACT        : POSITIVE := 20 
  );
  PORT(
    clk     :  IN STD_LOGIC;
    srst    :  IN STD_LOGIC;
    ce   :  IN STD_LOGIC;
    ce_o  :  OUT STD_LOGIC := '0'            
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
  
  COMPONENT UART_Tx_block
  PORT(
    clk                 : IN  STD_LOGIC;
    UART_Tx_start       : IN  STD_LOGIC;
    UART_clk_EN         : IN  STD_LOGIC;
    UART_Data_in        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    UART_Tx_busy        : OUT STD_LOGIC;
    UART_Tx_Data_out    : OUT STD_LOGIC := '1'
  );
  END COMPONENT UART_Tx_block;
 
  ------------------------------------------------------------------------------

  SIGNAL clk_en             : STD_LOGIC;
  SIGNAL clk_100Hz          : STD_LOGIC;
  SIGNAL btn_debounced      : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
  SIGNAL btn_edge_pos       : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
  SIGNAL btn_edge_neg       : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
  SIGNAL btn_edge_any       : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
  SIGNAL UART_Data_in_sig   : STD_LOGIC_VECTOR (7 DOWNTO 0) := "01000000";

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- clock enable generator
  ce_gen_1 : ce_gen
  GENERIC MAP(
    DIV_FACT  =>  434
  )
  PORT MAP(
    clk    => clk,
    srst   => '0',
    ce  => '1',
    ce_o => clk_en
  );
  
    ce_gen_2 : ce_gen
  GENERIC MAP(
    DIV_FACT  =>  500000
  )
  PORT MAP(
    clk    => clk,
    srst   => '0',
    ce  => '1',
    ce_o => clk_100Hz
  );
  
  --------------------------------------------------------------------------------
  -- button input module
  gen_btn_in: FOR i IN 0 TO 3 GENERATE
    btn_in_inst : btn_in
    GENERIC MAP(
      DEB_PERIOD => 10
    )
    PORT MAP(
      clk           => clk,
      ce            => clk_100Hz,
      btn           => btn_i(i),
      btn_debounced => btn_debounced(i),
      btn_edge_pos  => btn_edge_pos(i),
      btn_edge_neg  => btn_edge_neg(i),
      btn_edge_any  => btn_edge_any(i)
    );
  END GENERATE gen_btn_in;

  --------------------------------------------------------------------------------
  -- UART Tx block
  UART_Tx_block_i : UART_Tx_block
  PORT MAP(
    clk               => clk,
    UART_Tx_start     => btn_edge_pos(0),
    UART_clk_EN       => clk_en,
    UART_Data_in      => UART_Data_in_sig,
    UART_Tx_busy      => led_o(4),
    UART_Tx_Data_out  => uart_txd_out
  );
  
  UART_Data_in_sig(0) <= sw_i(0);
  UART_Data_in_sig(1) <= sw_i(1);
  UART_Data_in_sig(2) <= sw_i(2);
  UART_Data_in_sig(3) <= sw_i(3);
  

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
