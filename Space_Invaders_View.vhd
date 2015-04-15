library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.space_invaders_package.all;
use work.vga_package.all;


entity Space_Invaders_View is
	port
	(
		CLOCK          : in  std_logic;
		RESET_N        : in  std_logic;
		
		REDRAW         : in  std_logic;
		
		SHIP_IN			: in ship_type;
		ALIEN_IN			: in alien_group;
		ALIEN_STATE		: in alien_status;
		
		FB_READY       : in  std_logic;
		FB_CLEAR       : out std_logic;
		FB_FLIP        : out std_logic;
		FB_DRAW_RECT   : out std_logic;
		FB_DRAW_LINE   : out std_logic;
		FB_FILL_RECT   : out std_logic;
		FB_COLOR       : out color_type;
		FB_X0          : out xy_coord_type;
		FB_Y0          : out xy_coord_type;
		FB_X1          : out xy_coord_type;
		FB_Y1          : out xy_coord_type;
		
		LEDROSSI				: out  std_logic_vector(9 downto 0)
		
	);
end entity;


architecture RTL of Space_Invaders_View is
	constant LEFT_MARGIN    : integer := 4;
	constant TOP_MARGIN     : integer := 4;
	
	
	type   state_type    is (IDLE, WAIT_FOR_READY, DRAWING);
	type   substate_type is (CLEAR_SCENE, DRAW_BOARD_OUTLINE, DRAW_SHIP, DRAW_BULLET, DRAW_ALIENS, FLIP_FRAMEBUFFER);
	signal state        : state_type;
	signal substate     : substate_type;
	
	shared variable flipped : integer := 0;
	shared variable led : std_logic_vector(9 downto 0) := "0000000000";
	shared variable i : integer := 0;
	shared variable j : integer := 0;
	shared variable k : integer := 0;

begin
	
	
	
	process(CLOCK, RESET_N)
	begin
	
		if (RESET_N = '0') then
			state             <= WAIT_FOR_READY;
			substate          <= CLEAR_SCENE;
			FB_CLEAR          <= '0';
			FB_DRAW_RECT      <= '0';
			FB_DRAW_LINE      <= '0';
			FB_FILL_RECT      <= '0';
			FB_FLIP           <= '0';
			i 						:=  0 ;
			
			
			flipped := 0;
		

		elsif (rising_edge(CLOCK)) then
		
			FB_CLEAR       <= '0';
			FB_DRAW_RECT   <= '0';
			FB_DRAW_LINE   <= '0';
			FB_FILL_RECT   <= '0';
			FB_FLIP        <= '0';
			
			
	
			case (state) is
				when IDLE =>
					if (REDRAW = '1') then
						state    <= WAIT_FOR_READY;
						substate <= CLEAR_SCENE;
						led := "1000000000";
						LEDROSSI <= led;
						
					else -- REDRAW = '0'
						state    <= IDLE;
--						if (SHIP_IN.x /= 0) then
--								led := "1111111111";
--								LEDROSSI <= led;							
--						else
								led := "0100000000";
								LEDROSSI <= led;
--						end if;
						
					end if;
					
					
				when WAIT_FOR_READY =>
					if (FB_READY = '1') then
						state <= DRAWING;
						led := "0010000000";
						LEDROSSI <= led;
					end if;
				
				when DRAWING =>
					state <= WAIT_FOR_READY;
				
					case (substate) is
						when CLEAR_SCENE =>
							FB_COLOR     <= COLOR_BLACK;
							FB_CLEAR     <= '1';
							substate     <= DRAW_BOARD_OUTLINE;
							
							
							led := "0001000000";
							LEDROSSI <= led;						
							
						
						when DRAW_BOARD_OUTLINE => -- bordo schermata di gioco
							FB_COLOR     <= COLOR_BLUE;
							FB_X0        <= LEFT_MARGIN;
							FB_Y0        <= TOP_MARGIN;
							FB_X1        <= LEFT_MARGIN + (BOARD_COLUMNS * BLOCK_SIZE);
							FB_Y1        <= TOP_MARGIN + (BOARD_ROWS * BLOCK_SIZE);						
							FB_DRAW_RECT <= '1';
							substate     <= DRAW_SHIP;		
							
							led := "0000100000";
							LEDROSSI <= led;	
							
						when DRAW_SHIP =>	
							
							FB_COLOR     <= COLOR_RED;
							FB_X0        <= (LEFT_MARGIN * 2) + SHIP_IN.x;
							FB_Y0        <= (BOARD_ROWS-1) * BLOCK_SIZE;
							FB_X1        <= (LEFT_MARGIN * 2) + SHIP_IN.x + BLOCK_SIZE;
							FB_Y1        <= BOARD_ROWS * BLOCK_SIZE;	
							FB_FILL_RECT <= '1';	

							substate  <= DRAW_BULLET;

							led := "0000010000";
							LEDROSSI <= led;	
							
						when DRAW_BULLET =>	
						
							--for i in 0 to MAX_B loop
							
--							if (i = 0) then
--								FB_COLOR     <= COLOR_YELLOW;							
--							elsif (i = 1) then
--								FB_COLOR     <= COLOR_GREEN;	
--							elsif (i = 2) then
--								FB_COLOR     <= COLOR_BLUE;
--							elsif (i = 3) then
--								FB_COLOR     <= COLOR_CYAN;
--							elsif (i = 4) then
---							FB_COLOR     <= COLOR_MAGENTA;
--							end if;
							
							if (i = 0) then
								FB_COLOR     <= COLOR_WHITE;							
							elsif (i = 1) then
								FB_COLOR     <= COLOR_GREEN;	
							elsif (i = 2) then
								FB_COLOR     <= COLOR_BLUE;
							elsif (i = 3) then
								FB_COLOR     <= COLOR_CYAN;
							elsif (i = 4) then
								FB_COLOR     <= COLOR_MAGENTA;
							end if;
							
							
							if (SHIP_IN.bullets(i).shooted = '1' and SHIP_IN.bullets(i).hit = '0') then
								FB_X0        <= (LEFT_MARGIN * 2) + SHIP_IN.bullets(i).x + (BLOCK_SIZE/3);
								FB_Y0        <= SHIP_IN.bullets(i).y;
								FB_X1        <= (LEFT_MARGIN * 2) + SHIP_IN.bullets(i).x + 4;
								FB_Y1        <= SHIP_IN.bullets(i).y + BLOCK_SIZE;	
								FB_FILL_RECT <= '1';						
							end if;
							
							i := i + 1;
							led := "0000001000";
							LEDROSSI <= led;	
							
							if (i >= MAX_B) then
								i := 0;
								substate <= DRAW_ALIENS;
							end if;
							
						when DRAW_ALIENS =>
						 
							if(ALIEN_STATE(k)(j).alive = '1') then
								FB_COLOR     <= COLOR_CYAN;
								FB_X0        <= (LEFT_MARGIN * 2) + ALIEN_IN(k)(j).x;
								FB_Y0        <=  ALIEN_IN(k)(j).y;
								FB_X1        <= (LEFT_MARGIN * 2) + ALIEN_IN(k)(j).x + BLOCK_SIZE;
								FB_Y1        <=  ALIEN_IN(k)(j).y + BLOCK_SIZE;	
								FB_FILL_RECT <= '1';	
							end if;
							
							j := j + 1;
							if (j > MAX_A) then
								j := 0;
								k := k + 1;
								if (k > MAX_A_ROWS) then
									k := 0;
									substate <= FLIP_FRAMEBUFFER;
								end if;
							end if;

							led := "0000010000";
							LEDROSSI <= led;	
						
						when FLIP_FRAMEBUFFER =>
							led := "0000000100";
							LEDROSSI <= led;	
							
							FB_FLIP  <= '1';
							state    <= IDLE;	
							
					end case;
			end case;
	
		end if;
	end process;
	
end architecture;
