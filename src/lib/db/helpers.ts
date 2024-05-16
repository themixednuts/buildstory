import type { SupabaseClient } from '@supabase/supabase-js';
import type { Database, Tables, TablesInsert, TablesUpdate } from './types';

// ------------------------------        PROFILES     ---------------------------------------------
export async function getProfileById(supabase: SupabaseClient<Database>, id: string | undefined) {
	//@ts-expect-error
	return supabase.from('profiles').select().eq('id', id).maybeSingle();
}

export async function updateProfile(
	supabase: SupabaseClient<Database>,
	profile: TablesUpdate<'profiles'>
) {
	return supabase
		.from('profiles')
		.update(profile)
		.eq('id', profile.id ?? '')
		.select()
		.maybeSingle();
}

export async function searchForProfileByUsername(
	supabase: SupabaseClient<Database>,
	username: string | undefined
) {
	return supabase
		.from('profiles')
		.select()
		.eq('username', username ?? '');
}

export async function searchForProfileByEmail(
	supabase: SupabaseClient<Database>,
	email: string | undefined
) {
	return supabase
		.from('profiles')
		.select()
		.eq('email', email ?? '');
}

export async function searchForProfileByGithubUsername(
	supabase: SupabaseClient<Database>,
	username: string | undefined
) {
	return supabase
		.from('profiles')
		.select()
		.eq('github', username ?? '');
}
export async function searchForProfileByTwitterUsername(
	supabase: SupabaseClient<Database>,
	username: string | undefined
) {
	return supabase
		.from('profiles')
		.select()
		.eq('twitter', username ?? '');
}
export async function searchForProfileByTwitchUsername(
	supabase: SupabaseClient<Database>,
	username: string | undefined
) {
	return supabase
		.from('profiles')
		.select()
		.eq('twitch', username ?? '');
}
export async function searchForProfileByDiscordUsername(
	supabase: SupabaseClient<Database>,
	username: string | undefined
) {
	return supabase
		.from('profiles')
		.select()
		.eq('discord', username ?? '');
}

// TODOS
// add & remove contributor
// upvotes
// report
// projects
// events
