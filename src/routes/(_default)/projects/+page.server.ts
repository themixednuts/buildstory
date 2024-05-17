import type { PageServerLoad } from './$types';

export const load = (async ({ locals: { supabase } }) => {
	const { data, error } = await supabase
		.from('projects')
		.select('*, profile:profiles!projects_profile_id_fkey(*)')
		.limit(10);
	if (error) console.log(error);
	return {
		projects: data,
	};
}) satisfies PageServerLoad;
