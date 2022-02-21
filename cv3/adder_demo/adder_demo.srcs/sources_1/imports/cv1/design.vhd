------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
------------------------------------------------------------------------
ENTITY simple_adder IS
  PORT (
    A           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    B           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    Y           : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    C           : OUT STD_LOGIC;
    Z           : OUT STD_LOGIC
  );
END simple_adder;
------------------------------------------------------------------------
ARCHITECTURE behavioral OF simple_adder IS
------------------------------------------------------------------------
-- declarative part of architecture

  SIGNAL A_uns    : UNSIGNED(3 DOWNTO 0);
  SIGNAL B_uns    : UNSIGNED(3 DOWNTO 0);
  SIGNAL Y_uns    : UNSIGNED(4 DOWNTO 0);

------------------------------------------------------------------------
BEGIN
------------------------------------------------------------------------

  A_uns <= UNSIGNED(A);
  B_uns <= UNSIGNED(B);

  Y_uns <= "00000" + A_uns + B_uns;

  Y <= STD_LOGIC_VECTOR( Y_uns(3 DOWNTO 0) );
  C <= Y_uns(4);
  Z <= '1' WHEN (Y_uns(3 DOWNTO 0) = "0000") ELSE '0';

------------------------------------------------------------------------
END ARCHITECTURE;
------------------------------------------------------------------------