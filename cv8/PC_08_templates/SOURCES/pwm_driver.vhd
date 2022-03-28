----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
----------------------------------------------------------------------------------
ENTITY pwm_driver IS
  PORT (
    CLK                 : IN  STD_LOGIC;
    PWM_REF_7           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_6           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_5           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_4           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_3           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_2           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_1           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_0           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    CNT_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END pwm_driver;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm_driver IS
----------------------------------------------------------------------------------
SIGNAL cnt : STD_LOGIC_VECTOR (7 DOWNTO 0) := X"01";
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
counter : PROCESS (clk) BEGIN
  IF rising_edge(clk) THEN
  
    IF cnt = X"FF" THEN
      cnt <= X"01";
    ELSE
      cnt <= STD_LOGIC_VECTOR(UNSIGNED(cnt) + 1);
    END IF;
    CNT_OUT <= cnt;
    
  END IF;
END PROCESS counter;


pwm_drivers : PROCESS (clk) BEGIN
  IF rising_edge(clk) THEN
  
    PWM_OUT <= (OTHERS => '0'); 
    IF cnt <= PWM_REF_0 THEN PWM_OUT(0) <= '1'; END IF;
    IF cnt <= PWM_REF_1 THEN PWM_OUT(1) <= '1'; END IF;
    IF cnt <= PWM_REF_2 THEN PWM_OUT(2) <= '1'; END IF;
    IF cnt <= PWM_REF_3 THEN PWM_OUT(3) <= '1'; END IF;
    IF cnt <= PWM_REF_4 THEN PWM_OUT(4) <= '1'; END IF;
    IF cnt <= PWM_REF_5 THEN PWM_OUT(5) <= '1'; END IF;
    IF cnt <= PWM_REF_6 THEN PWM_OUT(6) <= '1'; END IF;
    IF cnt <= PWM_REF_7 THEN PWM_OUT(7) <= '1'; END IF;
 
  END IF;
END PROCESS pwm_drivers;
----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
