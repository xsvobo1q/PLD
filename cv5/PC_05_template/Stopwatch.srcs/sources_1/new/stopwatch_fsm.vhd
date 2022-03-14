----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2022 09:33:11 AM
-- Design Name: 
-- Module Name: debouncer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY stopwatch_fsm IS
  PORT(
    clk           : IN STD_LOGIC;
    st_sp         : IN STD_LOGIC  := '0';
    lap_clr       : IN STD_LOGIC  := '0';
    cnt_reset     : OUT STD_LOGIC := '0';
    cnt_enable    : OUT STD_LOGIC := '0';
    disp_enable   : OUT STD_LOGIC := '0'
  );
END stopwatch_fsm;

ARCHITECTURE Behavioral OF stopwatch_fsm IS

  TYPE t_state IS (st_idle, st_run, st_lap, st_refresh, st_stop);
  SIGNAL pres_state : t_state := st_idle;
  SIGNAL next_state : t_state;
  SIGNAL st_out     : STD_LOGIC_VECTOR (2 DOWNTO 0);

BEGIN

  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      pres_state  <= next_state;
      
      cnt_reset   <= st_out(2);
      cnt_enable  <= st_out(1);
      disp_enable <= st_out(0);
    END IF;
  END PROCESS;

  PROCESS (st_sp, lap_clr, pres_state) BEGIN
    CASE pres_state IS
    
      WHEN st_idle =>
        IF st_sp = '1' THEN
          next_state <= st_run;
        ELSE
          next_state <= st_idle;
        END IF;
      
      WHEN st_run =>
        IF st_sp = '1' THEN
          next_state <= st_stop;
        ELSIF st_sp = '0' AND lap_clr = '1' THEN
          next_state <= st_lap;
        ELSE
          next_state <= st_run;
        END IF;
        
      WHEN st_lap =>
        IF st_sp = '1' THEN
          next_state <= st_run;
        ELSIF st_sp = '0' AND lap_clr = '1' THEN
          next_state <= st_refresh;
        ELSE
          next_state <= st_lap;
        END IF;
        
      WHEN st_refresh =>
        next_state <= st_lap;
        
      WHEN st_stop =>
        IF st_sp = '1' THEN
          next_state <= st_run;
        ELSIF st_sp = '0' AND lap_clr = '1' THEN
          next_state <= st_idle;
        ELSE
          next_state <= st_stop;
        END IF;
        
      WHEN OTHERS => 
        next_state <= st_idle;     -- default state
      
    END CASE;
  END PROCESS;
  
  PROCESS (pres_state) BEGIN
    CASE pres_state IS
      WHEN st_idle    => st_out <= "101";
      WHEN st_run     => st_out <= "011";
      WHEN st_lap     => st_out <= "010";
      WHEN st_refresh => st_out <= "011";
      WHEN st_stop    => st_out <= "001";
    END CASE;  
  END PROCESS;

END Behavioral;




