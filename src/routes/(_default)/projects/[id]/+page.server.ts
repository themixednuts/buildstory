import type { PageServerLoad } from './$types';

export const load = (async ({ params: { id }, locals: { supabase } }) => {
	return {
		project: await supabase
			.from('projects')
			.select('*, profile:profiles!projects_profile_id_fkey(*)')
			.eq('id', id)
			.maybeSingle(),
	};
}) satisfies PageServerLoad;
