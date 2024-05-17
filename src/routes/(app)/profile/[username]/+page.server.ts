import { PROFILE } from '$lib/db/queries';
import { superValidate } from 'sveltekit-superforms';
import type { PageServerLoad } from './$types';
import { profilesPointsInsertSchema } from '$lib/db/schemas';
import { zod } from 'sveltekit-superforms/adapters';

export const load = (async ({ locals: { supabase }, params: { username } }) => {
	return {
		profile: await supabase.from('profiles').select(PROFILE).eq('username', username).maybeSingle(),
	};
}) satisfies PageServerLoad;

export const actions = {
	upvote: async ({ locals, request }) => {
		const { session, user } = await locals.safeGetSession();
		const form = await superValidate(request, zod(profilesPointsInsertSchema));
	},
	report: async ({ locals, request }) => {},
};
