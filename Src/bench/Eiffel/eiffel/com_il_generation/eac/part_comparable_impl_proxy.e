indexing
	description: "Implemented `PartComparable' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	PART_COMPARABLE_IMPL_PROXY

inherit
	PART_COMPARABLE_INTERFACE

	ECOM_QUERIABLE

creation
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_part_comparable_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Status Report

	last_error_code: INTEGER is
			-- Last error code.
		do
			Result := ccom_last_error_code (initializer)
		end

	last_error_description: STRING is
			-- Last error description.
		do
			Result := ccom_last_error_description (initializer)
		end

	last_error_help_file: STRING is
			-- Last error help file.
		do
			Result := ccom_last_error_help_file (initializer)
		end

	last_source_of_exception: STRING is
			-- Last source of exception.
		do
			Result := ccom_last_source_of_exception (initializer)
		end

feature -- Basic Operations

	x_infix_ge (other: PART_COMPARABLE_INTERFACE): BOOLEAN is
			-- No description available.
			-- `other' [in].  
		local
			other_item: POINTER
			a_stub: ECOM_STUB
		do
			if other /= Void then
				if (other.item = default_pointer) then
					a_stub ?= other
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				other_item := other.item
			end
			Result := ccom_x_infix_ge (initializer, other_item)
		end

	x_infix_gt (other: PART_COMPARABLE_INTERFACE): BOOLEAN is
			-- No description available.
			-- `other' [in].  
		local
			other_item: POINTER
			a_stub: ECOM_STUB
		do
			if other /= Void then
				if (other.item = default_pointer) then
					a_stub ?= other
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				other_item := other.item
			end
			Result := ccom_x_infix_gt (initializer, other_item)
		end

	x_infix_le (other: PART_COMPARABLE_INTERFACE): BOOLEAN is
			-- No description available.
			-- `other' [in].  
		local
			other_item: POINTER
			a_stub: ECOM_STUB
		do
			if other /= Void then
				if (other.item = default_pointer) then
					a_stub ?= other
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				other_item := other.item
			end
			Result := ccom_x_infix_le (initializer, other_item)
		end

	x_infix_lt (other: PART_COMPARABLE_INTERFACE): BOOLEAN is
			-- No description available.
			-- `other' [in].  
		local
			other_item: POINTER
			a_stub: ECOM_STUB
		do
			if other /= Void then
				if (other.item = default_pointer) then
					a_stub ?= other
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				other_item := other.item
			end
			Result := ccom_x_infix_lt (initializer, other_item)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_part_comparable_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_x_infix_ge (cpp_obj: POINTER; other: POINTER): BOOLEAN is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"](ecom_ISE_Reflection_CodeGenerator::PartComparable *): EIF_BOOLEAN"
		end

	ccom_x_infix_gt (cpp_obj: POINTER; other: POINTER): BOOLEAN is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"](ecom_ISE_Reflection_CodeGenerator::PartComparable *): EIF_BOOLEAN"
		end

	ccom_x_infix_le (cpp_obj: POINTER; other: POINTER): BOOLEAN is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"](ecom_ISE_Reflection_CodeGenerator::PartComparable *): EIF_BOOLEAN"
		end

	ccom_x_infix_lt (cpp_obj: POINTER; other: POINTER): BOOLEAN is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"](ecom_ISE_Reflection_CodeGenerator::PartComparable *): EIF_BOOLEAN"
		end

	ccom_delete_part_comparable_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"]()"
		end

	ccom_create_part_comparable_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"]():EIF_POINTER"
		end

	ccom_last_error_code (cpp_obj: POINTER): INTEGER is
			-- Last error code
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_last_error_description (cpp_obj: POINTER): STRING is
			-- Last error description
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"]():EIF_REFERENCE"
		end

	ccom_last_error_help_file (cpp_obj: POINTER): STRING is
			-- Last error help file
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"]():EIF_REFERENCE"
		end

	ccom_last_source_of_exception (cpp_obj: POINTER): STRING is
			-- Last source of exception
		external
			"C++ [ecom_ISE_Reflection_CodeGenerator::PartComparable_impl_proxy %"ecom_ISE_Reflection_CodeGenerator_PartComparable_impl_proxy.h%"]():EIF_REFERENCE"
		end

end -- PART_COMPARABLE_IMPL_PROXY

