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
-- change value if you want (default := 20)
constant val: std_logic_vector (15 downto 0):="0000000000100000";	--load 00 := 0000 0000 
constant valup: std_logic_vector (15 downto 0):="0000000000000000";  	--load 20 := 0010 0000 
signal time: integer := 0;
--
signal temp_count: std_logic_vector (15 downto 0):=val;
signal slow_clk: std_logic;
signal clk_divider: std_logic_vector (25 downto 0);

begin

display_out: display_controller port map (
    clk=>clk,
    reset=>reset,
    
    hex3=>temp_count (15 downto 12),
    hex2=>temp_count (11 downto 8),
    hex1=>temp_count (7 downto 4),
    hex0=>temp_count (3 downto 0),
    
    an=>an,
    sseg=>sseg
    );

clk_division: process (clk, clk_divider)
    begin
        if clk'event and clk='1' then
            clk_divider<=clk_divider +1;
        end if;
        
        slow_clk<=clk_divider(24);
    
end process;
    
counting: process (reset, slow_clk, temp_count)
    begin
    if reset='1' then
       temp_count  <=val; -- load value
    
    else
        if slow_clk'event and slow_clk='1' then
--            if temp_count>0 then

                if temp_count(3 downto 0)=0 then
                    temp_count(3 downto 0)<="1001";
                if temp_count(7 downto 4)=0 then
                    temp_count(7 downto 4)<="1001";
                if temp_count(11 downto 8)=0 then
                    temp_count(11 downto 8)<="1001";
                if temp_count(15 downto 12)=0 then
                    --temp_count(15 downto 12)<="1000";
                        else
                        temp_count(15 downto 12) <= temp_count(15 downto 12) - 1;
                        end if;
                        else
                        temp_count(11 downto 8) <= temp_count(11 downto 8) - 1;
                        end if;
                        else
                        temp_count(7 downto 4) <= temp_count(7 downto 4) - 1;
                        end if;    
                        else
                        temp_count(3 downto 0) <= temp_count(3 downto 0) - 1;
                        end if;
                if temp_count=valup  then  -- when display equal to 20,  restart with 00!!! 
                    temp_count<=val;
		end if;                                                            
           end if;
   end if;
end process;         
 
end Behavioral;
