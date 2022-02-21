----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY RP_top IS
  PORT(
    BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END RP_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF RP_top IS
----------------------------------------------------------------------------------

  COMPONENT simple_adder
  PORT (
    A           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    B           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    Y           : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    C           : OUT STD_LOGIC;
    Z           : OUT STD_LOGIC
  );
  END COMPONENT;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  simple_adder_i : simple_adder
  PORT MAP(
    A      => SW,
    B      => BTN,
    Y      => LED(3 DOWNTO 0),
    C      => LED(5),
    Z      => LED(7)
  );

  LED(4) <= '0';
  LED(6) <= '0';

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
