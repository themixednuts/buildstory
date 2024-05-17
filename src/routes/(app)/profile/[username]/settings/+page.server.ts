import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load = (async ({ locals: { supabase, session }, params: { username } }) => {
	if (!session?.user.id) redirect(303, `/community/${username}`);
	const { data } = await supabase.from('profiles').select().eq('id', session.user.id).maybeSingle();
	if (data && data.username !== username) redirect(303, `/community/${username}`);
	return {};
}) satisfies PageServerLoad;
