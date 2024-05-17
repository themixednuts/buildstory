<script lang="ts">
	import * as Avatar from '$lib/shadcn/components/ui/avatar';

	const { data } = $props();
	const { data: profile, error } = $derived(data.profile);

	$inspect(error);
</script>

{#if profile}
	<Avatar.Root class="size-24">
		<Avatar.Image src={profile.avatar} />
	</Avatar.Root>
	<div>
		{profile.username}
	</div>
	<div>
		{profile.bio}
	</div>

	{#each profile.projects as { title }}
		{title}
	{/each}
{/if}
