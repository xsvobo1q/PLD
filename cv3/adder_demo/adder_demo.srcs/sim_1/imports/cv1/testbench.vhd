------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
------------------------------------------------------------------------
ENTITY simple_adder_tb IS
END simple_adder_tb;
------------------------------------------------------------------------
ARCHITECTURE behavioral OF simple_adder_tb IS
------------------------------------------------------------------------

  COMPONENT simple_adder
  PORT (
    A           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    B           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    Y           : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    C           : OUT STD_LOGIC;
    Z           : OUT STD_LOGIC
  );
  END COMPONENT;

  -- Inputs
  SIGNAL A_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL B_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
  
  -- Outputs
  SIGNAL Y_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL C_sig : STD_LOGIC;
  SIGNAL Z_sig : STD_LOGIC;

  SIGNAL sim_finished : BOOLEAN := FALSE;

------------------------------------------------------------------------
BEGIN
------------------------------------------------------------------------

  simple_adder_i : simple_adder
  PORT MAP(
    A      => A_sig,
    B      => B_sig,
    Y      => Y_sig,
    C      => C_sig,
    Z      => Z_sig
  );

  ----------------------------------------------------------------------

  PROCESS
    VARIABLE Y_ref    : UNSIGNED(3 DOWNTO 0);
    VARIABLE C_ref    : STD_LOGIC;
    VARIABLE Z_ref    : STD_LOGIC;
    VARIABLE cnt_err  : INTEGER := 0;
  BEGIN

    -- check Y_sig
    FOR a IN 0 TO 15 LOOP
      FOR b IN 0 TO 15 LOOP
        A_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(a, 4));
        B_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(b, 4));
        WAIT FOR 10 ns;
        
        Y_ref := TO_UNSIGNED(a,4) + TO_UNSIGNED(b,4);
        IF NOT (Y_ref = UNSIGNED(Y_sig)) THEN
          REPORT "Error detected!   Expected Y = " & INTEGER'IMAGE(TO_INTEGER(Y_ref)) &
                 "   Actual Y = " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(Y_sig))) &
                 "   ( A = " & INTEGER'IMAGE(a) &
                 " , B = " & INTEGER'IMAGE(b) & " )"
            SEVERITY ERROR;
          cnt_err := cnt_err + 1;
        END IF;
            
        -- check C_sig
	    IF (a + b) > 15 THEN
          C_ref := '1';
        ELSE
          C_ref := '0';
        END IF;
        
        IF (C_ref /= C_sig) THEN
          REPORT "Error detected!   Expected C = " & STD_LOGIC'IMAGE(C_ref) &
                 "   Actual C = " & STD_LOGIC'IMAGE(C_sig) &
                 "   ( A = " & INTEGER'IMAGE(a) &
                 " , B = " & INTEGER'IMAGE(b) & " )"
            SEVERITY ERROR;
          cnt_err := cnt_err + 1;
        END IF;

        -- check Z_sig
	    IF ((a + b) = 0) OR ((a + b) = 16) THEN
	  --IF Y_ref = "0000" THEN
          Z_ref := '1';
        ELSE
          Z_ref := '0';
        END IF;

        IF (Z_ref /= Z_sig) THEN
          REPORT "Error detected!   Expected Z = " & STD_LOGIC'IMAGE(Z_ref) &
                 "   Actual Z = " & STD_LOGIC'IMAGE(Z_sig) &
                 "   ( A = " & INTEGER'IMAGE(a) &
                 " , B = " & INTEGER'IMAGE(b) & " )"
            SEVERITY ERROR;
          cnt_err := cnt_err + 1;
        END IF;


      END LOOP;
    END LOOP;

    -- final report
    IF cnt_err = 0 THEN
      REPORT LF &
             "================================================================" & LF &
             "Simulation PASSED (no erros)!" & LF &
             "================================================================" & LF
             SEVERITY NOTE;
    ELSE
      REPORT LF &
             "================================================================" & LF &
             "Simulation FAILED, " & INTEGER'IMAGE(cnt_err) & " errors detected." & LF &
             "================================================================" & LF
      		 SEVERITY ERROR;
    END IF;

    WAIT;
  END PROCESS;




------------------------------------------------------------------------
END ARCHITECTURE;
------------------------------------------------------------------------