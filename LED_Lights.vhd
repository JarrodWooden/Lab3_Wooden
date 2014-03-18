----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: Jarrod Wooden
-- 
-- Create Date:    15:07:44 03/16/2014 
-- Design Name: 	Light Show for Elevator
-- Module Name:    LED_Lights - Behavioral 

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED_Lights is
    Port ( Up_Down : in  STD_LOGIC;
           Stop : in  STD_LOGIC;
			  clk: in STD_LOGIC;
			  reset: in STD_LOGIC;
			  wireLSB: in STD_LOGIC_VECTOR(3 downto 0);
			  wireMSB: in STD_LOGIC_VECTOR(3 downto 0);
           Output_LED : out  STD_LOGIC_VECTOR (7 downto 0));
end LED_Lights;

architecture Behavioral of LED_Lights is

type light_state_type is (light0, light1, light2, light3, light4, light5, light6, light7);

signal light_state, next_light_state: light_state_type;

begin

-----------------------------------------------------------
--Next State Logic
-----------------------------------------------------------

	process (Up_Down, Stop, light_state)
	begin
	
		case light_state is
			when light0 => 
				if (Up_Down = '1' and Stop = '0') then
					next_light_state <= light1;
				elsif (Up_Down = '0' and Stop = '0') then
					if (wireLSB = "0010" and wireMSB = "0000") then
					next_light_state <= light0;
					else
					next_light_state <= light7;
					end if;
				else 
					next_light_state <= light0;
				end if;
				
			when light1 => 
				if (Up_Down = '1' and Stop = '0') then
					next_light_state <= light2;
				elsif (Up_Down = '0' and Stop = '0') then
					next_light_state <= light0;
				else
					next_light_state <= light1;
				end if;
				
			when light2 => 
				if (Up_Down = '1' and Stop = '0') then
					next_light_state <= light3;
				elsif (Up_Down = '0' and Stop = '0') then
					next_light_state <= light1;
				else
					next_light_state <= light2;
				end if;
				
			when light3 => 
				if (Up_Down = '1' and Stop = '0') then
					next_light_state <= light4;
				elsif (Up_Down = '0' and Stop = '0') then
					next_light_state <= light2;
				else
					next_light_state <= light3;
				end if;
				
			when light4 => 
				if (Up_Down = '1' and Stop = '0') then
					next_light_state <= light5;
				elsif (Up_Down = '0' and Stop = '0') then
					next_light_state <= light3;
				else
					next_light_state <= light4;
				end if;
				
			when light5 => 
				if (Up_Down = '1' and Stop = '0') then
					next_light_state <= light6;
				elsif (Up_Down = '0' and Stop = '0') then
					next_light_state <= light4;
				else
					next_light_state <= light5;
				end if;
				
			when light6 => 
				if (Up_Down = '1' and Stop = '0') then
					next_light_state <= light7;
				elsif (Up_Down = '0' and Stop = '0') then
					next_light_state <= light5;
				else
					next_light_state <= light6;
				end if;
				
			when light7 => 
				if (Up_Down = '1' and Stop = '0') then
					if (wireLSB = "1001" and wireMSB = "0001") then
					next_light_state <= light7;
					else
					next_light_state <= light0;
					end if;
				elsif (Up_Down = '0' and Stop = '0') then
					next_light_state <= light6;
				else
					next_light_state <= light7;
				end if;
				
			end case;
		
	end process;
	
--------------------------------------------------------------
--STATE MEMORY
--------------------------------------------------------------

light_state_machine: process (clk)
begin
	if (rising_edge(clk)) then
		if (reset = '1') then
		light_state <= light0;
		else
		light_state <= next_light_state;
		end if;
	end if;
end process;

-----------------------------------------------------------------
--OUTPUT LOGIC
-----------------------------------------------------------------

Output_LED <= "00000001" when (light_state = light0) else
			"00000010" when (light_state = light1) else
			"00000100" when (light_state = light2) else
			"00001000" when (light_state = light3) else
			"00010000" when (light_state = light4) else
			"00100000" when (light_state = light5) else
			"01000000" when (light_state = light6) else
			"10000000" when (light_state = light7) else
			"00000001";
		

end Behavioral;

