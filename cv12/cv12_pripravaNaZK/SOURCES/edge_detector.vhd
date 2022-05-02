----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2022 10:07:41 AM
-- Design Name: 
-- Module Name: edge_detector - Behavioral
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

ENTITY edge_detector IS
  PORT(
    clk       : IN STD_LOGIC;
    sig_in    : IN STD_LOGIC;
    edge_pos  : OUT STD_LOGIC;
    edge_neg  : OUT STD_LOGIC;
    edge_any  : OUT STD_LOGIC
  );
END edge_detector;

ARCHITECTURE Behavioral OF edge_detector IS
  SIGNAL prev_btn : STD_LOGIC := '0'; 
BEGIN

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      edge_pos <= '0';
      edge_neg <= '0';
      edge_any <= '0';
      prev_btn <= sig_in;
      IF (prev_btn = '0' AND sig_in = '1') THEN
        edge_pos <= '1';
        edge_any <= '1';
      ELSIF (prev_btn = '1' AND sig_in = '0') THEN
      edge_neg <= '1';
      edge_any <= '1';
      END IF;
    END IF;
  END PROCESS;

end Behavioral;
