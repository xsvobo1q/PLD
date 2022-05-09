----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2022 08:29:59 AM
-- Design Name: 
-- Module Name: LFSR - Behavioral
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

ENTITY LFSR IS
  GENERIC(
    tap_1   : INTEGER := 16;
    tap_2   : INTEGER := 10
  );
  PORT( 
    clk       : IN STD_LOGIC;
    en        : IN STD_LOGIC;
    rst       : IN STD_LOGIC;
    dout      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
    state_reg : OUT STD_LOGIC_VECTOR (tap_1 DOWNTO 1)
  );
END LFSR;

ARCHITECTURE Behavioral OF LFSR IS

  SIGNAL state_reg_s : STD_LOGIC_VECTOR (tap_1 DOWNTO 1) := (OTHERS => '1');
  SIGNAL feedback    : STD_LOGIC;

BEGIN

PROCESS (clk) BEGIN
  IF rising_edge(clk) THEN
    IF en = '1' THEN
      state_reg_s <= state_reg_s(state_reg_s'HIGH-1 DOWNTO 1) & feedback;
    END IF;
    
    IF rst = '1' THEN
      state_reg_s <= X"00FF";
    END IF;
  END IF;
END PROCESS;

feedback <= state_reg_s(tap_1) XOR state_reg_s(tap_2);

PROCESS (clk) BEGIN
  IF rising_edge(clk) THEN
    dout <= state_reg_s(5) & state_reg_s(12) & state_reg_s(10) & state_reg_s(11) & state_reg_s(1) & state_reg_s(6) & state_reg_s(8) & state_reg_s(7);
    state_reg <= state_reg_s;
  END IF;
END PROCESS;

END Behavioral;
