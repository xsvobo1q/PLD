----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2022 08:53:56 AM
-- Design Name: 
-- Module Name: LFSR_tb - Behavioral
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
USE std.textio.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY LFSR_tb IS

END LFSR_tb;

ARCHITECTURE Behavioral OF LFSR_tb IS

  COMPONENT LFSR
    GENERIC(
      tap_1   : INTEGER := 16;
      tap_2   : INTEGER := 10
    );
    PORT(
      clk       : IN STD_LOGIC;
      en        : IN STD_LOGIC;
      rst       : IN STD_LOGIC;
      dout      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      state_reg : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
  END COMPONENT LFSR;
  
  CONSTANT clk_period           : TIME := 20 ns;
  SIGNAL simulation_finished    : BOOLEAN := FALSE; 
  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL en                     : STD_LOGIC := '0';
  SIGNAL rst                    : STD_LOGIC := '1';
  SIGNAL dout                   : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL state_reg              : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL state_reg_help         : STD_LOGIC_VECTOR (15 DOWNTO 0) := x"00ff";
  SIGNAL state_cnt              : INTEGER := 0;

BEGIN

PROCESS BEGIN
  clk <= '0'; WAIT FOR clk_period/2;
  clk <= '1'; WAIT FOR clk_period/2;
  IF simulation_finished THEN
    WAIT;
  END IF;
END PROCESS;

LFSR_i : LFSR
  GENERIC MAP(
    tap_1 => 16,
    tap_2 => 10
  )
  PORT MAP(
    clk         => clk,
    en          => en,
    rst         => rst,
    dout        => dout,
    state_reg   => state_reg
  );
  
  stimulous : PROCESS
  
    VARIABLE  line_out  : LINE;
  
  BEGIN
 --   WAIT FOR clk_period*5;
 --   en <= '1';
 --   WAIT FOR clk_period*10;
 --   en <= '0';
 --   WAIT FOR clk_period*5;
 --   rst <= '1';
 --   WAIT FOR clk_period;
 --   rst <= '0';
 --   WAIT FOR clk_period*2;
    rst <= '1';
    WAIT FOR clk_period;
    rst <= '0';
    en <= '1';
    WAIT FOR clk_period*2;
    
    WHILE NOT(simulation_finished) LOOP
        state_cnt <= state_cnt + 1;
        IF state_reg_help = state_reg THEN
            simulation_finished <= TRUE;
            WRITE(line_out, STRING'("") & LF & LF & LF);
            WRITE(line_out, STRING'("/////////////////////////////////////////////////////////////////") & LF & LF);
            WRITE(line_out, STRING'("                Number of LFSR states is:") & LF);
            WRITE(line_out, STRING'("                              "));
            WRITE(line_out, INTEGER'image(state_cnt) & LF & LF & LF);
            WRITE(line_out, STRING'("/////////////////////////////////////////////////////////////////") & LF);
            REPORT line_out.ALL SEVERITY NOTE;
            WAIT;
        END IF;
        WAIT FOR clk_period;
    END LOOP;

  END PROCESS;


END Behavioral;
