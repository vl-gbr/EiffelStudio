indexing

	description:
		"A String resource with an edit field.";
	date: "$Date$";
	revision: "$Revision$"

class STRING_PREF_RES

inherit
	PREFERENCE_RESOURCE
		rename
			make as form_make
		redefine
			associated_resource, validate
		end;
	COMMAND

creation
	make

feature {NONE} -- Initialization

	make (a_resource: like associated_resource; new_parent: COMPOSITE) is
			-- Initialize Current with `a_resource' as `associated_resource',
			-- and `new_parent' as `a_parent'.
		require
			a_resource_not_void: a_resource /= Void;
			new_parent_not_void: new_parent /= Void
		do
			associated_resource := a_resource;
			a_parent := new_parent
		end

feature -- Validation

	validate is
			-- Validate Current's new value.
		do
			if text /= Void then
				if not text.text.empty then
					is_resource_valid := associated_resource.is_valid (text.text)
				else
					is_resource_valid := True
				end
			else
				is_resource_valid := True
			end
			if not is_resource_valid then
				raise_warner ("a string")
			end
		end

feature {PREFERENCE_CATEGORY} -- User Interface

	display is
			-- Display Current
		local
			txt: STRING
		do
			init;
			text.enable_resize_width;
			text.set_single_line_mode;
			txt := associated_resource.value;
			if txt /= Void then
				text.set_text (txt);
			end;
			--text.set_rows (5);
			--text.hide_horizontal_scrollbar
		end

feature {PREFERENCE_CATEGORY} -- Access

	save_value (file: PLAIN_TEXT_FILE) is
			-- Save Current.
		local
			ar: like associated_resource
		do
			ar := associated_resource
			if text = Void or else ar.value.is_equal (text.text) then
					--| text /= Void means text has been displayed
					--| and thus the user could have changed the value.
				if ar.value /= Void then
					file.putstring ("%"%"");
				else
					if ar.value @ 1 /= '%"' then
						file.putchar ('%"')
					end
					file.putstring (ar.value)
					if ar.value @ ar.value.count /= '%"' then
						file.putchar ('%"')
					end
				end
			else
				if text.text @ 1 /= '%"' then
					file.putchar ('%"')
				end
				file.putstring (text.text)
				if text.text @ text.text.count /= '%"' then
					file.putchar ('%"')
				end
			end
		end;

	is_changed: BOOLEAN is
			-- Is Current changed by the user?
		do
			if text /= Void and then not equal (associated_resource.value, text.text) then
				Result := True
			end
		end;

	modified_resource: CELL2 [RESOURCE, RESOURCE] is
			-- Modified resource
		local
			new_res: like associated_resource
		do
			!! new_res.make (associated_resource.name, text.text);
			!! Result.make (associated_resource, new_res)
		end

feature {NONE} -- Initialization

	init is
			-- Create and attach widgets to Current
		do
			form_make ("", a_parent);

			!! name_label.make (associated_resource.name, Current);
			!! text.make ("", Current);

			attach_top (name_label, 1);
			attach_bottom (name_label, 1);
			attach_left (name_label, 1);

			attach_top (text, 1);
			attach_bottom (text, 1);
			attach_left_widget (name_label, text, 5);
			attach_right (text, 1)
		end

feature {NONE} -- Properties

	associated_resource: STRING_RESOURCE;
			-- Resource Current represnts

	text: TEXT
			-- Edit box to represent Current's value

end -- class STRING_PREF_RES
