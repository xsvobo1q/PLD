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
    wd_time : OUT STD_LOGIC := '0'
  );
END watchdog;

ARCHITECTURE Behavioral OF watchdog IS

  SIGNAL cnt_sig  :  POSITIVE RANGE 1 TO 400 := 1;

BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      
      IF wd_en = '0' THEN
        cnt_sig <= 1;
        wd_time <= '0';
      ELSIF ce = '1' AND wd_en = '1' THEN
      
        cnt_sig <= cnt_sig + 1;
        
        IF cnt_sig >= 101 THEN
          wd_time <= '1';
        ELSIF cnt_sig >= 301 THEN
          wd_time <= '0';
          cnt_sig <= 1;
        END IF;
        
      END IF;
    END IF;
  END PROCESS;

END Behavioral;
