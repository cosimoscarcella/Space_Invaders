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
	constant BLOCK_SIZE     : integer := 10;
	
	type   state_type    is (IDLE, WAIT_FOR_READY, DRAWING);
	type   substate_type is (CLEAR_SCENE, DRAW_BOARD_OUTLINE, DRAW_SHIP, FLIP_FRAMEBUFFER);
	signal state        : state_type;
	signal substate     : substate_type;
	
	shared variable flipped : integer := 0;
	shared variable led : std_logic_vector(9 downto 0) := "0000000000";
	shared variable pos_ship     :  integer := 0;

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
			
			flipped := 0;
			pos_ship := (LEFT_MARGIN * 2);

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
--						state    <= WAIT_FOR_READY;
--						substate <= CLEAR_SCENE;
						state    <= IDLE;
						led := "0100000000";
						LEDROSSI <= led;
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
							FB_COLOR     <= COLOR_WHITE;
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
							pos_ship := pos_ship + 10;
						
							FB_COLOR     <= COLOR_RED;
							FB_X0        <= pos_ship;
							FB_Y0        <= (BOARD_ROWS-1) * BLOCK_SIZE;
							FB_X1        <= pos_ship + BLOCK_SIZE;
							FB_Y1        <= BOARD_ROWS * BLOCK_SIZE;	
							FB_FILL_RECT <= '1';
							
			
--							if (flipped = 0) then
								substate  <= FLIP_FRAMEBUFFER;
--								flipped := 0;
--							end if;

							led := "0000010000";
							LEDROSSI <= led;	

						when FLIP_FRAMEBUFFER =>
							led := "0000001000";
							LEDROSSI <= led;	
							
							FB_FLIP  <= '1';
							state    <= IDLE;	
							
					end case;
			end case;
	
		end if;
	end process;
	
end architecture;
