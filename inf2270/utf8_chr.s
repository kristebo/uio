	.globl utf8_chr
# Name: 		utf8_chr
#
# Description: 	Search after a specified character in a UTF-8-encoded text.
#				If the specified character is found, the position of the first
#				occurrence of said character is returned. If the character
#				is nowhere to be found, -1 is returned.
#
# C-signature: int utf8_chr (unsigned char *utf, unsigned int chr);
#
# Registers:	EAX: Used for comparison
#				ECX: UTF-pointer
#				EDX: chr

	.text
utf8_chr:
		pushl		%ebp					# Standard
		movl		%esp, %ebp				# function start.

		movl		8(%ebp), %ecx			# UTF-pointer -> ECX
		movl		12(%ebp), %edx			# chr -> EDX
		
		movl		$0, %eax				# 0 -> EAX
		movl		%eax, position			# EAX -> position
		
		jmp			start					# Jump to start.
		
start:
		cmpb		$128, (%ecx)			# Compare the current UTF-byte to 128.
		jb			one_byte				# If below: jump to one_byte.
		jae			two_bytes_or_more		# If above or equal: jump to two_bytes_or_more.
		
one_byte:
		cmpb		$0, (%ecx)				# Compare the current UTF-byte to 0.
		je			not_found				# If equal: Jump to not_found
		
		movl		$0, %eax				# 0 -> EAX
		movb		(%ecx), %al				# Current UTF-byte -> AL
		cmpl		%edx, %eax				# Compare the current character to input chr.
		je			found					# If equal: jump to found.
		
		incl		%ecx					# Increment UTF-pointer.
		incl		position				# Increment position.
		
		jmp			start					# Jump to start.
		
two_bytes_or_more:
		cmpb		$224, (%ecx)			# Compare the current UTF-byte to 224.
		jae			three_bytes_or_more		# If above or equal: jump to three_bytes_or_more.
		
		movl		$0, %eax				# 0 -> EAX		
		movb		(%ecx), %ah				# Current UTF-byte -> AH
		andb		$31, %ah				# ((00011111 & 110XXXXX) = 000XXXXX) -> AH
		
		incl		%ecx					# Increment UTF-pointer.
		movb		(%ecx), %al				# Current UTF-byte -> AL
		andb		$63, %al				# ((00111111 & 10XXXXXX) = 00XXXXXX) -> AL
		shlb		$2, %al					# AL now becomes XXXXXX00.
		shrw		$2, %ax					# AX now becomes 00000XXX XXXXXXXX.
		
		cmpl		%edx, %eax				# Compare the current character to input chr.
		je			found					# If equal: jump to found.
		
		incl		%ecx					# Increment UTF-pointer.
		incl		position				# Increment position.
		
		jmp			start					# Jump to start.
		
three_bytes_or_more:
		cmpb		$240, (%ecx)			# Compare the current UTF-byte to 240.
		jae			four_bytes				# If above or equal: jump to four_bytes.
		
		movl		$0, %eax				# 0 -> EAX
		movb		(%ecx), %ah				# Current UTF-byte -> AH.
		andb		$15, %ah				# ((00001111 & 1110XXXX) = 0000XXXX) -> AH					
		shll		$8, %eax				# EAX now becomes 00000000 0000XXXX 00000000 00000000.		
		
		incl		%ecx					# Increment UTF-pointer.
		movb		(%ecx), %ah				# Current UTF-byte -> AH.								
		andb		$63, %ah				# ((00111111 & 10XXXXXX) = 00XXXXXX) -> AH                  
		shlb		$2, %ah					# AH now becomes XXXXXX00.									
		shrl		$2, %eax				# EAX now becomes 00000000 000000XX XXXXXXXX 00000000	.	
		
		incl		%ecx					# Increment UTF-pointer.
		movb		(%ecx), %al				# Current UTF-byte -> AL									
		andb		$63, %al				# ((00111111 & 10XXXXXX) = 00XXXXXX) -> AL					
		shlb		$2, %al					# AL now becomes XXXXXX00.									
		shrl		$2, %eax				# EAX now becomes 00000000 00000000 XXXXXXXX XXXXXXXX.
		
		cmpl		%edx, %eax				# Compare the current character to input chr.
		je			found					# If equal: jump to found.
		
		incl		%ecx					# Increment UTF-pointer.
		incl		position				# Increment position.
		
		jmp			start					# Jump to start.
		
four_bytes:
		movl		$0, %eax				# 0 -> EAX
		movb		(%ecx), %ah				# Current UTF-byte -> AH
		andb		$7, %ah					# ((00000111 & 11110XXX) = 00000XXX) -> AH
		
		incl		%ecx					# Increment UTF-pointer.
		movb		(%ecx), %al				# Current UTF-byte -> AL.
		andb		$63, %al				# ((00111111 & 10XXXXXX) = 00XXXXXX) -> AL	
		shlb		$2, %al					# AL now becomes XXXXXX00.
		shll		$6, %eax				# EAX now becomes 00000000 0000000X XXXXXXXX 00000000   5
		
		incl		%ecx					# Increment UTF-pointer.
		movb		(%ecx), %al				# Current UTF-byte -> AL
		andb		$63, %al				# ((00111111 & 10XXXXXX) = 00XXXXXX) -> AL	
		shlb		$2, %al					# AL now becomes XXXXXX00.
		shll		$6, %eax				# EAX now becomes 00000000 0XXXXXXX XXXXXXXX 00000000
		
		incl		%ecx					# Increment UTF-pointer.
		movb		(%ecx), %al				# Current UTF-byte -> AL
		andb		$63, %al				# ((00111111 & 10XXXXXX) = 00XXXXXX) -> AL	
		shlb		$2, %al					# AL now becomes XXXXXX00.
		shrl		$2, %eax				# EAX now becomes 00000000 000XXXXX XXXXXXXX XXXXXXXX.
		
		cmpl		%edx, %eax				# Compare the current character to input chr.
		je			found					# If equal: jump to found
		
		incl		%ecx					# Increment UTF-pointer.
		incl		position				# Increment position.
		
		jmp			start					# Jump to start.
		
found:
		movl		position, %eax			# position -> EAX
		
		popl		%ebp					# Standard
		ret									# return.

not_found:
		movl		$-1, %eax				# -1 -> EAX
		
		popl		%ebp					# Standard
		ret									# return.
		
		
		
	.data
position:	.long 0							# A long with initial value 0, used to indicate the position
		
