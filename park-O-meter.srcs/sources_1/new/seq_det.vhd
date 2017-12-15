library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity counter is
 Port ( clk : in std_logic;
         reset : in std_logic;
         button0: in std_logic;
         button1: in std_logic;
         button2: in std_logic;
         button3: in std_logic;
         an : out std_logic_vector (3 downto 0);
         sseg : out std_logic_vector (6 downto 0) 
  );
end counter;

architecture Behavioral of counter is

component display_controller is
    Port ( clk, reset : in std_logic;
         hex3,hex2,hex1,hex0 : in std_logic_vector (3 downto 0);
         an : out std_logic_vector (3 downto 0);
         sseg : out std_logic_vector (6 downto 0)  
         );
end component;

COMPONENT bin2bcd_12bit
    PORT(
         binIN : IN  std_logic_vector(11 downto 0);
         ones : OUT  std_logic_vector(3 downto 0);
         tens : OUT  std_logic_vector(3 downto 0);
         hundreds : OUT  std_logic_vector(3 downto 0);
	 thousands : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
-- change value if you want (default := 20)
constant val: std_logic_vector (15 downto 0):="0000000000100000";	--load 00 := 0000 0000 
constant valup: std_logic_vector (15 downto 0):="0000000000000000";  	--load 20 := 0010 0000 
signal time: integer := 0;
--
signal temp_count: std_logic_vector (15 downto 0):=val;
signal slow_clk: std_logic;
signal clk_divider: std_logic_vector (25 downto 0);
--

--Inputs
   signal binIN : std_logic_vector(11 downto 0) := (others => '0');
--Outputs
   signal ones : std_logic_vector(3 downto 0);
   signal tenths : std_logic_vector(3 downto 0);
   signal hunderths : std_logic_vector(3 downto 0);
   signal thousands : std_logic_vector(3 downto 0);
-- Miscellaneous
   signal full_number : std_logic_vector(15 downto 0);
   
   
begin
uut: bin2bcd_12bit PORT MAP (
       binIN => binIN,
       ones => ones,
       tens => tenths,
       hundreds => hunderths,
   thousands => thousands
     );

display_out: display_controller port map (
    clk=>clk,
    reset=>reset,
    
    hex3=>thousands,
    hex2=>hunderths,
    hex1=>tenths,
    hex0=>ones,
    
    an=>an,
    sseg=>sseg
    );

clk_division: process (clk, clk_divider)
    begin
        if clk'event and clk='1' then
            clk_divider<=clk_divider +1;
        end if;
        
        if clk_divider = "0101111101011110000100000000" then
            slow_clk<='1';
        else
            slow_clk<='0';
        end if;
    
end process;
    
counting: process (reset, slow_clk, temp_count,button0,button1,button2,button3)   
    begin
            if slow_clk'event and slow_clk='1' then
                if button0='1' then
                    time<=time+30;
                elsif(button1='1')then
                    time<=time+60;
                elsif(button2='1')then
                    time<=time+120;
                elsif(button3='1')then
                    time<=time+300;
                else
                    if binIN = 0 then
                        binIN <= std_logic_vector (to_unsigned(time,12));
                    else   
                        time<=time-1;
                        binIN<=std_logic_vector (to_unsigned(time,12));
                    end if;
                end if;
        end if;
    end process;
end Behavioral;