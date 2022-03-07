--------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--------------------------------------------------------
ENTITY ce_gen_tb IS
END ENTITY ce_gen_tb;
--------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen_tb IS
  COMPONENT ce_gen
  GENERIC(
    CONSTANT DIV_FACT  :  POSITIVE
  );
  PORT(
    clk    :  IN STD_LOGIC;
    ce_o   :  OUT STD_LOGIC
  );
  END COMPONENT ce_gen;
  
  SIGNAL clk_sig   :  STD_LOGIC;
  SIGNAL ce_o_sig  :  STD_LOGIC;
  
BEGIN
  ce_gen_i : ce_gen
  
  GENERIC MAP(
    DIV_FACT => 5
  )
  
  PORT MAP(
    clk    => clk_sig,
    ce_o   => ce_o_sig
  );
  
  PROCESS
  BEGIN
    
    FOR i IN 0 TO 100 LOOP
      clk_sig <= '1';
      WAIT FOR 5 ns;
      clk_sig <= '0';
      WAIT FOR 5 ns;
    END LOOP;
    
    WAIT;
    
  END PROCESS;
  
END ARCHITECTURE Behavioral;
--------------------------------------------------------