-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE Behavioral OF testbench IS
  COMPONENT stopwatch_fsm
    PORT(
      clk           : IN STD_LOGIC;
      st_sp         : IN STD_LOGIC;
      lap_clr       : IN STD_LOGIC;
      cnt_reset     : OUT STD_LOGIC;
      cnt_enable    : OUT STD_LOGIC;
      disp_enable   : OUT STD_LOGIC
    );
  END COMPONENT stopwatch_fsm;
  
  CONSTANT clk_period : TIME := 2000 ns;
  SIGNAL simul_finished : BOOLEAN := FALSE;
  
  SIGNAL clk : STD_LOGIC;
  SIGNAL st_sp_sig       : STD_LOGIC := '0';
  SIGNAL lap_clr_sig     : STD_LOGIC := '0';
  SIGNAL cnt_reset_sig   : STD_LOGIC := '0';
  SIGNAL cnt_enable_sig  : STD_LOGIC := '0';
  SIGNAL disp_enable_sig : STD_LOGIC := '0';
  
BEGIN

  PROCESS BEGIN
    clk <= '0'; WAIT FOR clk_period/2;
    clk <= '1'; WAIT FOR clk_period/2;
    IF simul_finished THEN
      WAIT;
    END IF;
  END PROCESS;
  
  stopwatch_fsm_i : stopwatch_fsm
  PORT MAP(
    clk         => clk,
    st_sp       => st_sp_sig,
    lap_clr     => lap_clr_sig,
    cnt_reset   => cnt_reset_sig,
    cnt_enable  => cnt_enable_sig,
    disp_enable => disp_enable_sig
  );
  
  proc_stim : PROCESS
  BEGIN
  
  WAIT FOR clk_period*2;
  st_sp_sig <= '1';
  WAIT FOR clk_period;
  st_sp_sig <= '0';
  WAIT FOR clk_period*2;
  lap_clr_sig <= '1';
  WAIT FOR clk_period;
  lap_clr_sig <= '0';
  WAIT FOR clk_period*5;
  lap_clr_sig <= '1';
  WAIT FOR clk_period;
  lap_clr_sig <= '0';
  WAIT FOR clk_period*2;
  st_sp_sig <= '1';
  WAIT FOR clk_period;
  st_sp_sig <= '0';
  WAIT FOR clk_period*2;
  st_sp_sig <= '1';
  WAIT FOR clk_period;
  st_sp_sig <= '0';
  WAIT FOR clk_period*2;
  lap_clr_sig <= '1';
  WAIT FOR clk_period;
  lap_clr_sig <= '0';
  
  WAIT FOR clk_period * 15;
  simul_finished <= TRUE;
  
  WAIT;
  END PROCESS;


END Behavioral;