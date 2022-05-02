----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2022 09:20:51 AM
-- Design Name: 
-- Module Name: sync_reg - Behavioral
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

ENTITY sync_reg IS
  PORT(
    clk     : IN STD_LOGIC;
    sig_in  : IN STD_LOGIC;
    sig_out : OUT STD_LOGIC
  );
END sync_reg;

ARCHITECTURE Behavioral OF sync_reg IS

  SIGNAL  sig_reg  :  STD_LOGIC := '0';
  
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of sig_reg : signal is "TRUE";
  attribute ASYNC_REG of sig_out : signal is "TRUE";
  
  attribute SHREG_EXTRACT : string;
  attribute SHREG_EXTRACT of sig_reg : signal is "NO";
  attribute SHREG_EXTRACT of sig_out : signal is "NO";

BEGIN

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      sig_reg <= sig_in;
      sig_out <= sig_reg;
    END IF;
  END PROCESS;

END Behavioral;
