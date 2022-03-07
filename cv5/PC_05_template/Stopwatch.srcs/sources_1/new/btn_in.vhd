----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2022 09:04:01 AM
-- Design Name: 
-- Module Name: btn_in - Behavioral
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

ENTITY btn_in IS
  GENERIC(
    DEB_PERIOD                  : POSITIVE := 3
  );
  PORT(
    clk                         : IN  STD_LOGIC;
    ce                          : IN  STD_LOGIC;
    btn                         : IN  STD_LOGIC;
    btn_debounced               : OUT STD_LOGIC := '0';
    btn_egde_pos                : OUT STD_LOGIC := '0';
    btn_egde_neg                : OUT STD_LOGIC := '0';
    btn_egde_any                : OUT STD_LOGIC := '0'
  );
END btn_in;
--------------------------------------------------------------------
ARCHITECTURE Structural OF btn_in IS
  
  SIGNAL btn_sig  : STD_LOGIC := '0';
  SIGNAL btn_deb_sig : STD_LOGIC := '0';
  
  COMPONENT sync_reg
    PORT(
      clk     : IN STD_LOGIC;
      sig_in  : IN STD_LOGIC;
      sig_out : OUT STD_LOGIC
    );
  END COMPONENT sync_reg;
  
  COMPONENT debouncer
    GENERIC(
     DEB_PERIOD : POSITIVE := 3
    );
    PORT(
      clk     : IN STD_LOGIC;
      btn     : IN STD_LOGIC;
      clk_en  : IN STD_LOGIC;
      btn_deb : OUT STD_LOGIC
    );
  END COMPONENT debouncer;
  
  COMPONENT edge_detector
    PORT(
      clk       : IN STD_LOGIC;
      sig_in    : IN STD_LOGIC;
      edge_pos  : OUT STD_LOGIC;
      edge_neg  : OUT STD_LOGIC;
      edge_any  : OUT STD_LOGIC
    );
  END COMPONENT edge_detector;

BEGIN

  sync_reg_i : sync_reg
  PORT MAP(
    clk      =>  clk,
    sig_in   =>  btn,
    sig_out  =>  btn_sig
  );
  
  debouncer_i : debouncer
  GENERIC MAP(
    DEB_PERIOD => DEB_PERIOD
  )
  PORT MAP(
    clk      => clk,
    btn      => btn_sig,
    clk_en   => ce,
    btn_deb  => btn_deb_sig
  );
  
  edge_detector_i : edge_detector
  PORT MAP(
    clk => clk,
    sig_in => btn_deb_sig,
    edge_pos => btn_egde_pos,
    edge_neg => btn_egde_neg, 
    edge_any => btn_egde_any
  );
  
  btn_debounced <= btn_deb_sig;

END Structural;
