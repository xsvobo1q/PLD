----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
----------------------------------------------------------------------------------
ENTITY UART_Tx_block IS
  PORT(
    clk                 : IN  STD_LOGIC;
    UART_Tx_start       : IN  STD_LOGIC;
    UART_clk_EN         : IN  STD_LOGIC;
    UART_Data_in        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    UART_Tx_busy        : OUT STD_LOGIC;
    UART_Tx_Data_out    : OUT STD_LOGIC := '1'
  );
END UART_Tx_block;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF UART_Tx_block IS
----------------------------------------------------------------------------------

SIGNAL UART_data_reg    : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
SIGNAL UART_Tx_busy_sig : BOOLEAN := FALSE;
SIGNAL Tx_enable        : BOOLEAN := FALSE;
SIGNAL bit_cnt          : NATURAL := 0;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  PROCESS (clk) 
  BEGIN
    IF rising_edge(clk) THEN
    
      IF (UART_Tx_start = '1' AND NOT(UART_Tx_busy_sig)) THEN
        UART_data_reg <= '1' & UART_Data_in & '0';
        UART_Tx_busy <= '1';
        UART_Tx_busy_sig <= TRUE;
        Tx_enable <= TRUE;
      END IF;
    
      IF (UART_clk_EN = '1') THEN
      
        IF Tx_enable THEN
          UART_Tx_Data_out <= UART_data_reg(bit_cnt);
          bit_cnt <= bit_cnt + 1;
          
          IF bit_cnt >= 9 THEN
            Tx_enable <= FALSE;
            UART_Tx_busy_sig <= FALSE;
            bit_cnt <= 0;
            UART_Tx_busy <= '0'; 
          END IF;
          
        END IF;
        
      END IF;
    END IF;
  END PROCESS;
----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
