class BREAKABLE_STONE 

inherit

	UNFILED_STONE
		redefine
			header
		end;
	SHARED_DEBUG;
	INTERFACE_W

creation

	make
	
feature -- making

	make (e_feature: E_FEATURE; break_index: INTEGER) is
		require
			not_feature_i_void: e_feature /= Void
		do
			routine := e_feature;
			index := break_index
		end; -- make
 
feature

	routine: E_FEATURE;
			-- Associated routine

	index: INTEGER;
			-- Breakpoint index in `routine'

feature -- dragging

	sign: STRING is 
			-- Textual representation of the breakable mark.
			-- Two different representations whether the breakpoint
			-- is set or not.
		local
			status: APPLICATION_STATUS
		do
			status := Application.status;
			if 
				status /= Void and status.is_stopped and 
				status.is_at (routine, index) 
			then
					-- Execution stopped at that point.
				Result := "->|"
			elseif Application.is_breakpoint_set (routine, index) then
				Result := "|||"
			else
				Result := ":::"
			end
		end; -- sign

	origin_text: STRING is ":::";

	stone_type: INTEGER is do Result := Breakable_type end;
 
	stone_name: STRING is do Result := l_Showstops end;

	signature: STRING is "";
 
	header: STRING is "Stop point";

	click_list: ARRAY [CLICK_STONE] is do end;

	icon_name: STRING is
		do
			Result := signature
		end;
 
	clickable: BOOLEAN is
			-- Is Current an element with recorded structures information?
		do
			Result := False
		end

end -- class BREAKABLE_STONE
