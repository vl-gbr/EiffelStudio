indexing
	description: "Demo for regular polygons."
	Id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

class
	REGULAR_POLYGON_ITEM

inherit
	FIGURE_ITEM

creation
	make

feature {NONE} -- Initialization

	make (par: EV_TREE_ITEM_HOLDER) is
			-- Create the item and the demo that
			-- goes with it.
		do
			make_with_title (par, "EV_REGULAR_POLYGON")
			set_example_path("demo_items/regular_polygon_item.e")
			set_class_path("ev_regular_polygon")

		end



		

feature -- Access

	figure: EV_REGULAR_POLYGON is
		local
			pt: EV_POINT
		do
			!! Result.make
			Result.path.set_line_width (2)
			!! pt.set (150, 150)
			Result.set_center (pt)
			Result.set_radius (100)
			Result.set_orientation (30)
			Result.set_number_of_sides (13)
		end

end -- class REGULAR_POLYGON_ITEM

--|----------------------------------------------------------------
--| EiffelVision Tutorial: Example for the ISE EiffelVision library.
--| Copyright (C) 1986-1998 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

