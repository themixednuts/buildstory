<script lang="ts">
	import * as Profile from '$lib/components/profile';
	const { data } = $props();
	const { user } = $derived(data);
	const profile = $derived(user.profile?.data);
</script>

{#if profile}
	<Profile.Root {profile}>
		<Profile.Avatar />
	</Profile.Root>
{/if}
