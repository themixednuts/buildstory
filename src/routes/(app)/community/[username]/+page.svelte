<script lang="ts">
	const { data } = $props();
	const { data: profile, error } = $derived(data.profile);
	$inspect(error);
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
</script>

{#if profile}
	<!-- REPLACEME only for testing -->
	<Avatar.Root class="size-24">
		<Avatar.Image src={profile.avatar} />
	</Avatar.Root>
	{profile.username}

	{#each profile.projects as { title }}
		{title}
	{/each}
{/if}
