<script lang="ts">
	import { PageHeader } from '$lib/components/page-header';

	const { data } = $props();
	const { data: profiles } = $derived(data.profiles);
</script>

<div>
	<PageHeader title="Community" subtitle="See all community members. Probably just a test." />
	{#if profiles}
		<div class="flex flex-col">
			{#each profiles as { username, avatar }, idx}
				<a
					class="inline-flex items-center gap-2 border-b px-6 py-3 hover:bg-accent/20 hover:underline"
					href="/profile/{username}"
				>
					<img class="h-10 w-10 rounded-full" src={avatar} alt="" />
					<div>{username}</div>
				</a>
			{/each}
		</div>
	{/if}
</div>
