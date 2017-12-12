library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity display_controller is
 Port ( clk,reset : in std_logic;
        hex3,hex2,hex1,hex0 : in std_logic_vector (3 downto 0);
         an : out std_logic_vector (3 downto 0);
         sseg : out std_logic_vector (6 downto 0)  
  );
  end display_controller;
  
architecture Behavioral of display_controller is

constant N: integer :=20;
-- constant 'N' set to an integer, used to slow the
-- display speed so that regular humans can see it
-- changing this number to anything < 25 and the display
-- is too slow, > 18 and the display is too fast
signal q_next: std_logic_vector (N-1 downto 0);-- Q_REG used to set the value of SEL, see process
signal sel: std_logic_vector (1 downto 0);-- SEL value determines which anode to display
signal hex: std_logic_vector (3 downto 0);-- HEX value determines the cathode display, see end of code

begin
    clk_division: process (clk, q_next)
    begin
        if clk'event and clk='1' then
            q_next<=q_next +1;
        end if;
        sel<=q_next(N-1 downto N-2);
    end process;

    digits: process (sel,hex0,hex1,hex2,hex3)
    
    begin
        case sel is
        
            when "00"=> 
            an<="1110";
            hex<=hex0;
            
            when "01"=> 
            an<="1101";
            hex<=hex1;
            
            when "10"=> 
            an<="1011";
            hex<=hex2;
            
            when others=> 
            an<="0111";
            hex<=hex3;
  
        end case;
     
     end process;

    display: process (hex)
    begin
        case hex is  
          when "0000"=> sseg <="0000001";  -- '0'
          when "0001"=> sseg <="1001111";  -- '1'
          when "0010"=> sseg <="0010010";  -- '2'
          when "0011"=> sseg <="0000110";  -- '3'
          when "0100"=> sseg <="1001100";  -- '4' 
          when "0101"=> sseg <="0100100";  -- '5'
          when "0110"=> sseg <="0100000";  -- '6'
          when "0111"=> sseg <="0001111";  -- '7'
          when "1000"=> sseg <="0000000";  -- '8'
          when "1001"=> sseg <="0000100";  -- '9'
           --nothing is displayed when a number more than 9 is given as input. 
          when others=> sseg <="0000100"; 
   	end case;
    end process;

end Behavioral;
