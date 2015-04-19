library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;

package sprites_package is

	-- Game sprites:
	type sprite is array( 0 to 575) of color_type; -- (12 * 12) color_type
	
	CONSTANT ship_sprite: sprite := ( 
	
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"EEE",X"EEE",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"EEE",X"EEE",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"EEE",X"EEE",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"EEE",X"EEE",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"111",X"333",X"FFF",X"EEE",X"333",X"111",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"012",X"010",X"100",X"000",X"777",X"FFF",X"FFF",X"FFF",X"FFF",X"777",X"000",X"000",X"001",X"012",X"010",X"100",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"101",X"957",X"468",X"111",X"000",X"666",X"FFF",X"FFF",X"FFF",X"FFF",X"666",X"000",X"000",X"412",X"969",X"267",X"100",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"300",X"F13",X"848",X"001",X"000",X"666",X"FFF",X"FFF",X"FFF",X"FFF",X"666",X"000",X"000",X"800",X"F35",X"347",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"300",X"F00",X"700",X"000",X"000",X"555",X"FFF",X"FFF",X"FFF",X"FFF",X"555",X"000",X"000",X"700",X"F00",X"300",X"000",X"000",X"000",X"000",
X"612",X"422",X"001",X"000",X"311",X"F66",X"622",X"000",X"666",X"AAA",X"FFF",X"FFF",X"FFF",X"FFF",X"AAA",X"666",X"000",X"622",X"F66",X"311",X"000",X"002",X"423",X"600",
X"F35",X"C54",X"012",X"000",X"333",X"FFF",X"566",X"000",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"000",X"576",X"FFF",X"333",X"000",X"015",X"C57",X"F01",
X"F00",X"B00",X"012",X"000",X"333",X"FFF",X"56B",X"007",X"FFF",X"FFF",X"FFF",X"F44",X"E44",X"FFF",X"FFF",X"EFF",X"007",X"56C",X"FFF",X"333",X"000",X"015",X"A00",X"F00",
X"F33",X"A22",X"012",X"000",X"222",X"CCF",X"68E",X"33D",X"EFF",X"FEE",X"FCC",X"F00",X"F00",X"FCC",X"FEE",X"FFF",X"33D",X"68E",X"CCF",X"223",X"000",X"022",X"A22",X"F33",
X"FFF",X"ABB",X"000",X"000",X"002",X"00A",X"89D",X"FFF",X"FFF",X"F88",X"F00",X"F00",X"F00",X"F00",X"F88",X"FFF",X"FFF",X"89E",X"00A",X"002",X"000",X"000",X"ABB",X"FFF",
X"FFF",X"BBB",X"000",X"000",X"AD1",X"88D",X"DDF",X"FFF",X"FFF",X"F88",X"F00",X"F88",X"F88",X"F00",X"F88",X"FFF",X"FFF",X"DDF",X"88D",X"DE1",X"000",X"000",X"AAA",X"FFF",
X"FFF",X"BBB",X"000",X"AAA",X"443",X"FFF",X"FFF",X"FFF",X"FFF",X"F99",X"FDD",X"FFF",X"FFF",X"FDD",X"F98",X"FFF",X"FFF",X"FFF",X"FFF",X"443",X"AAA",X"000",X"AAA",X"FFF",
X"FFF",X"999",X"000",X"AAA",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"AAA",X"000",X"999",X"FFF",
X"FFF",X"CCC",X"666",X"EEE",X"FFF",X"FFF",X"FFF",X"FFF",X"F98",X"FBB",X"FFF",X"FFF",X"FFF",X"FFF",X"FCB",X"F98",X"FFF",X"FFF",X"FFF",X"FFF",X"EEE",X"666",X"CCC",X"FFF",
X"EEE",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"E00",X"F33",X"FFF",X"FFF",X"FFF",X"FFF",X"F33",X"E00",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",
X"EEE",X"FFF",X"FFF",X"FFF",X"FFF",X"333",X"933",X"F32",X"F00",X"F77",X"FFF",X"FFF",X"FFF",X"FFF",X"F77",X"F00",X"F23",X"933",X"333",X"FFF",X"FFF",X"FFF",X"FFF",X"FFF",
X"EEE",X"FFF",X"FFF",X"CCC",X"899",X"000",X"800",X"F00",X"F00",X"D55",X"BBB",X"FFF",X"FFF",X"BBB",X"D55",X"F00",X"F00",X"700",X"000",X"899",X"CCC",X"FFF",X"FFF",X"FFF",
X"EEE",X"FFF",X"FFF",X"333",X"000",X"011",X"A57",X"F02",X"F01",X"900",X"000",X"EEE",X"EEE",X"000",X"900",X"F02",X"F02",X"A01",X"000",X"000",X"333",X"FFF",X"FFF",X"FFF",
X"FFF",X"DDD",X"555",X"111",X"000",X"000",X"312",X"501",X"500",X"200",X"000",X"FFF",X"FFF",X"000",X"200",X"501",X"501",X"300",X"000",X"000",X"111",X"555",X"CCC",X"FFF",
X"FFF",X"999",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"DDD",X"DDD",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"888",X"EEE"
	);
	
	CONSTANT alien_sprite: sprite := ( 
	
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"240",X"580",X"350",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"240",X"580",X"350",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"470",X"8D0",X"590",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"470",X"8D0",X"690",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"470",X"8D0",X"590",X"A10",X"8D0",X"000",X"000",X"000",X"000",X"000",X"000",X"7B0",X"A10",X"470",X"8D0",X"580",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"470",X"8E0",X"350",X"8D0",X"7B0",X"000",X"000",X"000",X"000",X"000",X"000",X"6A0",X"8D0",X"470",X"8E0",X"580",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"230",X"8D0",X"7B0",X"000",X"000",X"000",X"000",X"000",X"000",X"6A0",X"8D0",X"350",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"350",X"6A0",X"7B0",X"8D0",X"8D0",X"6A0",X"6A0",X"6A0",X"6A0",X"6A0",X"6A0",X"8C0",X"8D0",X"7C0",X"6A0",X"360",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"460",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"580",X"000",X"000",X"000",X"000",
X"000",X"000",X"240",X"590",X"7B0",X"8D0",X"6A0",X"240",X"350",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"460",X"240",X"590",X"8D0",X"7C0",X"590",X"350",X"000",X"000",
X"000",X"000",X"460",X"8D0",X"8D0",X"8D0",X"460",X"000",X"000",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"6A0",X"000",X"340",X"8D0",X"8D0",X"8D0",X"580",X"000",X"000",
X"350",X"350",X"590",X"8D0",X"8D0",X"8D0",X"6A0",X"350",X"460",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"470",X"350",X"590",X"8D0",X"8D0",X"8D0",X"6A0",X"350",X"350",
X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",
X"8D0",X"8D0",X"7B0",X"6B0",X"7C0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"7C0",X"6B0",X"7B0",X"8D0",X"8D0",
X"8D0",X"8D0",X"120",X"000",X"360",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"8D0",X"470",X"000",X"7B0",X"8D0",X"8D0",
X"8D0",X"8D0",X"230",X"000",X"460",X"8D0",X"8D0",X"7B0",X"7B0",X"7B0",X"7B0",X"7B0",X"7B0",X"7B0",X"7B0",X"7B0",X"7B0",X"7C0",X"8D0",X"580",X"000",X"120",X"8D0",X"8D0",
X"8D0",X"8D0",X"230",X"000",X"460",X"8D0",X"580",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"360",X"8D0",X"580",X"000",X"120",X"8D0",X"8D0",
X"8D0",X"8D0",X"240",X"000",X"470",X"8D0",X"580",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"460",X"8D0",X"590",X"000",X"120",X"8D0",X"8D0",
X"120",X"120",X"690",X"000",X"B10",X"120",X"350",X"7B0",X"7B0",X"7B0",X"6B0",X"010",X"000",X"690",X"7B0",X"7B0",X"7B0",X"460",X"120",X"E10",X"000",X"350",X"120",X"120",
X"000",X"000",X"000",X"000",X"000",X"000",X"350",X"8D0",X"8D0",X"8D0",X"8D0",X"110",X"000",X"8D0",X"8D0",X"8D0",X"8D0",X"470",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"230",X"580",X"580",X"580",X"580",X"000",X"000",X"470",X"580",X"580",X"580",X"240",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",
X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000",X"000"
	
	);


end package;