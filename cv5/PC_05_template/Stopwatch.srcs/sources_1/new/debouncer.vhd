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
    DEB_PERIOD  : POSITIVE := 3
  );
  PORT(
    clk     : IN STD_LOGIC;
    btn     : IN STD_LOGIC;
    clk_en  : IN STD_LOGIC;
    btn_deb : OUT STD_LOGIC
  );
END debouncer;

ARCHITECTURE Behavioral OF debouncer IS
  SIGNAL deb_cnt : POSITIVE := 1;
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      btn_deb <= '0';
      IF (clk_en = '1' AND deb_cnt = DEB_PERIOD) THEN
        btn_deb <= btn;
        deb_cnt <= 1;
      ELSE
        deb_cnt <= deb_cnt + 1;
      END IF;
    END IF;
  END PROCESS;

END Behavioral;
