-- Dette er modell for sjusegmentdisplayene.  De er modellert ved at man 
-- får vist ASCII-verdien av tallet/bokstaven som vises på segmentene
-- Dersom man merker disp0,..3 i waveform vieweren og velger radix ascii
-- Får man vist tall/bokstav som vist på sjusegmentene.

library IEEE;
use IEEE.std_logic_1164.all;

architecture beh of seg7model is
  signal char : std_logic_vector(3 downto 0);
begin
  display :
  process(a_n,char)
  begin
    --Benytter 'Z'(høy impendans) for å vise at et display er slukket
    disp0 <= "ZZZZ";
    disp1 <= "ZZZZ";
    disp2 <= "ZZZZ";
    disp3 <= "ZZZZ";
    if a_n(3) = '0' then
      disp3 <= char;
    end if;
    if a_n(2) = '0' then
      disp2 <= char;
    end if;
    if a_n(1) = '0' then
      disp1 <= char;
    end if;
    if a_n(0) = '0' then
      disp0 <= char;
    end if;
  end process dispLAY;

   with abcdefgdec_n(7 downto 1) select
       char <= X"0" when "0000001", --0
               X"1" when "1001111", --1
               X"2" when "0010010", --2
               X"3" when "0000110", --3
               X"4" when "1001100", --4
               X"5" when "0100100", --5
               X"6" when "0100000", --6
               X"7" when "0001111", --7
               X"8" when "0000000", --8
               X"9" when "0000100", --9
               X"A" when "0001000", --A
               X"B" when "1100000", --B
               X"C" when "0110001", --C
               X"D" when "1000010", --D
               X"E" when "0110000", --E
               X"F" when "0111000", --F
               "XXXX" when others;

end architecture beh;
