----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2022 08:52:48 AM
-- Design Name: 
-- Module Name: cnt_bin - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY cnt_bin is
    PORT (
      clk       : IN STD_LOGIC;
      ce        : IN STD_LOGIC;
      srst      : IN STD_LOGIC;
      cnt_load  : IN STD_LOGIC;
      cnt_up    : IN STD_LOGIC;
      cnt       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END cnt_bin;

ARCHITECTURE Behavioral OF cnt_bin IS
  SIGNAL cnt_sig  :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN

  PROCESS (clk) 
  BEGIN
  
    IF rising_edge(clk) THEN
      IF srst = '1' THEN 
        cnt_sig <= (OTHERS => '0');
      ELSIF ce = '1' THEN
        IF cnt_load = '1' THEN
          cnt_sig <= X"55555555";
        ELSE
          IF cnt_up = '1' THEN
            cnt_sig <= STD_LOGIC_VECTOR(UNSIGNED(cnt_sig) + 1);
          ELSE 
            cnt_sig <= STD_LOGIC_VECTOR(UNSIGNED(cnt_sig) - 1);
          END IF;
        END IF;   
      END IF;
    END IF;
    
  END PROCESS;
  
  cnt <= cnt_sig;
  
END ARCHITECTURE Behavioral;
