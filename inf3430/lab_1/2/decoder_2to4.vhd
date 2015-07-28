library IEEE;
use IEEE.std_logic_1164.all;

entity DECODER_2TO4 is
	port(
		en		:	in 	std_logic;						        -- enable input
		inp	  :	in 	std_logic_vector(1 downto 0);	-- 2-bit input bus
		outp	:	out	std_logic_vector(3 downto 0)	-- 4-bit output bus
	);
end DECODER_2TO4;

-- The architecture below specifies the behavioural internals of the black 
-- box that is the entity above. The decoder is active-low (i.e. it 
-- decodes when the enable ('en') input signal is low), and the
-- corresponding output to a given input is inverted (i.e. input "00"
-- gives 0th bit equal to '0', while the rest is '1', etc.).
architecture BEHAVIOURAL of DECODER_2TO4 is
begin
	process (en, inp)
	begin
		case en is
			when '1' => outp <= "1111";
			when '0' =>
				case inp is
					when "00" 	=> outp <= "1110";
					when "01" 	=> outp <= "1101";
					when "10" 	=> outp <= "1011";
					when "11" 	=> outp <= "0111";
					when others	=> outp <= "XXXX";
				end case;
			when others =>
				outp <= "XXXX";
		end case;
	end process;
end BEHAVIOURAL;

