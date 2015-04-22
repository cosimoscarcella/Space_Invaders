library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
--use work.vga_package.all;

package space_invaders_package is
	
	---------------------------------
	-- Global Variable
	---------------------------------
	
	constant  MAX_X    : positive   := 512;	-- screen resolution x
	constant  MAX_Y    : positive   := 480;	-- screen resolution y
	
	constant  MAX_A_ROWS : positive   := 2;	-- numero massimo righe alieni (MAX_A_ROWS+1)
	constant  MAX_A    	: positive   := 7;	-- numero massimo alieni per riga (MAX_A+1)
	constant  MAX_B    	: positive   := 5;	-- numero massimo proiettili sullo schermo	
	
	-- grandezze in termini di BLOCK_SIZE dell'area di gioco
	constant  BOARD_COLUMNS    : positive   := 21;
	constant  BOARD_ROWS       : positive   := 17;
	constant  BLOCK_SIZE     	: integer 	 := 24;
	
	-- velocità ship, bullets e aliens, più è grande il valore più diminuisce la velocità
	constant SHIP_MOVEMENT_SPEED       		: integer := 10;
	constant BULLET_MOVEMENT_SPEED       	: integer := 15;
	constant ALIEN_MOVEMENT_SPEED   			: integer := 30;
	
	
	-- Bullet declarations 	
	type bullet_type is record
		x      	: 	integer range 0 to (MAX_X-1);
		y      	: 	integer range 0 to (MAX_Y-1);
		shooted	:	std_logic;
		hit		: std_logic;
	end record;
	
	type bullet is array (0 to MAX_B) of bullet_type;
	
	-- Ship declarations
	type ship_type is record
		x      	: 	integer range 0 to (MAX_X-1);
		y      	: 	integer range 0 to (MAX_Y-1);		
		bullets :   bullet;
	end record;	
	
	-- Alien declarations
	type alien_type is record
		x      	: 	integer range 0 to (MAX_X-1);
		y      	: 	integer range 0 to (MAX_Y-1);		
		bullets :   bullet;
		alive		: std_logic; -- indica se l'alieno è vivo o morto
	end record;	
	
	type aliens is array (0 to MAX_A) of alien_type;
	type alien_group is array (0 to MAX_A_ROWS) of aliens;
	
	-- Alien alive
	type alien_status_type is record
		alive		: std_logic; -- indica se l'alieno è vivo o morto
	end record;	
	
	type alien_status_row is array (0 to MAX_A) of alien_status_type;
	type alien_status is array (0 to MAX_A_ROWS) of alien_status_row;

	function to_bcd (bin : unsigned(7 downto 0) ) return unsigned;
	
end package;

package body space_invaders_package is 

	function to_bcd ( bin : unsigned(7 downto 0) ) return unsigned is
	variable i : integer:=0;
	variable bcd : unsigned(11 downto 0) := (others => '0');
	variable bint : unsigned(7 downto 0) := bin;

	begin
		for i in 0 to 7 loop  -- repeating 8 times.
			bcd(11 downto 1) := bcd(10 downto 0);  -- shifting the bits.
			bcd(0) := bint(7);
			bint(7 downto 1) := bint(6 downto 0);
			bint(0) :='0';


			if(i < 7 and bcd(3 downto 0) > "0100") then -- add 3 if BCD digit is greater than 4.
				bcd(3 downto 0) := bcd(3 downto 0) + "0011";
			end if;

			if(i < 7 and bcd(7 downto 4) > "0100") then -- add 3 if BCD digit is greater than 4.
				bcd(7 downto 4) := bcd(7 downto 4) + "0011";
			end if;

			if(i < 7 and bcd(11 downto 8) > "0100") then  -- add 3 if BCD digit is greater than 4.
				bcd(11 downto 8) := bcd(11 downto 8) + "0011";
			end if;

		end loop;
		return bcd;
	end to_bcd;
 
end package body;