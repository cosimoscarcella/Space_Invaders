library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
--use work.vga_package.all;

package space_invaders_package is
	
	---------------------------------
	-- Global Variable
	---------------------------------
	--Screen Resolution
	constant  MAX_X    : positive   := 800;
	constant  MAX_Y    : positive   := 600;
	
	constant  MAX_B    : positive   := 5; -- numero massimo proiettili sullo schermo
	constant  MAX_TICK    : positive   := 50000000; -- frequenza CPU FPGA
	constant  BULLET_MOVE_TIME    : positive   := 500000;

	type max_bullets is array (1 to MAX_B) of natural range 0 to (MAX_X-1);
	
	
	constant  BOARD_COLUMNS    : positive   := 50;
	constant  BOARD_ROWS       : positive   := 40;
	
	
	-- Ship declarations
	type ship_type is record
		x      	: 	integer range 0 to (MAX_X-1);
		y      	: 	integer range 0 to (MAX_Y-1);
		dim_x		:	positive;
		dim_y		:	positive;
	end record;	
	
end package;