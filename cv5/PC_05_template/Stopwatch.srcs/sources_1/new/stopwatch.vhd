-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

ENTITY stopwatch IS
  PORT(
    clk            : IN STD_LOGIC;
    cnt_reset      : IN STD_LOGIC;
    cnt_enable     : IN STD_LOGIC;
    ce_100Hz       : IN STD_LOGIC;
    disp_enable    : IN STD_LOGIC;
    cnt_0          : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    cnt_1          : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    cnt_2          : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    cnt_3          : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0')
  );
END stopwatch;

ARCHITECTURE Behavioral OF stopwatch IS

  SIGNAL cnt_0_sig  :  STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_1_sig  :  STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_2_sig  :  STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_3_sig  :  STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');

BEGIN

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF cnt_reset = '1' THEN
        cnt_0_sig <= (OTHERS => '0');
        cnt_1_sig <= (OTHERS => '0');
        cnt_2_sig <= (OTHERS => '0');
        cnt_3_sig <= (OTHERS => '0');
      END IF;
      
      IF disp_enable = '1' THEN
        cnt_0 <= cnt_0_sig;
        cnt_1 <= cnt_1_sig;
        cnt_2 <= cnt_2_sig;
        cnt_3 <= cnt_3_sig;
      END IF;
      
      IF ce_100Hz = '1' THEN
        IF cnt_enable = '1' THEN
          cnt_0_sig <= STD_LOGIC_VECTOR(UNSIGNED(cnt_0_sig) + 1);
        END IF;
        
        IF cnt_0_sig = "1001" THEN
          cnt_0_sig <= (OTHERS => '0');
          cnt_1_sig <= STD_LOGIC_VECTOR(UNSIGNED(cnt_1_sig) + 1);
        ELSIF cnt_1_sig = "1001" THEN
          cnt_1_sig <= (OTHERS => '0');
          cnt_2_sig <= STD_LOGIC_VECTOR(UNSIGNED(cnt_2_sig) + 1);
        ELSIF cnt_2_sig = "1001" THEN
          cnt_2_sig <= (OTHERS => '0');
          cnt_3_sig <= STD_LOGIC_VECTOR(UNSIGNED(cnt_3_sig) + 1);
        ELSIF cnt_3_sig = "0101" THEN
          cnt_0_sig <= (OTHERS => '0');
          cnt_1_sig <= (OTHERS => '0');
          cnt_2_sig <= (OTHERS => '0');
          cnt_3_sig <= (OTHERS => '0');
        END IF;   
      END IF;
    END IF;
  END PROCESS;

END Behavioral;