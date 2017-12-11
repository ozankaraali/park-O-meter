library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main is
    Port ( BUTTON : in STD_LOGIC_VECTOR (3 downto 0);
           mahmut : in STD_LOGIC_VECTOR
    );
end Main;

architecture Behavioral of Main is
signal time: integer := 0;
begin

    addCoin: process (BUTTON)
    begin
        if(risingedge(BUTTON(0))) then
            time <= time + 30
        elsif (risingedge(BUTTON(1))) then
            time <= time + 60
        elsif (risingedge(BUTTON(2))) then
            time <= time + 120
        elsif (risingedge(BUTTON(3))) then
            time <= time + 300
        end if;
    end process;

end Behavioral;