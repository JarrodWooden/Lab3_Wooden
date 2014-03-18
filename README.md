Lab3_Wooden
===========

Elevator Controller


****************

#Pre Lab Schematic

****************

For the prelab I needed to go through the given code, which was basically the top module.

Then after reading through all the code I was able to draw a schematic of what the Top Module for the 
elevator controller is doing.

Schematic can be seen below:

![alt text](https://raw.github.com/JarrodWooden/Lab3_Wooden/master/SchematicTopModule.jpg "Top Module Schematic")


#Main Lab

##Functionality

I recieved full points for the basic functionality for the moore and mealy machine: Required Funtionality 40 points

Captain Silva Checked me off for the More Floors  Functionality 10 points

Captain Silva Checked me off for the Change Inputs Functionality 10 points

Captain Silva Checked me off for the Moving Lights Functionality 5 points

##Moore and Mealy Machines

The first thing I did was make Component and instantiate the Moore and Mealy elevator controllers that we 
made from Computer Exercise 3 (Refer to the CE3 ReadMe to see how the creation of the controllers)

The Moore needed one signal for its ouptut to insert in the nibble to sseg machine in order to create a readable output
on the LED screen.

The Mealy machine needed *TWO SIGNALS*
  One for the *current floor* output
  The other for *the next floor* output
  
Once again I could easily put the two signals from the output of the Mealy and Moore machine and send it into the 
nibble to sseg machine to create an ouput on the LED screeen.

The signals I used are below

    ```
    signal moore_floor : std_logic_vector(3 downto 0);
    signal mealy_floor : std_logic_vector(3 downto 0);
    signal mealy_next_floor : std_logic_vector(3 downto 0);
    ```
    
The input into the machines are from the switches. Specifically, the `switch(0)` was used for *stopping* the elevators and `switch(1)` was used to either make the elevator move up if it was a one and down if it was a zero.

(Refer to CE3 to understand how the inputs for `Up_Down` and `Stop` were used in order to make the elevator controllers
function properly)

##More Floors

Objective: The purpose for More Floors was to discover how to change the output of the moore machine in order to
have 8 floors instead of only 4 and to change the output of those 8 floors to *prime number* labeled floors

The first thing I did was create a new VHDL module and copied and pasted everything from the Moore maching over to 
the new module.

Once I created a copy of the Moore machine I simply added the code needed to create more floors and change the outputs

To create more floors I needed to change the `next_floor_state` to include 4 more floors, and I needed to change the
enumeration to include those four more floors.

Enumeration:

    ```
    type floor_state_type is (floor2, floor3, floor5, floor7, floor11, floor13, floor17, floor19);
    signal next_floor_state, floor_state : floor_state_type;
    ```

    -So first I created the new floors in the `floor_state_type` to include the prime numbered floors up to floor 19
    -Then I created two signals for the next floor the elevator will move to (depending on if the elevator is moving
    up or down) and the current floor the elevator is on.
    
Next State Logic for new Floors Example:

    ```
        when floor5 =>
          if (up_down='1' and stop='0') then 
            next_floor_state <= floor7;
          elsif (up_down='0' and stop='0') then 
            next_floor_state <= floor3;
          else
            next_floor_state <= floor5;	
          end if;
    ```

    -What the above does is the next state logic for the next floor that the elevator will go to
    -So if the elevator is on floor 5 and it is moving up and the stop switch is not being used it will go to the 7th
    floor
    -If it is moving down and the stop switch isn't being used it will move to floor 3
    -Otherwise, it will stay on floor 5 because the stop switch is being used.
    
I repeated the above for every prime floor and the top floor obviously wouldn't go up any more and the bottom floor
wouldn't go down any more.

Memory Change:

  I made sure that when the reset was pressed that the elevator would reset to the bottom floor, being floor 2.

Output Change:

Below you can see how the ouptut was changed to show the correct numbered floor on the LED screen

      ```
      floor_digO <= "0010" when (floor_state = floor2) else
      "0011" when (floor_state = floor3) else
      "0101" when (floor_state = floor5) else
      "0111" when (floor_state = floor7) else
      "0001" when (floor_state = floor11) else
      "0011" when (floor_state = floor13) else
      "0111" when (floor_state = floor17) else
      "1001" when (floor_state = floor19) else
      "0010"; --need else because we don't want any chance of creating memory outside of "STATE MEMORY"
      
      floor_digT <= "0000" when (floor_state = floor2) else
      "0000" when (floor_state = floor3) else
      "0000" when (floor_state = floor5) else
      "0000" when (floor_state = floor7) else
      "0001" when (floor_state = floor11) else
      "0001" when (floor_state = floor13) else
      "0001" when (floor_state = floor17) else
      "0001" when (floor_state = floor19) else
      "0000";
      ```
      
**Notice that I used two ouptuts. One for the Least Significant Digit and One for the Most Significant Digit. This was 
implemented because the floors go into double digits; therefore, two digits must be displayed on the LED screen.

Top_Shell Implementation:

To implement the newly made Prime Numbered floor componenet, I created the Componenet and instantiated the part.

I needed two signals to use as the output for the More Floors Machine:

      ```
      signal prime_floor1: std_logic_vector(3 downto 0);
      signal prime_floor2: std_logic_vector(3 downto 0);
      ```
      
  -One was the Least Significant Digit, and Two was the Most Significant Digit.
  
Then I sent these two signals into the nibble to sseg machine in order to send the sseg signals into the LED screen
output to be seen.

##Change Inputs

Objective: Was to change the input given to the elevator controller to say which floor you would like the elevator to 
go to instead of just telling the elevator to go up and stop, or go down and stop. This would create more comparisons 
in the next state logic that would need to be conducted to determine if the elevator reached the desired floor or not.

Once again I copied the Moore Machine code over to the Change Inputs Module and simply changed the Module to what
I needed it to do.

Change in Enumeration:

      ```
      type floor_state_type is (floor0, floor1, floor2, floor3, floor4, floor5, floor6, floor7);
      signal next_floor_state, floor_state : floor_state_type;
      ```
  -Changed the Eight labeled floors back to normal floors labeled 0 to 7 instead of the prime numbered floors.

Change in Input:

  -Instead of using `std_logic` as the input for `Up_Down` and `Stop`, I used a four bit `std_logic_vector` to have the
  switch as an input to tell the elevator which floor to go to.
  
Next State Logic:

      ```
      when floor3 =>
        if (input > "0011") then
            next_floor_state <= floor4;
        elsif (input < "0011") then 
            next_floor_state <= floor2;
        else
            next_floor_state <= floor3;	
        end if;
      ```
      
  So what is going on is that the input binary code is greater than the current floor; it will move the next state to
  the next floor.
  
  If the input is less than the current floor is will move down a floor.
  
  If the input and the floor binary numbers are equal than it will stay on that floor.
  
  I repeated this code for all 8 floors and just made sure the elevator would stop on the bottom and top floors.
  
Memory Change:

  I made sure `reset` would make the next floor be the bottom floor, being floor zero.
  
Output Change:

  I simply changed the output to One `std_logic_vector(3 downto 0)` that depending on the floor it was on, 0 through 7, 
  the output of the vector will be a binary four bit number that would match the number for the floor to be sent to
  the LED screen in the Top_Shell module.
  
Top_Shell implementation:

  -Change in Signals:
    
    I had one output from the change inputs machine that would go to the nibble and finally to the LED Screen
    I also split the 8 bit switch `std_logic_vector` to two four bit `std_logic_vector`'s, where the first four
    will go to the input to the Change Input Machine to tell the elevator where you want to go.
    
##Moving Lights

  Objective: Be able to create a new state module machine that will control the LED lights above the switches on the
  FPGA to have moving lights to tell the elevator user whether the elevator is moviing up or down.
  
  I made moving up to the left (to the higher switches) and down to the right (to the lower switches)
  
  I made the Moving Light machine work in coordination with the Prime Numbers elevator
  
Inputs:

  -The module was sent in whether the elevator was moving up or down or stopped, and it was also sent the most and least
  significant number for the current floor the elevator was on to the if the elevator reaches the top or bottom floors
  the lights will automatically stop moving.
  
  -Therefore, the lights were depending on the current floor the elevator is on, whether it is moving up or down, and
  whether the elevator is stopped or not.
  
Next State Logic:
  -Similar to the code for the elevators, I made next state logic to determine the next light to be flashed.
  
  Here is an example of the next state logic:
  
    ```
    when light1 => 
    if (Up_Down = '1' and Stop = '0') then 
    next_light_state <= light2;
    elsif (Up_Down = '0' and Stop = '0') then 
    next_light_state <= light0; 
    else next_light_state <= light1; 
    end if; 
    ```
  So if `Up_Down` is one and `Stop` is zero it will move to the next light, if `Up_Down` is zero is will move to the 
  opposite light.
  
  If stop is switched than it will stay with that current light lit.
  
  When it hits the bottom light and the elevator has not reached the bottom floor it will jump back up to the top light
  and move all the way back down the lights.
  
  If the elevator has reached the bottom or top floor the moving lights will stop on the bottom or top light
  respectively
  
Memory:
  
  The reset button is synchronus and the next light change will be on the rising edge of the clock.
  
Output:
  
  The output is an 8 bit `std_logic_vector` that will make a one for whichever LED that needs to be lit up for whichever
  current light that the Moving Lights machine is on.
  
#The End


#Have a Great Air Force Day

