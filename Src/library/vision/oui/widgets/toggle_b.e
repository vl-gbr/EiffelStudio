--|---------------------------------------------------------------
--|   Copyright (C) Interactive Software Engineering, Inc.	  --
--|	270 Storke Road, Suite 7 Goleta, California 93117		--
--|				   (805) 685-1006							--
--| All rights reserved. Duplication or distribution prohibited --
--|---------------------------------------------------------------

-- Toggle button.

indexing

	date: "$Date$";
	revision: "$Revision$"

class TOGGLE_B 

inherit

	BUTTON
		redefine
			add_activate_action,
			remove_activate_action,
			implementation
		end

creation

	make

feature -- Creation

	make (a_name: STRING; a_parent: COMPOSITE) is
			-- Create a toggle button with `a_name' as label,
			-- 'a_parent' as parent and call `set_default'.
		require
			Valid_name: a_name /= Void;
			Valid_parent: a_parent /= Void
		do
			depth := a_parent.depth+1;
			widget_manager.new (Current, a_parent);
			identifier:= a_name.duplicate;
			implementation:= toolkit.toggle_b (Current);
			set_default
		ensure
			Parent_set: parent = a_parent;
			Identifer_set: identifier.is_equal (a_name)
		end; 

feature -- Calllbacks (adding and removing)

	add_value_changed_action (a_command: COMMAND; argument: ANY) is
			-- Add `a_command' to the list of action to be executed when value
			-- is changed.
			-- `argument' will be passed to `a_command' whenever it is
			-- invoked as a callback.
		require
			Valid_command: a_command /= Void
		do
			implementation.add_value_changed_action (a_command, argument)
		end;

    add_activate_action (a_command: COMMAND; argument: ANY) is
			-- Add `a_command' to the list of action to be executed when 
            -- arrow button is activated.
            -- `argument' will be passed to `a_command' whenever it is
			-- invoked as a callback.
			-- (Synonym for add_value_changed_action)
		do
			add_value_changed_action (a_command, argument)
		end;

	remove_value_changed_action (a_command: COMMAND; argument: ANY) is
			-- Remove `a_command' with `argument' from the list of action 
			-- to be executed when value is changed.
		require
			valid_command: a_command /= Void
		do
			implementation.remove_value_changed_action (a_command, argument)
		end; 

    remove_activate_action (a_command: COMMAND; argument: ANY) is
			-- Remove `a_command' to the list of action to be executed when 
            -- arrow button is activated.
		do
			remove_value_changed_action (a_command, argument)
		end;

feature -- State of Toggle Button
	
	arm is
			-- Assign True to `state'.
		do
			implementation.arm
		ensure
			state_is_true: state
		end;

	disarm is
			-- Assign False to `state'.
		do
			implementation.disarm
		ensure
			state_is_false: not state
		end; 

	
feature {G_ANY, G_ANY_I, WIDGET_I, TOOLKIT}

	implementation: TOGGLE_B_I;
			-- Implementation of current toggle button

feature

	set_default is
			-- Set default values to current toggle button.
		do
		ensure then
			not state
		end;

	state: BOOLEAN is
			-- State of current toggle button.
		do
			Result := implementation.state
		end 

end
