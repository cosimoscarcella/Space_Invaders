library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.space_invaders_package.all;

entity Space_Invaders_Controller is
	port
	(
		CLOCK           : in  std_logic;
		RESET_N         : in  std_logic;
		TIME_10MS       : in  std_logic;
		
		BUTTON_LEFT     : in  std_logic;
		BUTTON_RIGHT    : in  std_logic;
		BUTTON_SHOT     : in  std_logic;
		ALIEN_SPEED_IN	 : in  std_logic;
		START				 : in  std_logic;

		-- Connections with Tetris_Datapath
		SHIP_LEFT			: out  std_logic;			
		SHIP_RIGHT			: out  std_logic;									
		SHOOT					: out  std_logic;
		BULLET_TIME			: out  std_logic;
		ALIEN_TIME			: out  std_logic;
		GAME_STATUS			: in  std_logic;
		
		-- Connections with View
		REDRAW          			: out std_logic;
		SPLASH_SCREEN_ENABLE		: out std_logic
	);

end entity;


architecture RTL of Space_Invaders_Controller is
	
	signal   ship_time_to_next_move    	: integer range 0 to SHIP_MOVEMENT_SPEED-1;
	signal   ship_move_time            	: std_logic;
	
	signal   bullet_time_to_next_move   : integer range 0 to BULLET_MOVEMENT_SPEED-1;
	signal   bullet_move_time           : std_logic;		
	
	signal   alien_time_to_next_move    : integer;
	signal   alien_move_time            : std_logic;	
	
	shared variable shoot_counter       : integer := 0;
	shared variable shoot_pressed       : std_logic := '0';

begin   

	-- Gestisce il movimento temporizzato del proiettile
	bulletTimedMove : process(CLOCK, RESET_N)
		begin
			if (RESET_N = '0') then
				
				bullet_time_to_next_move  <= 0;
				bullet_move_time          <= '0';
			
			elsif(rising_edge(CLOCK) and START = '0') then
				
				bullet_move_time <= '0';
				
				if (TIME_10MS = '1') then
					if (bullet_time_to_next_move = 0) then
						bullet_time_to_next_move  <= BULLET_MOVEMENT_SPEED - 1;
						bullet_move_time          <= '1';
					else
						bullet_time_to_next_move  <= bullet_time_to_next_move - 1;
					end if;
				end if;
				
				BULLET_TIME  <= bullet_move_time;
				
			end if;
	end process;


	-- Gestisce il movimento temporizzato della navicella
	shipTimedMove : process(CLOCK, RESET_N)
	begin
		if (RESET_N = '0') then
			
			ship_time_to_next_move  <= 0;
			ship_move_time          <= '0';
		
		elsif(rising_edge(CLOCK) and START = '0') then
			
			ship_move_time <= '0';
			
			if (TIME_10MS = '1') then
				if (ship_time_to_next_move = 0) then
					ship_time_to_next_move  <= SHIP_MOVEMENT_SPEED - 1;
					ship_move_time          <= '1';
				else
					ship_time_to_next_move  <= ship_time_to_next_move - 1;
				end if;
			end if;
		end if;
	end process;
	
	
	-- Gestisce il movimento temporizzato degli alieni
	alienTimedMove : process(CLOCK, RESET_N)
	variable speed : integer;
	begin
		if (RESET_N = '0') then
			
			alien_time_to_next_move  <= 0;
			alien_move_time          <= '0';
			speed := ALIEN_MOVEMENT_SPEED;
		
		elsif(rising_edge(CLOCK) and START = '0') then
		
			if (ALIEN_SPEED_IN = '1' and speed >= 15) then
				speed := speed - 4;
			end if;
			alien_move_time <= '0';
			
			if (TIME_10MS = '1') then
				if (alien_time_to_next_move = 0) then
					alien_time_to_next_move  <= speed - 1;
					alien_move_time          <= '1';
				else
					alien_time_to_next_move  <= alien_time_to_next_move - 1;
				end if;
			end if;
			
			ALIEN_TIME  <= alien_move_time;
		end if;
	end process;
	
	
	-- Gestione Pressione Buttons
	Controller_RTL : process (CLOCK, RESET_N)
	variable stop_game : std_logic := '0';
	begin
		if (RESET_N = '0') then
			
			SHOOT      		 <= '0';
			SHIP_LEFT       <= '0';
			SHIP_RIGHT      <= '0';	
			REDRAW          <= '0';	
			stop_game := '0';
		
		elsif(rising_edge(CLOCK) and START = '0') then
			
			SHOOT       	 <= '0';
			SHIP_LEFT       <= '0';
			SHIP_RIGHT      <= '0';	
			REDRAW          <= '0';	
			
			if(GAME_STATUS = '0') then
			
				if (ship_move_time = '1') then
				
					if (BUTTON_LEFT = '1') then
						SHIP_LEFT <= '1';
						REDRAW  <= '1';
						
					elsif (BUTTON_RIGHT = '1') then
						SHIP_RIGHT <= '1';
						REDRAW <= '1';
						
					end if;
				end if;
				
				
				if (BUTTON_SHOT = '1' and shoot_pressed = '0') then
					
					SHOOT <= '1';				
					shoot_pressed := '1';	
				
				elsif (BUTTON_SHOT = '0') then
					shoot_pressed := '0';
				
				elsif (START = '1') then
					SPLASH_SCREEN_ENABLE <= '1';
					REDRAW  <= '1';
				
				end if;
				
				if (TIME_10MS = '1' and shoot_pressed = '1') then
					shoot_counter := shoot_counter + 1;
				end if;
				
				if (shoot_counter = 50) then 
					shoot_pressed := '0';
					shoot_counter := 0;
				end if;
				
				if (bullet_move_time = '1') then	
					REDRAW  <= '1';
				end if;	
				
			else
				-- Se il gioco è finito lancio il REDRAW una sola volta per disegnare la screen
				if(stop_game = '0') then
					REDRAW  <= '1';
					stop_game := '1';
				end if;			
			
			end if;				
		
		end if;
	end process;
		
end architecture;
