	.globl utf8_to_latin1

# Name: utf8_to_latin1
#
# Description: 	Convert a UTF-8-encoded text to Latin-1-encoding, insofar it is 
#			   	possible. If a character cannot be converted, a question mark is
#			  	inserted instead.
#
# C-signature: void utf8_to_latin1 (unsigned char *lat, unsigned char *utf);
#
# Registers:	ECX: Latin-1
#				EDX: UTF-8

	.text
utf8_to_latin1:
		pushl		%ebp					# Standard
		movl		%esp, %ebp				# function start.
		
		movl		8(%ebp), %ecx			# Latin-pointer -> ECX
		movl		12(%ebp), %edx			# UTF-pointer -> EDX
		
start:
		cmpb		$128, (%edx)			# Compare the current UTF-byte to 128.
		jb			one_byte				# If below: jump to one_byte.
		jmp			two_bytes_or_more		# Jump to two_bytes_or_more (otherwise).
		
one_byte:
		cmpb		$0, (%edx)				# Compare the current  byte to 0
		je			finished				# If equal: jump to finished.

		movb		(%edx), %al				# Current UTF-byte -> AL
		movb		%al, (%ecx)				# AL -> current Latin-byte
		
		incl		%ecx					# Increment Latin-pointer.
		incl		%edx					# Increment UTF-pointer.
		
		jmp			start					# Jump to start.
		
two_bytes_or_more:
		cmpb		$224, (%edx)			# Compare the current UTF-byte to 224.
		jae			three_bytes_or_more		# If above or equal: jump to three_bytes_or_more.
		
		movl		$0, %eax				# 0 -> EAX		
		movb		(%edx), %ah				# Current UTF-byte -> AH
		andb		$31, %ah				# ((00011111 & 110XXXXX) = 000XXXXX) -> AH
		
		incl		%edx					# Increment UTF-pointer.
		movb		(%edx), %al				# Current UTF-byte -> AL
		andb		$63, %al				# ((00111111 & 10XXXXXX) = 00XXXXXX) -> AL
		shlb		$2, %al					# AL now becomes XXXXXX00.
		shrw		$2, %ax					# AX now becomes 00000XXX XXXXXXXX
		cmpw		$256, %ax				# Compare AX to 256.
		jae			two_bytes_impossible	# If above or equal: jump to two_bytes_impossible.
		
		decl 		%edx					# Decrement UTF-pointer.
		movb		(%edx), %al				# Current UTF-byte -> AL
		shlb		$6, %al					# AL now becomes XX000000.
		movb		%al, (%ecx)				# AL -> Current Latin-byte
		
		incl		%edx					# Increment UTF-pointer.
		movb		(%edx), %al				# Current UTF-byte -> AL
		andb		$63, %al				# ((00111111 & 10XXXXXX) = 00XXXXXX) -> AL
		orb			%al, (%ecx)				# ((00XXXXXX | XX000000) = XXXXXXXX) -> current Latin-byte
		
		incl		%ecx					# Increment Latin-pointer.
		incl		%edx					# Increment UTF-pointer.
		
		jmp			start					# Jump to start.
		
two_bytes_impossible:
		movb		$63, (%ecx)				# 63 -> current Latin-byte (63 is the decimal value of '?')
		
		incl		%ecx					# Increment Latin-pointer.
		
		incl		%edx					# Increment UTF-pointer.
		incl		%edx					# Increment UTF-pointer.
		
		jmp 		start					# Jump to start.
		
three_bytes_or_more:
		cmpb		$240, (%edx)			# Compare the current UTF-byte to 240
		jae			four_bytes				# If above or equal: jump to four_bytes.
		
		movb		$63, (%ecx)				# 63 -> current Latin-byte (63 is the decimal value of '?')
		
		incl		%ecx					# Increment Latin-pointer.
		
		incl		%edx					# Increment UTF-pointer.
		incl		%edx					# Increment UTF-pointer.
		incl		%edx					# Increment UTF-pointer.
		
		jmp			start					# Jump to start.
		
four_bytes:
		movb		$63, (%ecx)				# 63 -> current Latin-byte (63 is the decimal value of '?')
		
		incl		%ecx					# Increment Latin-pointer.
		
		incl		%edx					# Increment UTF-pointer.
		incl		%edx					# Increment UTF-pointer.
		incl		%edx					# Increment UTF-pointer.
		incl		%edx					# Increment UTF-pointer.
		
		jmp			start					# Jump to start.
		
finished:
		movb		$0,(%ecx)				# 0 -> current Latin-byte (set last byte to 0)

		popl		%ebp					# Standard
		ret									# return.
		
