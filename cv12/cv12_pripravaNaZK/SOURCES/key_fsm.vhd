----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2022 08:39:09 AM
-- Design Name: 
-- Module Name: key_fsm - Behavioral
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

ENTITY key_fsm IS
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
END key_fsm;

ARCHITECTURE Behavioral OF key_fsm IS
  
  TYPE t_state IS (st0, st1, st2, st3, st4, st5, st6, st7, st8);
  SIGNAL pres_state     : t_state := st0;
  SIGNAL next_state     : t_state;
  SIGNAL state_ind      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  
BEGIN

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      
      IF pres_state = st8 THEN
        state_out <= "1111" & state_ind;
      ELSE
        state_out <= "0000" & state_ind;
      END IF;
      
      IF state_rst = '1' THEN
        next_state <= st0;
      ELSE
        pres_state <= next_state;
      END IF;
      
      IF pres_state = next_state AND (pres_state /= st0 OR pres_state /= st8) THEN
        wd_en <= '1';
      ELSE
        wd_en <= '0';
      END IF;
      
    END IF;
  END PROCESS;
  
  PROCESS (btn_1, btn_2, btn_3, btn_4, pres_state)
  BEGIN
    
    wd_en <= '1';
    
    CASE pres_state IS
    
      WHEN st0 =>
        state_ind <= "0000";
        wd_en <= '0';
        IF btn_1 = '1' THEN
          next_state <= st1;
        ELSIF btn_2 = '1' OR btn_3 = '1' OR btn_4 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st0;
        END IF;
      
      WHEN st1 =>
        state_ind <= "0001";
        IF btn_2 = '1' THEN
          next_state <= st2;
        ELSIF btn_1 = '1' OR btn_3 = '1' OR btn_4 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st1;
        END IF;
      
      WHEN st2 =>
        state_ind <= "0010";
        IF btn_3 = '1' THEN
          next_state <= st3;
        ELSIF btn_2 = '1' OR btn_1 = '1' OR btn_4 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st2;
        END IF;
      
      WHEN st3 =>
        state_ind <= "0011";
        IF btn_4 = '1' THEN
          next_state <= st4;
        ELSIF btn_2 = '1' OR btn_3 = '1' OR btn_1 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st3;
        END IF;
      
      WHEN st4 =>
        state_ind <= "0100";
        IF btn_4 = '1' THEN
          next_state <= st5;
        ELSIF btn_2 = '1' OR btn_3 = '1' OR btn_1 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st4;
        END IF;
      
      WHEN st5 =>
        state_ind <= "0101";
        IF btn_3 = '1' THEN
          next_state <= st6;
        ELSIF btn_2 = '1' OR btn_1 = '1' OR btn_4 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st5;
        END IF;
      
      WHEN st6 =>
        state_ind <= "0110";
        IF btn_2 = '1' THEN
          next_state <= st7;
        ELSIF btn_1 = '1' OR btn_3 = '1' OR btn_4 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st6;
        END IF;
      
      WHEN st7 =>
        state_ind <= "0111";
        IF btn_1 = '1' THEN
          next_state <= st8;
        ELSIF btn_2 = '1' OR btn_3 = '1' OR btn_4 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st7;
        END IF;
      
      WHEN st8 =>
        wd_en <= '0';
        state_ind <= "1000";
        IF btn_1 = '1' OR btn_2 = '1' OR btn_3 = '1' OR btn_4 = '1' THEN
          next_state <= st0;
        ELSE 
          next_state <= st8;
        END IF;
      
    END CASE;
  END PROCESS;
END Behavioral;




