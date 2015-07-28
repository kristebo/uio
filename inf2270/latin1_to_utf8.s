	.globl latin1_to_utf8

# Name: latin1_to_utf8
#
# Description: Convert a latin-1-encoded text to utf-8
# encoding.
#
# C-signature: void latin1_to_utf8 (unsigned char *utf, 
# unsigned char *lat)
#
# Registers:	ECX: utf
#				EDX: lat

	.text
latin1_to_utf8:
		pushl		%ebp				# Standard
		movl		%esp, %ebp			# function start.
		
		movl		8(%ebp), %ecx		# UTF-pointer -> ECX
		movl		12(%ebp), %edx		# LAT-pointer -> EDX
		
		jmp			start				# Jump to start.
		
start:
		cmpb		$0, (%edx)			# Compare the current Latin-byte to 0.
		je			finished			# If equal: jump to finished.
		
		cmpb		$128, (%edx)		# Compare the current Latin-byte to 128.
		jb			needs_one_byte		# If below: jump to needs_one_byte.
		jmp			needs_two_bytes		# Jump to needs_two_bytes (otherwise)

needs_one_byte:
		movb		(%edx), %al			# Current Latin-byte -> AL
		movb		%al, (%ecx)			# AL -> current UTF-byte
		
		incl		%ecx				# Increment UTF-pointer.
		incl		%edx				# Increment Latin-pointer.
		
		jmp			start				# Jump to start.
		
needs_two_bytes:
		movb		(%edx), %al			# Current Latin-byte -> AL
		shrb		$6, %al				# Logical right shift AL by 6 bits. XXXX XXXX becomes 0000 00XX.
		orb			$192, %al			# ((0000 00XX | 1100 0000) = 1100 00XX) -> AL
		movb		%al, (%ecx)			# AL -> current UTF-byte
		incl		%ecx				# Increment UTF-pointer.
		
		movb		(%edx), %al			# Current Latin-byte -> AL
		orb			$128, %al			# ((XXXX XXXX | 1000 0000) = 1XXX XXX) -> AL
		andb		$191, %al			# ((1XXX XXXX & 1011 1111) = 10XX XXX) -> AL
		movb		%al, (%ecx)			# AL -> current UTF-byte
		
		incl		%ecx				# Increment UTF-pointer.
		incl		%edx				# Increment Latin-pointer.
		
		jmp 		start				# Jump to start.
		
finished:
		movb		$0, (%ecx)			# 0 -> current UTF-byte (set the last UTF-byte to 0)
		
		popl		%ebp				# Standard
		ret								# return.
		
