----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2022 09:43:37 AM
-- Design Name: 
-- Module Name: watchdog - Behavioral
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


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY watchdog IS
  PORT (
    clk     : IN STD_LOGIC;
    ce      : IN STD_LOGIC;
    wd_en   : IN STD_LOGIC;
    wd_rst  : IN STD_LOGIC;
    wd_time : OUT STD_LOGIC := '0'
  );
END watchdog;

ARCHITECTURE Behavioral OF watchdog IS

  SIGNAL cnt_sig  :  POSITIVE RANGE 1 TO 1501 := 1;
  SIGNAL led_timing : STD_LOGIC := '0';

BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
    
      IF wd_rst = '1' THEN
        cnt_sig <= 1;
      END IF;
    
      IF ce = '1' THEN
        IF wd_en = '1' THEN
          cnt_sig <= cnt_sig + 1;
          IF cnt_sig >= 100 THEN
            wd_time <= '1';
            led_timing <= '1';
          END IF;
        ELSE
          IF led_timing = '1' THEN
            cnt_sig <= cnt_sig + 1;
            IF cnt_sig >= 300 THEN
              cnt_sig <= 1;
              wd_time <= '0';
              led_timing <= '0';
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

END Behavioral;
