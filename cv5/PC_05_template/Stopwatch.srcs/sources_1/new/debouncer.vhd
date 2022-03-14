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

ENTITY debouncer IS
  GENERIC(
    DEB_PERIOD  : POSITIVE
  );
  PORT(
    clk     : IN STD_LOGIC;
    btn     : IN STD_LOGIC;
    clk_en  : IN STD_LOGIC;
    btn_deb : OUT STD_LOGIC
  );
END debouncer;

ARCHITECTURE Behavioral OF debouncer IS

  SIGNAL deb_cnt  : POSITIVE := 1;
  SIGNAL deb_cnt_en : BOOLEAN := FALSE;
  
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF clk_en = '1' THEN   
        IF btn = '1' THEN 
          deb_cnt_en <= TRUE;
        END IF;
      
        IF deb_cnt_en THEN
          deb_cnt <= deb_cnt + 1;
          btn_deb <= '1';
        ELSE
          deb_cnt <= 1;
          btn_deb <= '0';
        END IF;
      
        IF deb_cnt > DEB_PERIOD THEN
          IF btn = '1' THEN
            deb_cnt <= 1;
            btn_deb <= '1';
          ELSE
            deb_cnt <= 1;
            deb_cnt_en <= FALSE;
            btn_deb <= '0';
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

END Behavioral;
