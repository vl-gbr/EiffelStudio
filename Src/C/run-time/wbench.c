/*
	description: "Workbench primitives."
	date:		"$Date$"
	revision:	"$Revision$"
	copyright:	"Copyright (c) 1985-2010, Eiffel Software."
	license:	"GPL version 2 see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"Commercial license is available at http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Runtime.
			
			Eiffel Software's Runtime is free software; you can
			redistribute it and/or modify it under the terms of the
			GNU General Public License as published by the Free
			Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Runtime is distributed in the hope
			that it will be useful,	but WITHOUT ANY WARRANTY;
			without even the implied warranty of MERCHANTABILITY
			or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Runtime; if not,
			write to the Free Software Foundation, Inc.,
			51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
*/

/*
doc:<file name="wbench.c" header="eif_wbench.h" version="$Id$" summary="Workbench primitives">
*/

#ifdef WORKBENCH

#include "eif_portable.h"
#include "rt_wbench.h"
#include "eif_project.h"
#include "rt_macros.h"
#include "rt_malloc.h"
#include "eif_garcol.h"
#include "rt_struct.h"
#include "rt_hashin.h"
#include "eif_except.h"
#include "eif_interp.h"
#include "eif_plug.h"
#include "rt_gen_conf.h"
#include "rt_assert.h"

/* The following functions implement the access to object features and 
 * attributes in workbench mode, they are:
 * `wfeat (static_type, feature_id, dyn_type)'
 * `wpfeat (origin, offset, dyn_type)'
 * `wfeat_inv (static_type, feature_id, name, object)'
 * `wpfeat_inv (origin, offset, name, object)'
 * `wcreat (static_type, feature_id, dyn_type)'
 * `wpcreat (origin, offset, dyn_type)'
 * `wattr (static_type, feature_id, dyn_type)'
 * `wpattr (origin, offset, dyn_type)'
 * `wattr_inv (static_type, feature_id, name, object)'
 * `wpattr_inv (origin, offset, name, object)'
 * `wtype_gen (static_type, feature_id, object)'
 * `wptype_gen (origin, offset, object)'
 * `wttype_gen (static_type, feature_id, dftype)'
 * `wtptype_gen (origin, offset, dftype)'
 * `wdisp (dyn_type)'
 */

#ifdef EIF_ASSERTIONS
/*
doc:	<routine name="rt_is_call_allowed" return_type="int" export="private">
doc:		<summary>Figure out if a call to an Eiffel routine is allowed. Typically it is allowed when no GC synchronization point is happening.</summary>
doc:		<return>Return 0 if not allowed, Non-zero otherwise</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Uses per thread data.</synchronization>
doc:	</routine>
*/
rt_private int rt_is_call_allowed(void)
{
#ifdef EIF_THREADS
		/* If they are 2 or more running threads, then we need to make
		 * sure that Eiffel code is not executing on the non GC thread. */
	if (eif_is_gc_collecting >= EIF_GC_STARTED_WITH_MULTIPLE_RUNNING_THREADS) {
		RT_GET_CONTEXT
			/* If we are the thread running the GC cycle, then we are ok. */
		return (gc_thread_status == EIF_THREAD_GC_RUNNING);
	} else {
		return 1;
	}
#else
	return 1;
#endif
}
#endif

/*
doc:	<routine name="wfeat2" return_type="EIF_REFERENCE_FUNCTION" export="public">
doc:		<summary>Function pointer associated to Eiffel feature of routine ID `routine_id' applied to an object of dynamic type `dtype'.</summary>
doc:		<param name="routine_id" type="int">Routine ID of feature being called.</param>
doc:		<param name="dtype" type="EIF_TYPE_INDEX">Dynamic type of object on which feature will be applied.</param>
doc:		<return>Function pointer</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Uses per thread data.</synchronization>
doc:	</routine>
*/
rt_public EIF_REFERENCE_FUNCTION wfeat2(int routine_id, EIF_TYPE_INDEX dtype)
{
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	CBodyId(body_id,routine_id,dtype);		/* Get the body index */

	if (egc_frozen [body_id])
		return egc_frozen[body_id];			 /* Frozen feature */
	else {
			/* Slow part. */
		EIF_GET_CONTEXT
		IC = melt[body_id];				 /* Position byte code to interpret */
		return pattern[MPatId(body_id)].toi;
	}
}

/*
doc:	<routine name="wfeat2_inv" return_type="EIF_REFERENCE_FUNCTION" export="public">
doc:		<summary>Function pointer associated to a qualified call to Eiffel feature of routine ID `routine_id' and name `name' applied to an object `object'.</summary>
doc:		<param name="routine_id" type="int">Routine ID of feature being called.</param>
doc:		<param name="name" type="char *">Name of feature being called.</param>
doc:		<param name="object" type="EIF_REFERENCE">Object on which feature will be applied.</param>
doc:		<return>Function pointer</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Uses per thread data.</synchronization>
doc:	</routine>
*/
rt_public EIF_REFERENCE_FUNCTION wfeat2_inv(int routine_id, char *name, EIF_REFERENCE object)
{
	if (object == NULL) {			/* Void reference check */
			/* Raise an exception for a feature named `name' applied
			 * to a void reference. */
		eraise(name, EN_VOID);
		return NULL;
	} else {
		return wfeat2(routine_id, Dtype(object));
	}
}

/*
doc:	<routine name="wattr2" return_type="long" export="public">
doc:		<summary>Attribute offset of attribute of routine ID `routine_id' applied to an object of dynamic type `dtype'.</summary>
doc:		<param name="routine_id" type="int">Routine ID of attribute being accessed.</param>
doc:		<param name="dtype" type="EIF_TYPE_INDEX">Dynamic type of object on which attribute will be accessed.</param>
doc:		<return>Offset</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Uses per thread data.</synchronization>
doc:	</routine>
*/
rt_public long wattr2(int routine_id, EIF_TYPE_INDEX dtype)
{
	long offset;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	CAttrOffs(offset,routine_id,dtype);
	return (offset);
}

/*
doc:	<routine name="wattr2_inv" return_type="long" export="public">
doc:		<summary>Attribute offset of a qualified access to attribute of routine ID `routine_id' and name `name' applied to an object `object'. Note that invariants are not currently checked (code simply commented out for future reference).</summary>
doc:		<param name="routine_id" type="int">Routine ID of attribute being accessed.</param>
doc:		<param name="name" type="char *">Name of feature being called.</param>
doc:		<param name="object" type="EIF_REFERENCE">Object on which attribute will be accessed.</param>
doc:		<return>Offset</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Uses per thread data.</synchronization>
doc:	</routine>
*/
rt_public long wattr2_inv (int routine_id, char *name, EIF_REFERENCE object)
{
	if (object == NULL) {			/* Void reference check */
			/* Raise an exception for a feature named `name' applied
			 * to a void reference. */
		eraise(name, EN_VOID);
		return 0;
	} else {
		/* Invariants are not currently checked on attribute access. */
 /* 
		if (~in_assertion & WASC(Dtype(object)) & CK_INVARIANT) {
			in_assertion = ~0;
			chkinv(object);
			in_assertion = 0;
		}
 */
		return wattr2(routine_id, Dtype(object));
	}
}

/*
doc:	<routine name="wtype2_gen" return_type="EIF_TYPE_INDEX" export="public">
doc:		<summary>Type of a generic feature of routine ID `routine_id' applied to an object of dynamic type `dtype' and full dynamic type `dftype'.</summary>
doc:		<param name="routine_id" type="int">Routine ID of generic feature for which we need to know the type in the context of `dftype'.</param>
doc:		<param name="dtype" type="EIF_TYPE_INDEX">Dynamic type ID of generic feature where type will be looked up.</param>
doc:		<param name="dftype" type="EIF_TYPE_INDEX">Full Dynamic type ID of generic feature where type will be looked up.</param>
doc:		<return>Function pointer</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Uses per thread data.</synchronization>
doc:	</routine>
*/
rt_public EIF_TYPE_INDEX wtype2_gen(int routine_id, EIF_TYPE_INDEX dtype, EIF_TYPE_INDEX dftype)
{
	struct rout_info info;
	struct desc_info *desc;
	EIF_TYPE_INDEX *gen_type;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());
	info = eorg_table[routine_id];
	desc = &(((desc_tab[info.origin])[dtype])[info.offset]);
	gen_type = desc->gen_type;

	if (gen_type) {
		return eif_compound_id (dftype, gen_type);
	} else {
		return desc->type;
	}
}

rt_public EIF_REFERENCE_FUNCTION wfeat(int static_type, int32 feature_id, int dyn_type)
{
	/* Function pointer associated to Eiffel feature of feature id
	 * `feature_id' accessed in Eiffel static type `static_type' to
	 * apply on an object of dynamic type `dyn_type'.
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	int32 rout_id;
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	nstcall = 0;								/* No invariant check */
	rout_id = Routids(static_type)[feature_id]; /* Get the routine id */
	CBodyId(body_id,rout_id,dyn_type);		/* Get the body index */

	if (egc_frozen [body_id])
		return egc_frozen[body_id];			 /* Frozen feature */
	else {
		IC = melt[body_id];				 /* Position byte code to interpret */
		return pattern[MPatId(body_id)].toi;
	}
}

rt_public EIF_REFERENCE_FUNCTION wpfeat(int32 origin, int32 offset, int dyn_type)
{
	/* Function pointer associated to Eiffel feature of origin class
	 * `origin', identified by `offset' in that class, and to
	 * apply on an object of dynamic type `dyn_type'.
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	nstcall = 0;								/* No invariant check */
	body_id = desc_tab[origin][dyn_type][offset].body_index;

	if (egc_frozen [body_id])
		return egc_frozen[body_id];			 /* Frozen feature */
	else {
		IC = melt[body_id];				 /* Position byte code to interpret */
		return pattern[MPatId(body_id)].toi;
	}
}

rt_public EIF_REFERENCE_FUNCTION wfeat_inv(int static_type, int32 feature_id, char *name, EIF_REFERENCE object)
{
	/* Function pointer associated to Eiffel feature of feature id
	 * `feature_id' accessed in Eiffel static type `static_type' to
	 * apply on an object `object'.
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	int dyn_type;
	int32 rout_id;
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	if (object == NULL)			/* Void reference check */
			/* Raise an exception for a feature named `name' applied
			 * to a void reference. */
		eraise(name, EN_VOID);

	nstcall = 1;						/* Invariant check on */

	dyn_type = Dtype(object);

	rout_id = Routids(static_type)[feature_id];
	CBodyId(body_id,rout_id,dyn_type);

	if (egc_frozen [body_id])
		return egc_frozen[body_id];			 /* Frozen feature */
	else {
		IC = melt[body_id];	
		return pattern[MPatId(body_id)].toi;
	}
}

rt_public EIF_REFERENCE_FUNCTION wpfeat_inv(int32 origin, int32 offset, char *name, EIF_REFERENCE object)
{
	/* Function pointer associated to Eiffel feature of origin class
	 * `origin', identified by `offset' in that class, and to
	 * apply on an object `object'
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	int dyn_type;
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	if (object == NULL)			/* Void reference check */
			/* Raise an exception for a feature named `name' applied
			 * to a void reference. */
		eraise(name, EN_VOID);

	nstcall = 1;						/* Invariant check on */

	dyn_type = Dtype(object);

	body_id = desc_tab[origin][dyn_type][offset].body_index;

	if (egc_frozen [body_id])
		return egc_frozen[body_id];
	else {
		IC = melt[body_id];	
		return pattern[MPatId(body_id)].toi;
	}
}

rt_public EIF_REFERENCE_FUNCTION wcreat(int static_type, int32 feature_id, int dyn_type)
{
	/* Function pointer associated to Eiffel feature of feature id
	 * `feature_id' accessed in Eiffel static type `static_type' to
	 * apply on an object of dynamic type `dyn_type'.
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	int32 rout_id;
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	nstcall = -1; /* Invariant check at the end */
	rout_id = Routids(static_type)[feature_id]; /* Get the routine id */
	CBodyId(body_id,rout_id,dyn_type);		/* Get the body index */

	if (egc_frozen [body_id])
		return egc_frozen[body_id];			 /* Frozen feature */
	else {
		IC = melt[body_id];				 /* Position byte code to interpret */
		return pattern[MPatId(body_id)].toi;
	}
}

rt_public EIF_REFERENCE_FUNCTION wpcreat(int32 origin, int32 offset, int dyn_type)
{
	/* Function pointer associated to Eiffel feature of origin class
	 * `origin', identified by `offset' in that class, and to
	 * apply on an object of dynamic type `dyn_type'.
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	nstcall = -1; /* Invariant check at the end */
	body_id = desc_tab[origin][dyn_type][offset].body_index;

	if (egc_frozen [body_id])
		return egc_frozen[body_id];			 /* Frozen feature */
	else {
		IC = melt[body_id];				 /* Position byte code to interpret */
		return pattern[MPatId(body_id)].toi;
	}
}


rt_public void wexp(int static_type, int32 feature_id, int dyn_type, EIF_REFERENCE object)
{
	/* Call the creation of the expanded.
	 * with static type `stype', dynamic type `dtype' and
	 * feature id `fid'. Apply the function to `object'
	 */
	EIF_GET_CONTEXT
	int32 rout_id;
	BODY_INDEX body_id;
	unsigned char *OLD_IC;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	nstcall = 0;								/* No invariant check */
	rout_id = Routids(static_type)[feature_id]; /* Get the routine id */
	CBodyId(body_id,rout_id,dyn_type);		/* Get the body index */

	OLD_IC = IC;								/* Save old IC */
	if (egc_frozen [body_id])
		((void (*)(EIF_REFERENCE)) (egc_frozen[body_id])) (object);	/* Frozen feature */
									/* Call frozen creation routine */
	else {
		IC = melt[body_id];	 		/* Position byte code to interpret */
		((void (*)(EIF_REFERENCE)) (pattern[MPatId(body_id)].toi)) (object);
									/* Call melted creation routine */
	}
	IC = OLD_IC;					/* Restore old IC.
									 * This was needed if expanded objects
									 * had expanded objects (which has a
									 * creation routine which in turn call
									 * the interpreter) so that 
									 * the IC was return to the previous 
									 * state.
									 */
}

rt_public void wpexp(int32 origin, int32 offset, int dyn_type, EIF_REFERENCE object)
{
	/* Call the creation of the expanded (when precompiled).
	 * with origin class `origin', dynamic type `dtype' and
	 * offset `offset'. Apply the function to `object'
	 */

	EIF_GET_CONTEXT
	BODY_INDEX body_id;
	unsigned char *OLD_IC;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	nstcall = 0;								/* No invariant check */
	body_id = desc_tab[origin][dyn_type][offset].body_index;

	OLD_IC = IC;								/* Save old IC */
	if (egc_frozen [body_id])
		((void (*)(EIF_REFERENCE)) (egc_frozen[body_id])) (object);	/* Frozen feature */
									/* Call frozen creation routine */
	else {
		IC = melt[body_id];	 		/* Position byte code to interpret */
		((void (*)(EIF_REFERENCE)) (pattern[MPatId(body_id)].toi)) (object);
									/* Call melted creation routine */
	}
	IC = OLD_IC;					/* Restore old IC.
									 * This was needed if expanded objects
									 * had expanded objects (which has a
									 * creation routine which in turn call
									 * the interpreter) so that 
									 * the IC was return to the previous 
									 * state.
									 */
}

rt_public long wattr(int static_type, int32 feature_id, int dyn_type)
{
	/* Offset of attribute of feature id `feature_id' in the class of
	 * static type `static_type' in an object of dynamic type `dyn_type'.
	 * Return a long integer.
	 */

	int32 rout_id;
	long offset;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	rout_id = Routids(static_type)[feature_id];
	CAttrOffs(offset,rout_id,dyn_type);
	return (offset);
}

rt_public long wpattr(int32 origin, int32 offset, int dyn_type)
{
	/* Offset of precompiled attribute of origin class `origin', identified by
	 * `offset' in that class, in an object of dynamic type `dyn_type'.
	 * Return a long integer.
	 */

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	return (desc_tab[origin][dyn_type][offset].offset);
}

rt_public long wattr_inv (int static_type, int32 feature_id, char *name, EIF_REFERENCE object)
				
				 
			 	/* Target object */
		   		/* Feature name to apply */
{
	/* Offset of attribute of feature id `feature_id' in the class of
	 * static type `static_type' in an object `object'.
	 * Return a long integer.
	 * Invariants are currently not being checked on attribute access
	 * The code is commented out -- FRED
	 */

	int dyn_type;
	int32 rout_id;
	long offset;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	if (object == NULL)			/* Void reference check */
			/* Raise an exception for a feature named `fname' applied
			 * to a void reference. */
		eraise(name, EN_VOID);

	dyn_type = Dtype(object);

/*
 * Commented out by FRED
 *
 *	if (~in_assertion & WASC(dyn_type) & CK_INVARIANT) {
 *		in_assertion = ~0;
 *		chkinv(object);
 *		in_assertion = 0;
 *	}
 */

	rout_id = Routids(static_type)[feature_id];
	CAttrOffs(offset,rout_id,dyn_type);
	return (offset);
}

rt_public long wpattr_inv (int32 origin, int32 offset, char *name, EIF_REFERENCE object)
					 
			 	/* Target object */
		   		/* Feature name to apply */
{
	/* Offset of precompiled attribute of origin class `origin', identified by
	 * `offset' in that class, in an object `object'.
	 * Return a long integer.
	 * Invariants are currently not being checked on attribute access
	 * The code is commented out -- FRED
	 */

	int dyn_type;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	if (object == NULL)			/* Void reference check */
			/* Raise an exception for a feature named `fname' applied
			 * to a void reference. */
		eraise(name, EN_VOID);

	dyn_type = Dtype(object);

/*
 * Commented out by FRED
 *
 *	if (~in_assertion & WASC(dyn_type) & CK_INVARIANT) {
 *		in_assertion = ~0;
 *		chkinv(object);
 *		in_assertion = 0;
 *	}
 */

	return (desc_tab[origin][dyn_type][offset].offset);
}

/* GENERIC CONFORMANCE */

rt_public EIF_TYPE_INDEX wtype_gen(EIF_TYPE_INDEX static_type, int32 feature_id, EIF_REFERENCE object)
{
	/* Type of a generic feature of routine id `rout_id' in the class of
	 * dynamic type of `object'. Replaces formal generics by actual gen.
	 * of `object'. Returns an integer.
	 */ 

	int32   rout_id;
	EIF_TYPE_INDEX dyn_type;
	EIF_TYPE_INDEX type, *gen_type;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	dyn_type = Dtype(object);
	rout_id = Routids(static_type)[feature_id];
	CGENFeatType(type,gen_type,rout_id,dyn_type);

	if (gen_type) {
		return eif_compound_id (Dftype (object), gen_type);
	} else {
		return type;
	}
}

rt_public EIF_TYPE_INDEX wttype_gen(EIF_TYPE_INDEX static_type, int32 feature_id, EIF_TYPE_INDEX dftype)
{
	/* Type of a generic feature of routine id `rout_id' in the class of
	 * dynamic type `dftype'. Replaces formal generics by actual gen.
	 * Returns an integer.
	 */ 

	int32   rout_id;
	EIF_TYPE_INDEX dyn_type;
	EIF_TYPE_INDEX type, *gen_type;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	dyn_type = To_dtype(dftype);
	rout_id = Routids(static_type)[feature_id];
	CGENFeatType(type,gen_type,rout_id,dyn_type);

	if (gen_type) {
		return eif_compound_id (dftype, gen_type);
	} else {
		return type;
	}
}

rt_public EIF_TYPE_INDEX wptype_gen(EIF_TYPE_INDEX static_type, int32 origin, int32 offset, EIF_REFERENCE object)
{
	/* Type of a generic feature of routine identified by `offset' in 
	 * its origin class `origin' and to be applied on `object'. Replaces
	 * formal generics by actual gen. of `object'. Returns an integer.
	 */ 

	struct desc_info *desc;
	EIF_TYPE_INDEX dyn_type;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	dyn_type = Dtype(object);
	desc = desc_tab[origin][dyn_type] + offset;

	if (desc->gen_type) {
		return eif_compound_id (Dftype (object), desc->gen_type);
	} else {
		return desc->type;
	}

}

rt_public EIF_TYPE_INDEX wtptype_gen(EIF_TYPE_INDEX static_type, int32 origin, int32 offset, EIF_TYPE_INDEX dftype)
{
	/* Type of a generic feature of routine identified by `offset' in 
	 * its origin class `origin' and to be applied on type `dftype'. Replaces
	 * formal generics by actual gen. Returns an integer.
	 */ 

	struct desc_info *desc;
	EIF_TYPE_INDEX dyn_type;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	dyn_type = To_dtype(dftype);
	desc = desc_tab[origin][dyn_type] + offset;

	if (desc->gen_type) {
		return eif_compound_id (dftype, desc->gen_type);
	} else {
		return desc->type;
	}

}

rt_public EIF_REFERENCE_FUNCTION wdisp(EIF_TYPE_INDEX dyn_type)
{
	/* Function pointer associated to Eiffel feature of routine id
	 * `routine_id' accessed in Eiffel dynamic type `dyn_type'.
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	BODY_INDEX body_id;

	CHECK("GC running", rt_is_call_allowed());

	nstcall = 0;								/* No invariant check */
	CBodyId(body_id,egc_disp_rout_id,dyn_type);	/* Get the body index */

	if (egc_frozen [body_id])
		return egc_frozen[body_id];		 /* Frozen feature */
	else {
		IC = melt[body_id];	 /* Position byte code to interpret */
		return pattern[MPatId(body_id)].toi;
	}
}

rt_public EIF_REFERENCE_FUNCTION wcopy(EIF_TYPE_INDEX dyn_type)
{
	/* Function pointer associated to Eiffel feature of routine id
	 * `routine_id' accessed in Eiffel dynamic type `dyn_type'.
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	nstcall = 0;								/* No invariant check */
	CBodyId(body_id,egc_copy_rout_id,dyn_type);	/* Get the body index */

	if (egc_frozen [body_id])
		return egc_frozen[body_id];		 /* Frozen feature */
	else {
		IC = melt[body_id];	 /* Position byte code to interpret */
		return pattern[MPatId(body_id)].toi;
	}
}

rt_public EIF_REFERENCE_FUNCTION wis_equal(EIF_TYPE_INDEX dyn_type)
{
	/* Function pointer associated to Eiffel feature of routine id
	 * `routine_id' accessed in Eiffel dynamic type `dyn_type'.
	 * Return a function pointer.
	 */
	EIF_GET_CONTEXT
	BODY_INDEX body_id;

	CHECK("Not called by non-GC thread", rt_is_call_allowed());

	nstcall = 0;								/* No invariant check */
	CBodyId(body_id,egc_is_equal_rout_id,dyn_type);	/* Get the body index */

	if (egc_frozen [body_id])
		return egc_frozen[body_id];		 /* Frozen feature */
	else {
		IC = melt[body_id];	 /* Position byte code to interpret */
		return pattern[MPatId(body_id)].toi;
	}
}

/*
doc:	<attribute name="desc_tab" return_type="struct desc_info ***" export="shared">
doc:		<summary>Global descriptor table. Initialization of the run-time feature call structures. The central call structure is called `desc_tab'. It contains one entry per class (NOT class type) and it is indexed by class id (not the toplogical id). The entry for a given class is a table of descriptor pointers, and is indexed by "dynamic" class type ids.</summary>
doc:		<access>Read/Write once</access>
doc:		<indexing>[class_id, dtype, offset]</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized once through `put_desc' called from InitXXX routines generated in *d.c files</synchronization>
doc:	</attribute>
*/
rt_shared struct desc_info ***desc_tab;


struct bounds { 			/* Structure used to record min/max dtypes */
	EIF_TYPE_INDEX min;
	EIF_TYPE_INDEX max;
};

/*
doc:	<attribute name="bounds_tab" return_type="struct bounds *" export="private">
doc:		<summary>Bounds of the various classes. Temporary structures used for the construction of the global descriptor table. The `bounds_tab' table contains the bounds (minimum and maximum dynamic class type ids) for each class in the system.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since only used during initialization.</synchronization>
doc:	</attribute>
*/
rt_private struct bounds *bounds_tab;

/*
doc:	<attribute name="desc_fill" return_type="char" export="public">
doc:		<summary>Flag for descriptor table initialization. Is it an actual insertion or do we wish to compute the size?</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since only done during application initialization.</synchronization>
doc:	</attribute>
*/
rt_public char desc_fill;				/* Flag for descriptor table initialization */

struct mdesc {				/* Structure used to record melted descriptor */
	struct desc_info *desc_ptr;
	EIF_TYPE_INDEX origin;
	EIF_TYPE_INDEX type;
};

/*
doc:	<attribute name="mdesc_tab" return_type="struct mdesc *" export="private">
doc:		<summary>Temporary table of melted descriptors. When byte code is read, all new descriptors are recorded, so that they can be properly inserted during insertion pass.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since only done during application initialization.</synchronization>
doc:	</attribute>
*/
rt_private struct mdesc *mdesc_tab;

/*
doc:	<attribute name="mdesc_count" return_type="int" export="private">
doc:		<summary>Number of melted descriptors in `mdesc_tab'.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since only done during application initialization.</synchronization>
doc:	</attribute>
*/
rt_private int mdesc_count;

/*
doc:	<attribute name="mdesc_tab_size" return_type="int" export="private">
doc:		<summary>Size of `mdesc_tab'.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since only done during application initialization.</synchronization>
doc:	</attribute>
*/
rt_private int mdesc_tab_size;

#define MDESC_INC 10000		/* Size increment of `mdesc_tab' */

/* The following routines are used to build the
 * global descriptor table
 */

rt_public void init_desc(void)
{
	/* Initialize the temporary structures used for the
	 * construction of the global descriptor table.
	 */

	int i;
	struct bounds def;

	def.max = 0;
	def.min = (EIF_TYPE_INDEX) ccount;
	bounds_tab = (struct bounds *) cmalloc (sizeof(struct bounds) * (ccount + 1));	
	if (bounds_tab == NULL)
		enomem(MTC_NOARG);
	mdesc_tab = (struct mdesc *) cmalloc (sizeof(struct mdesc) * MDESC_INC);
	if (mdesc_tab == NULL)
		enomem(MTC_NOARG);
	mdesc_tab_size = MDESC_INC;
	mdesc_count = 0;
	
	for (i=0;i<=ccount;i++)
		bounds_tab[i] = def;

	desc_fill = 0;
	egc_tabinit();
}

rt_public void put_desc(struct desc_info *desc_ptr, int org, int dtype)
{
	/* If the `desc_fill' flag is set to false, simply record
	 * the value of the dynamic type (to compute the size
	 * of the global descriptor table)
	 * Otherwise (the global table has already been allocated)
	 * insert the descriptor pointer at the appropriate location
	 */

	struct bounds *b;

	if (0 != desc_fill) {
		(desc_tab[org])[dtype] = desc_ptr;
	} else {
		b = bounds_tab+org;
		b->min = (EIF_TYPE_INDEX) (dtype < b->min ? dtype : b->min);
		b->max = (EIF_TYPE_INDEX) (dtype > b->max ? dtype : b->max);
	}
}

rt_public void put_mdesc(struct desc_info *desc_ptr, int org, int dtype)
{
	/* Record melted descriptor:
	 * Record the value of the dynamic type (to compute the size
	 * of the global descriptor table)
	 * Save the descripotr pointer and the insertion information
	 * for the actual insertion.
	 */
	struct bounds *b;
	struct mdesc md;

	/* Update bounds table */

	if (0 == desc_fill) {
		b = bounds_tab+org;
		b->min = (EIF_TYPE_INDEX) (dtype < b->min ? dtype : b->min);
		b->max = (EIF_TYPE_INDEX) (dtype > b->max ? dtype : b->max);
	}	

	/* Insert information in temporary table */

	if (mdesc_tab_size <= mdesc_count) { 
		mdesc_tab_size += MDESC_INC;
		mdesc_tab = (struct mdesc *) 
				crealloc ((char *) mdesc_tab, sizeof(struct mdesc) * mdesc_tab_size);	
		if ((struct mdesc *) 0 == mdesc_tab)
			enomem(MTC_NOARG);
	}

	md.desc_ptr = desc_ptr;
	md.origin = (EIF_TYPE_INDEX) org;
	md.type = (EIF_TYPE_INDEX) dtype;

	mdesc_tab[mdesc_count++] = md;
}

rt_public void create_desc(void)
{
	struct bounds *b;
	int i;
	struct desc_info **tab;
	struct mdesc *mdesc_ptr;
	int size;

		/* Allocation of the global descriptor table. */
	desc_tab = (struct desc_info ***) cmalloc (sizeof(struct desc_info **) * (ccount + 1));
	if (!desc_tab) {
		enomem(MTC_NOARG);
	}

	/* Allocation of the subtables
	 * and insertion
	 */

	for (i=0;i<=ccount;i++) {
		b = bounds_tab+i;
		size = b->max - b->min + 1;
		if (size > 0) {
			tab = (struct desc_info **) cmalloc (size * sizeof(struct desc_info *));
			if (!tab) {
				enomem(MTC_NOARG);
			}
				/* The hack of the century */
			desc_tab[i] = tab - b->min; 
		}
	}


	/* Free temporary structure */
	eif_rt_xfree((char *) bounds_tab);

	/* Actually fill the call structure */

	desc_fill = 1;
	egc_tabinit();

	/* Fill the call structures with the melted descriptors */

	for(i=0;i<mdesc_count;i++) {
		mdesc_ptr = &(mdesc_tab[i]);
		(desc_tab[mdesc_ptr->origin])[mdesc_ptr->type] 
				= mdesc_ptr->desc_ptr;
	}

	/* Free temporary structure */
	eif_rt_xfree((char *) mdesc_tab);
}


rt_public void eif_invoke_test_routine (EIF_REFERENCE obj, int body_id)
{

	EIF_GET_CONTEXT

	EIF_REFERENCE_FUNCTION rout;

	nstcall = 1;                                            /* Invariant check on */

        if (egc_frozen [body_id])
                rout = egc_frozen[body_id];                      /* Frozen feature */
        else {
                IC = melt[body_id];
                rout = pattern[MPatId(body_id)].toi;
        }
	
	(FUNCTION_CAST(void, (EIF_REFERENCE)) rout)(obj);
}


#endif

/*
doc:</file>
*/
