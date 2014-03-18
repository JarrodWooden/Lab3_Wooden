----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Wooden
-- 
-- Create Date:    	10:33:47 07/07/2012 
-- Design Name:		CE3
-- Module Name:    	MooreElevatorController_Shell - Behavioral 
-- Description: 		Shell for completing CE3
--
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

entity Change_Inputs is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  input : in STD_LOGIC_VECTOR (3 downto 0);
			  floor : out STD_LOGIC_VECTOR (3 downto 0));
end Change_Inputs;

architecture Behavioral of Change_Inputs is

--Below you create a new variable type! You also define what values that 
--variable type can take on. Now you can assign a signal as 
--"floor_state_type" the same way you'd assign a signal as std_logic 
type floor_state_type is (floor0, floor1, floor2, floor3, floor4, floor5, floor6, floor7);

--Here you create a variable "floor_state" that can take on the values
--defined above. Neat-o!

--need to add a next floor state variable as well that take on the types above
signal next_floor_state, floor_state : floor_state_type;


begin

---------------------------------------------
--NEXT STATE LOGIC
---------------------------------------------

process (input, floor_state) is 
begin
			case floor_state is
				--when our current state is floor1
				when floor0 =>
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (input > "0000") then 
						--floor2 right?? This makes sense!
						next_floor_state <= floor1;
					--otherwise we're going to stay at floor0
					else
						next_floor_state <= floor0;
					end if;
				--when our current state is floor2
				when floor1 => 
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (input > "0001") then 
						next_floor_state <= floor2; 			
					--if up_down is set to "go down" and stop is set to 
					--"don't stop" which floor do we want to go to?
					elsif (input < "0001") then 
						next_floor_state <= floor0;
					--otherwise we're going to stay at floor2
					else
						next_floor_state <= floor1;
					end if;
				
--COMPLETE THE NEXT STATE LOGIC ASSIGNMENTS FOR FLOORS 3 AND 4
				when floor2 =>
					if (input > "0010") then 
						next_floor_state <= floor3;
					elsif (input < "0010") then 
						next_floor_state <= floor1;
					else
						next_floor_state <= floor2;	
					end if;
					
					when floor3 =>
					if (input > "0011") then 
						next_floor_state <= floor4;
					elsif (input < "0011") then 
						next_floor_state <= floor2;
					else
						next_floor_state <= floor3;	
					end if;
					
					when floor4 =>
					if (input > "0100") then 
						next_floor_state <= floor5;
					elsif (input < "0100") then 
						next_floor_state <= floor3;
					else
						next_floor_state <= floor4;	
					end if;
					
					when floor5 =>
					if (input > "0101") then 
						next_floor_state <= floor6;
					elsif (input < "0101") then 
						next_floor_state <= floor4;
					else
						next_floor_state <= floor5;	
					end if;
					
					when floor6 =>
					if (input > "0110") then 
						next_floor_state <= floor7;
					elsif (input < "0110") then 
						next_floor_state <= floor5;
					else
						next_floor_state <= floor6;	
					end if;
					
					when floor7 =>
					if (input < "0111") then 
						next_floor_state <= floor6;
					else
						next_floor_state <= floor7;	
					end if;
				
				--This line accounts for phantom states
				when others =>
					next_floor_state <= floor0;
			end case;
end process;

-----------------------------
--STATE MEMORY
-----------------------------

--This line will set up a process that is sensitive to the clock
floor_state_machine: process(clk)
begin
	--clk'event and clk='1' is VHDL-speak for a rising edge
	--bad code need RISING_EDGE, because making the comparison before could delay the clock
	if (rising_edge(clk)) then
		--reset is active high and will return the elevator to floor1
		--Question: is reset synchronous or asynchronous?
			--ANSWER: synchronus if reset is only checked on the rising edge edge the clock
		if reset='1' then
			floor_state <= floor0;
		else
			
			floor_state <= next_floor_state;

		end if;
		
		--no else to the first if because we want vhdl to create memory by the elevator 
		--remembering the floor_state if there is no rise of the clock.
	end if;
end process;


----------------------------------
--OUTPUT LOGIC
----------------------------------

-- Here you define your output logic. Finish the statements below
floor <= "0000" when (floor_state = floor0) else
			"0001" when (floor_state = floor1) else
			"0010" when (floor_state = floor2) else
			"0011" when (floor_state = floor3) else
			"0100" when (floor_state = floor4) else
			"0101" when (floor_state = floor5) else
			"0110" when (floor_state = floor6) else
			"0111" when (floor_state = floor7) else
			"0000"; --need else because we don't want any chance of creating memory outside of "STATE MEMORY"

end Behavioral;