--------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--------------------------------------------------------
ENTITY simple_adder_tb IS
END ENTITY simple_adder_tb;
--------------------------------------------------------
ARCHITECTURE Behavioral OF simple_adder_tb IS

  COMPONENT simple_adder
  PORT(
    A      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    B      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    Y      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    C      : OUT STD_LOGIC;
    Z      : OUT STD_LOGIC
   );
  END COMPONENT simple_adder;

  SIGNAL a_sig    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL b_sig    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL y_sig    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL c_sig    : STD_LOGIC;
  SIGNAL z_sig    : STD_LOGIC;
BEGIN

  simple_adder_i : simple_adder
  PORT MAP(
    A  =>  a_sig,
    B  =>  b_sig,
    Y  =>  y_sig,
    C  =>  c_sig,
    Z  =>  z_sig
  );
 
 -- Stimulus generator
PROCESS
BEGIN
  -- a_sig <= "0000";
  -- b_sig <= "0000";
  FOR i IN 0 TO 15 LOOP
  
    a_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,4));
    
    FOR j IN 0 TO 15 LOOP
    
      b_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(j,4));
      WAIT FOR 10 ns;
      
    END LOOP;
    
  END LOOP;
   
  WAIT;
  
END PROCESS;
 
 -- Output chceker
PROCESS
  -- VARIABLE v_y_ref  :  STD_LOGIC_VECTOR(y_sig'RANGE);
  VARIABLE v_y_ref  :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  VARIABLE v_c_ref  :  STD_LOGIC;
  VARIABLE v_z_ref  :  STD_LOGIC;
  
BEGIN
  WAIT ON a_sig, b_sig;  -- spusteni verifikace po zmene techto promennych
  WAIT FOR 1 ns;         -- "delta cycle" handling
  
  v_y_ref := STD_LOGIC_VECTOR("00000" + UNSIGNED(a_sig) + UNSIGNED(b_sig));
  v_c_ref := v_y_ref(4);
  v_z_ref := '1' WHEN v_y_ref(3 DOWNTO 0) = "0000" ELSE '0';
  
  ASSERT (y_sig = v_y_ref(3 DOWNTO 0)) REPORT
 
    "Chyba ve vysledku souctu: Y = "
    & INTEGER'image(TO_INTEGER(UNSIGNED(y_sig))) &
    " ocekacana hodnota Y => "
    & INTEGER'image(TO_INTEGER(UNSIGNED(v_y_ref(3 DOWNTO 0)))) &
    " pri vstupech: A = "
    & INTEGER'image(TO_INTEGER(UNSIGNED(a_sig))) &
    " a B = "
    & INTEGER'image(TO_INTEGER(UNSIGNED(b_sig)))
    
  SEVERITY ERROR;
  
  ASSERT c_sig = v_c_ref REPORT 
    
    "Chyba v CARRY: C = "
    & STD_LOGIC'image(c_sig) &
    " ocekavana hodnota je => "
    & STD_LOGIC'image(v_c_ref)
    
  SEVERITY ERROR;
  
  ASSERT z_sig = v_z_ref REPORT
    
    "Chyba v ZERRO_FLAG: Z = "
    & STD_LOGIC'image(z_sig) &
    " ocekavana hodnota je => "
    & STD_LOGIC'image(v_z_ref)
    
  SEVERITY ERROR;  
  
  
END PROCESS;

END ARCHITECTURE Behavioral;

--------------------------------------------------------