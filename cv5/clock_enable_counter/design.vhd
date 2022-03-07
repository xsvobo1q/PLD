--------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--------------------------------------------------------
ENTITY ce_gen IS
  
  GENERIC(
    CONSTANT DIV_FACT  :  POSITIVE
  );
  
  PORT(
    clk   :  IN STD_LOGIC;
    ce_o  :  OUT STD_LOGIC := '0'
  );
END ENTITY ce_gen;
--------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
  SIGNAL cnt_sig  :  POSITIVE RANGE 1 TO DIV_FACT + 1 := 1;
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      cnt_sig <= cnt_sig + 1;
      IF cnt_sig = DIV_FACT THEN
        ce_o <= '1';
        cnt_sig <= 1;
      ELSE
        ce_o <= '0';
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE Behavioral;
--------------------------------------------------------