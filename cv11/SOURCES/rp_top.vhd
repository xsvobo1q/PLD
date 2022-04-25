----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    CLK                 : IN  STD_LOGIC;
    BTN                 : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW                  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED                 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG            : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG            : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    UART_RX             : IN  STD_LOGIC;
    UART_TX             : OUT STD_LOGIC
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT (
    clk                 : IN  STD_LOGIC;
    dig_1_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_2_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_3_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_4_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dp_i                : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    dots_i              : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    disp_seg_o          : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o          : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
  END COMPONENT;
  
  COMPONENT pwm_driver
  PORT(
    CLK                 : IN  STD_LOGIC;
    PWM_REF_7           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_6           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_5           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_4           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_3           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_2           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_1           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_0           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    CNT_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
  END COMPONENT;

  --------------------------------------------------------------------------------
  -- PicoBlaze interface signals
  SIGNAL port_id            : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL write_strobe       : STD_LOGIC;
  SIGNAL k_write_strobe     : STD_LOGIC;
  SIGNAL read_strobe        : STD_LOGIC;
  SIGNAL out_port           : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL in_port            : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL interrupt          : STD_LOGIC;

  SIGNAL LED_reg            : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"00";

  --------------------------------------------------------------------------------

  SIGNAL dig_1_reg          : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL dig_2_reg          : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL dig_3_reg          : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL dig_4_reg          : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL dp_reg             : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL dots_reg           : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ID_PWM_REF_0_s     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ID_PWM_REF_1_s     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ID_PWM_REF_2_s     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ID_PWM_REF_3_s     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ID_PWM_REF_4_s     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ID_PWM_REF_5_s     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ID_PWM_REF_6_s     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ID_PWM_REF_7_s     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL LED_out_s          : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');

  --------------------------------------------------------------------------------

  -- PicoBlaze address space definition
  CONSTANT ID_BTN           : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"00";
  CONSTANT ID_SW            : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"01";
  CONSTANT ID_LED           : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"02";
  CONSTANT ID_7SEG_DIG_1    : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"03";
  CONSTANT ID_7SEG_DIG_2    : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"04";
  CONSTANT ID_7SEG_DIG_3    : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"05";
  CONSTANT ID_7SEG_DIG_4    : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"06";
  CONSTANT ID_7SEG_DP       : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"07";
  CONSTANT ID_7SEG_DOTS     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"08";
  CONSTANT ID_PWM_REF_0     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"09";
  CONSTANT ID_PWM_REF_1     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"0A";
  CONSTANT ID_PWM_REF_2     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"0B";
  CONSTANT ID_PWM_REF_3     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"0C";
  CONSTANT ID_PWM_REF_4     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"0D";
  CONSTANT ID_PWM_REF_5     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"0E";
  CONSTANT ID_PWM_REF_6     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"0F";
  CONSTANT ID_PWM_REF_7     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"10";
  
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- PicoBlaze (KCPSM6 core) with its program memory
  --------------------------------------------------------------------------------

  embedded_kcpsm6_i : ENTITY work.embedded_kcpsm6
  PORT MAP (
    port_id         => port_id,
    write_strobe    => write_strobe,
    k_write_strobe  => k_write_strobe,
    read_strobe     => read_strobe,
    out_port        => out_port,
    in_port         => in_port,
    interrupt       => '0',
    clk             => clk
  );


  --------------------------------------------------------------------------------
  -- 7-segment driver
  --------------------------------------------------------------------------------

  seg_disp_driver_i : seg_disp_driver
  PORT MAP (
    clk                 => CLK,
    dig_1_i             => dig_1_reg,
    dig_2_i             => dig_2_reg,
    dig_3_i             => dig_3_reg,
    dig_4_i             => dig_4_reg,
    dp_i                => dp_reg,
    dots_i              => dots_reg,
    disp_seg_o          => DISP_SEG,
    disp_dig_o          => DISP_DIG
  );


  --------------------------------------------------------------------------------
  -- Input port MUX
  --------------------------------------------------------------------------------

  input_ports: process(clk)
  begin
    if rising_edge(clk) then

      case port_id is
        when ID_BTN                 =>  in_port <= "0000" & BTN;
        when ID_SW                  =>  in_port <= "0000" & SW;

        when ID_LED                 =>  in_port <= LED_reg;

        when ID_7SEG_DIG_1          =>  in_port <= "0000" & dig_1_reg;
        when ID_7SEG_DIG_2          =>  in_port <= "0000" & dig_2_reg;
        when ID_7SEG_DIG_3          =>  in_port <= "0000" & dig_3_reg;
        when ID_7SEG_DIG_4          =>  in_port <= "0000" & dig_4_reg;
        when ID_7SEG_DP             =>  in_port <= "0000" & dp_reg;
        when ID_7SEG_DOTS           =>  in_port <= "00000" & dots_reg;

        -- To ensure minimum logic implementation when defining a multiplexer always
        -- use don't care for any of the unused cases
        when others                 =>  in_port <= "XXXXXXXX";
      end case;
    end if;
  end process input_ports;
  
  pwm_driver_i : pwm_driver
  PORT MAP(
    CLK => clk,
    PWM_REF_7 => ID_PWM_REF_7_s,
    PWM_REF_6 => ID_PWM_REF_6_s,
    PWM_REF_5 => ID_PWM_REF_5_s,
    PWM_REF_4 => ID_PWM_REF_4_s,
    PWM_REF_3 => ID_PWM_REF_3_s,
    PWM_REF_2 => ID_PWM_REF_2_s,
    PWM_REF_1 => ID_PWM_REF_1_s,
    PWM_REF_0 => ID_PWM_REF_0_s,
    PWM_OUT   => LED_out_s,
    CNT_OUT   => OPEN
  );

  --------------------------------------------------------------------------------
  -- Output port MUX
  --------------------------------------------------------------------------------

  output_ports: process(clk)
  begin
    if rising_edge(clk) then

      if write_strobe = '1' then
        case port_id is
          when ID_LED               =>       LED_reg <= out_port;

          when ID_7SEG_DIG_1        =>     dig_1_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DIG_2        =>     dig_2_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DIG_3        =>     dig_3_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DIG_4        =>     dig_4_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DP           =>        dp_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DOTS         =>      dots_reg <= out_port(2 DOWNTO 0);
          
          when ID_PWM_REF_0         =>     ID_PWM_REF_0_s   <= out_port;
          when ID_PWM_REF_1         =>     ID_PWM_REF_1_s   <= out_port;
          when ID_PWM_REF_2         =>     ID_PWM_REF_2_s   <= out_port;
          when ID_PWM_REF_3         =>     ID_PWM_REF_3_s   <= out_port;
          when ID_PWM_REF_4         =>     ID_PWM_REF_4_s   <= out_port;
          when ID_PWM_REF_5         =>     ID_PWM_REF_5_s   <= out_port;
          when ID_PWM_REF_6         =>     ID_PWM_REF_6_s   <= out_port;
          when ID_PWM_REF_7         =>     ID_PWM_REF_7_s   <= out_port;

          when others               =>  NULL;
        end case;
      end if;
    end if;
  end process output_ports;

  LED <= LED_out_s;

  --------------------------------------------------------------------------------

  UART_TX <= '1';

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
