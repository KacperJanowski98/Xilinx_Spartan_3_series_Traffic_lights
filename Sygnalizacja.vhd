library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Sygnalizacja is
	port (Clk : in std_logic;
			reset : inout std_logic := '0';
			dayNight : in std_logic := '0';
			ped_button : inout std_logic := '0';
			car_green : inout std_logic := '0';
			car_yellow : inout std_logic := '0';
			car_red : inout std_logic := '0';
			ped_green : inout std_logic := '0';
			ped_red : inout std_logic := '0');
end Sygnalizacja;

architecture Behavioral of Sygnalizacja is
	signal counter : integer range 0 to 79 := 0;
	signal active : std_logic := '0';
	
begin
	process(Clk, reset) 
	begin
		if(reset = '1') then
			counter <= 0;
		elsif rising_edge(Clk) then
			if(counter = 79) then
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;	
	end process;

 -- proces sygnalizacji w dzieñ i w nocy	
	process(dayNight, active, counter)
	begin
		if (dayNight = '0') then -- tryb dzienny 
			if (counter > 41) then 
				car_red <= '1';
				car_green <= '0';
			elsif (counter < 40) then
				car_green <= '1';
				car_red <= '0';
			else 
				car_green <= '0';
				car_red <= '0';
			end if;
			
			if (counter = 40 or counter = 41 or counter = 78 or counter = 79) then
				car_yellow <= '1';
			else 
				car_yellow <= '0';
			end if;
			
			if (counter < 42) or (counter > 77) then
				ped_red <= '1';
				ped_green <= '0';
			elsif ((counter > 41) and (counter < 71)) then
				ped_green <= '1';
				ped_red <= '0';
			end if;
			
			if (counter = 72 or counter = 74 or counter = 76) then 
				ped_green <= '1';
			elsif (counter = 73 or counter = 75 or counter = 77) then
				ped_green <= '0';
			end if;
			
		else  -- tryb nocny	
			if (active = '0') then -- tryb nocy bez aktywacji przejscia
				car_green <= '1';
				car_red <= '0';
				car_yellow <= '0';
				ped_green <= '0';
				ped_red <= '1';
				reset <= '1';
			else  -- aktywacja przejscia dla pieszych 
				reset <= '0';
				if (counter > 41) then 
					car_red <= '1';
					car_green <= '0';
				elsif (counter < 40) then
					car_green <= '1';
					car_red <= '0';
				else 
					car_green <= '0';
					car_red <= '0';
				end if;
			
				if (counter = 40 or counter = 41 or counter = 78 or counter = 79) then
					car_yellow <= '1';
				else 
					car_yellow <= '0';
				end if;
			
				if (counter < 42) or (counter > 77) then
					ped_red <= '1';
					ped_green <= '0';
				elsif ((counter > 41) and (counter < 71)) then
					ped_green <= '1';
					ped_red <= '0';
				end if;
			
				if (counter = 72 or counter = 74 or counter = 76) then 
					ped_green <= '1';
				elsif (counter = 73 or counter = 75 or counter = 77) then
					ped_green <= '0';
				end if;	
			end if;
		end if;
	end process;
	
--process odpowiedzialny za w³aczenie/wy³aczenie trybu dziennego po klikniêciu przycisku
	process (ped_button, active, counter)
	begin
		if(ped_button = '1') then -- nacisniêcie przycisku, w³¹czenie trybu dzinnego
			active <= '1';	
		elsif(counter = 79) then -- wy³¹czenie trybu dziennego 
			active <= '0';
		end if;
	end process;
	
end Behavioral;

