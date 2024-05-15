import type { SupabaseClient } from '@supabase/supabase-js';
import type { Database, Tables, TablesInsert, TablesUpdate } from './types';

export async function getProfileById(supabase: SupabaseClient<Database>, id: string | undefined) {
	//@ts-expect-error
	return supabase.from('profiles').select().eq('id', id).maybeSingle();
}

export async function updateProfile(
	supabase: SupabaseClient<Database>,
	profile: TablesUpdate<'profiles'>
) {
	if (!profile.id) return;
	return supabase.from('profiles').update(profile).eq('id', profile.id).select().maybeSingle();
}

// TODOS
// add & remove contributor
// upvotes
// report
// projects
// events
