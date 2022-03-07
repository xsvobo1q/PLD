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
    clk     :  IN STD_LOGIC;
    srst    :  IN STD_LOGIC;
    ce_in   :  IN STD_LOGIC;
    ce_out  :  OUT STD_LOGIC := '0'
  );
END ENTITY ce_gen;
--------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
  SIGNAL cnt_sig  :  POSITIVE RANGE 1 TO DIV_FACT + 1 := 1;
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF srst = '1' THEN
        cnt_sig <= 1;
        ce_out <= '0';
      ELSE
        IF ce_in = '1' THEN
          cnt_sig <= cnt_sig + 1;
          IF cnt_sig = DIV_FACT THEN
            ce_out <= '1';
            cnt_sig <= 1;
          ELSE
            ce_out <= '0';
          END IF;
        ELSE
          ce_out <= '0';
          cnt_sig <= 1;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE Behavioral;
--------------------------------------------------------