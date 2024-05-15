import { PROFILE } from '$lib/db/queries.js';

export const load = async ({ locals: { supabase } }) => {
	return {
		profiles: await supabase.from('profiles').select(PROFILE),
	};
};
