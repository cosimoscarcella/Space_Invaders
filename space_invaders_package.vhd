library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
--use work.vga_package.all;

package space_invaders_package is
	
	---------------------------------
	-- Global Variable
	---------------------------------
	
	constant  MAX_X    : positive   := 512;
	constant  MAX_Y    : positive   := 480;
	
	constant  MAX_B    : positive   := 5; -- numero massimo proiettili sullo schermo
	constant  MAX_TICK    : positive   := 50000000; -- frequenza CPU FPGA
	constant  BULLET_MOVE_TIME    : positive   := 500000;

	
	
	
	constant  BOARD_COLUMNS    : positive   := 50;
	constant  BOARD_ROWS       : positive   := 40;
	
	--constant BLOCK_SIZE     : integer := 10;
	constant BLOCK_SIZE     : integer := (MAX_X) / BOARD_COLUMNS;
	
		-- Bullet declarations 	
	type bullet_type is record
		x      	: 	integer range 0 to (MAX_X-1);
		y      	: 	integer range 0 to (MAX_Y-1);
		dim_x		:	positive;
		dim_y		:	positive;
		shooted	:	std_logic;
	end record;
	
	type bullet is array (0 to MAX_B) of bullet_type;
	
	-- Ship declarations
	type ship_type is record
		x      	: 	integer range 0 to (MAX_X-1);
		y      	: 	integer range 0 to (MAX_Y-1);
		
		bullets :   bullet;
		
		dim_x		:	positive;
		dim_y		:	positive;
	end record;	
	
	
	
end package;