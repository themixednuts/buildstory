<script lang="ts">
	import Heading from '$lib/components/heading';

	const { data } = $props();
	const { data: profiles, error } = $derived(data.profiles);
	$inspect(error);
	$inspect(profiles);
</script>

<div>
	<div class="flex flex-col items-start justify-end gap-2 border-b bg-accent/50 px-6 pb-4 pt-20">
		<Heading element="h1">Community</Heading>
		<Heading element="h2" variant="h5" class="font-normal opacity-50"
			>See all community members. Probably just a test.</Heading
		>
	</div>
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
