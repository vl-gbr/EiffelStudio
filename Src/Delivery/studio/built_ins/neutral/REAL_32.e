class REAL_32

feature -- Comparison

	is_less alias "<" (other: REAL_32): BOOLEAN
			-- Is `other' greater than current real?
		do
			Result := Precursor (other)
		end

feature -- Status report

	is_nan: BOOLEAN
		do
			Result := Precursor
		end

	is_negative_infinity: BOOLEAN
		do
			Result := Precursor
		end

	is_positive_infinity: BOOLEAN
		do
			Result := Precursor
		end
		
feature -- Conversion

	truncated_to_integer: INTEGER_32
			-- Integer part (same sign, largest absolute
			-- value no greater than current object's)
		do
			Result := Precursor
		end

	truncated_to_integer_64: INTEGER_64
			-- Integer part (same sign, largest absolute
			-- value no greater than current object's)
		do
			Result := Precursor
		end

	to_double: REAL_64
			-- Current seen as a double
		do
			Result := Precursor
		end

	ceiling_real_32: REAL_32
			-- Smallest integral value no smaller than current object
		do
			Result := Precursor
		end

	floor_real_32: REAL_32
			-- Greatest integral value no greater than current object
		do
			Result := Precursor
		end

feature -- Basic operations

	plus alias "+" (other: REAL_32): REAL_32
			-- Sum with `other'
		do
			Result := Precursor (other)
		end

	minus alias "-" (other: REAL_32): REAL_32
			-- Result of subtracting `other'
		do
			Result := Precursor (other)
		end

	product alias "*" (other: REAL_32): REAL_32
			-- Product by `other'
		do
			Result := Precursor (other)
		end

	quotient alias "/" (other: REAL_32): REAL_32
			-- Division by `other'
		do
			Result := Precursor (other)
		end

	power alias "^" (other: REAL_64): REAL_64
			-- Current real to the power `other'
		do
			Result := Precursor (other)
		end

	identity alias "+": REAL_32
			-- Unary plus
		do
			Result := Precursor
		end

	opposite alias "-": REAL_32
			-- Unary minus
		do
			Result := Precursor
		end

feature -- Output

	out: STRING
			-- Printable representation of real value
		do
			Result := Precursor
		end

end
