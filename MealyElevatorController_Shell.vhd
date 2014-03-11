----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Jarrod Wooden
-- 
-- Create Date:    6 March 2014 
-- Design Name: 	Mealy Design
-- Module Name:    MealyElevatorController_Wooden - Behavioral 
-- Project Name:  CE3_Wooden
-- Target Devices: NONE
-- Revision 0.01 - File Created
-- Additional Comments: Original Code was Captain Silva's. I simply correct the code
--								to make it function properly.
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

entity MealyElevatorController_Shell is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
           floor : out  STD_LOGIC_VECTOR (3 downto 0);
			  nextfloor : out std_logic_vector (3 downto 0));
end MealyElevatorController_Shell;

architecture Behavioral of MealyElevatorController_Shell is

type floor_state_type is (floor1, floor2, floor3, floor4);

--Here you create a variable "floor_state" that can take on the values
--defined above. Neat-o!

--need to add a next floor state variable as well that take on the types above
signal next_floor_state, floor_state : floor_state_type;

begin

---------------------------------------------
--NEXT STATE LOGIC
---------------------------------------------

process (up_down, stop, floor_state) is 
begin
			case floor_state is
				--when our current state is floor1
				when floor1 =>
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						--floor2 right?? This makes sense!
						next_floor_state <= floor2;
					--otherwise we're going to stay at floor1
					else
						next_floor_state <= floor1;
					end if;
				--when our current state is floor2
				when floor2 => 
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						next_floor_state <= floor3; 			
					--if up_down is set to "go down" and stop is set to 
					--"don't stop" which floor do we want to go to?
					elsif (up_down='0' and stop='0') then 
						next_floor_state <= floor1;
					--otherwise we're going to stay at floor2
					else
						next_floor_state <= floor2;
					end if;
				
--COMPLETE THE NEXT STATE LOGIC ASSIGNMENTS FOR FLOORS 3 AND 4
				when floor3 =>
					if (up_down='1' and stop='0') then 
						next_floor_state <= floor4;
					elsif (up_down='0' and stop='0') then 
						next_floor_state <= floor2;
					else
						next_floor_state <= floor3;	
					end if;
				when floor4 =>
					if (up_down='0' and stop='0') then 
						next_floor_state <= floor3;
					else 
						next_floor_state <= floor4;
					end if;
				
				--This line accounts for phantom states
				when others =>
					next_floor_state <= floor1;
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
			floor_state <= floor1;
		else
			 
			floor_state <= next_floor_state;

		end if;
		
		--no else to the first if because we want vhdl to create memory by the elevator 
		--remembering the floor_state if there is no rise of the clock.
	end if;
end process;

-----------------------------------------------------------
--Code your Ouput Logic for your Mealy machine below
--Remember, now you have 2 outputs (floor and nextfloor)
-----------------------------------------------------------
floor <= "0001" when (floor_state = floor1) else
			"0010" when (floor_state = floor2) else
			"0011" when (floor_state = floor3) else
			"0100" when (floor_state = floor4) else
			"0001"; --need else because we don't want any chance of creating memory outside of "STATE MEMORY"
			
nextfloor <= 	"0010" when (floor_state = floor1 and up_down = '1') else
			"0011" when (floor_state = floor2 and up_down = '1') else
			"0100" when (floor_state = floor3 and up_down = '1') else
			"0011" when (floor_state = floor4 and up_down = '0') else
			"0010" when (floor_state = floor3 and up_down = '0') else
			"0001" when (floor_state = floor2 and up_down = '0') else
			"0001";

end Behavioral;

