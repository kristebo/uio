	.globl utf8_get
# Name: 		utf8_get
#
# Description: 	Retrieve a UTF-character at a specified position. If the
#				input position is negative, or otherwise invalid, -1 is
#				returned.
#
# C-signature: int utf8_get (unsigned char *utf, int pos) 
#
# Registers:	ECX: UTF-pointer
#				EDX: pos

	.text
utf8_get:
		pushl		%ebp					# Standard
		movl		%esp, %ebp				# function start.

		movl		8(%ebp), %ecx			# UTF-pointer -> ECX
		movl		12(%ebp), %edx			# pos -> EDX
		
		movl		$0, %eax				# 0 -> EAX
		movl		%eax, counter			# EAX -> counter
		
		cmpl		$0, %edx				# Compare input position to 0.
		jb			error					# If below: jump to error (negative input position).
		
		jmp 		start					# Jump to start.

start:
		cmpl		%edx, counter			# Compare counter to input position.
		ja			finished				# If above: jump to finished.		
		
		cmpb		$128, (%ecx)			# Compare the current UTF-byte to 128
		jb			one_byte				# If below: jump to one_byte.
		jmp			two_bytes_or_more		# Jump to two_bytes_or_more.
		
one_byte:
		cmpb		$0, (%ecx)				# Compare the current UTF-byte to 0
		je			error					# If equal: jump to error.

		movl		$0, %eax				# 0 -> EAX
		movb		(%ecx), %al				# Current UTF-byte -> AL
		 
		incl		%ecx					# Increment UTF-pointer.
		incl		counter					# Increment counter.
		 
		jmp 		start					# Jump to start.
		 
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
		
		# So now we have AX = 000XXXXX XXXXXX00, and one final step remains
		shrw		$2, %ax					# AX now becomes 00000XXX XXXXXXXX
		
		incl		%ecx					# Increment UTF-pointer.
		incl		counter					# Increment counter.
		
		jmp start							# Jump to start.
		
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
		shrl		$2, %eax				# EAX now becomes 00000000 00000000 XXXXXXXX XXXXXXXX, and we're done.
		
		incl		%ecx					# Increment UTF-pointer.
		incl		counter					# Increment counter.
		
		jmp 		start					# Jump to start.
		
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
		shrl		$2, %eax				# EAX now becomes 00000000 000XXXXX XXXXXXXX XXXXXXXX, and we're done.
		
		incl		%ecx					# Increment UTF-pointer.
		incl		counter					# Increment counter.
		
		jmp			start					# Jump to start.					

finished:
		popl		%ebp					# Standard
		ret									# return.
		
error:
		movl		$-1, %eax				# -1 -> EAX
		
		popl		%ebp					# Standard
		ret									# return.
		
	.data
counter:	.long 0							# A long with initial value 0.
		
