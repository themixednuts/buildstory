<script lang="ts">
	import type { Tables } from '$lib/db/types';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import { getContext } from 'svelte';

	const { profile } = getContext<{ profile: Tables<'profiles'> }>('profile');
</script>

<Avatar.Root>
	<Avatar.Image src={profile.avatar} />
</Avatar.Root>
