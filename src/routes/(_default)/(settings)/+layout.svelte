<script>
	import Sidenav from '$lib/components/sidenav/settings.svelte';
	import Menu from 'lucide-svelte/icons/menu';

	import { Button } from '$lib/shadcn/components/ui/button';
	import Dropdown from '$lib/components/menu';
	import Breadcrumb from '$lib/components/breadcrumbs';
	import * as Sheet from '$lib/shadcn/components/ui/sheet';
	import { onMount } from 'svelte';
	import { goto, invalidate } from '$app/navigation';
	import { StarFour } from 'phosphor-svelte';

	const { data, children } = $props();
	const { supabase, user, session } = $derived(data);

	onMount(() => {
		const { data } = supabase.auth.onAuthStateChange((_, newSession) => {
			if (!newSession) {
				/**
				 * Queue this as a task so the navigation won't prevent the
				 * triggering function from completing
				 */
				setTimeout(() => {
					goto('/auth/signin', { invalidateAll: true });
				});
			}
			if (newSession?.expires_at !== session?.expires_at) {
				invalidate('supabase:auth');
			}
		});
		return () => data.subscription.unsubscribe();
	});
</script>

<div>
	{@render children()}
</div>
