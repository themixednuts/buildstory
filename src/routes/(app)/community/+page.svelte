<script lang="ts">
	import { Button } from '$lib/shadcn/components/ui/button';

	const { data } = $props();
	const { data: profiles, error } = $derived(data.profiles);
	$inspect(error);
	$inspect(profiles);
</script>

{#if profiles}
	<!-- REPLACEME just for testing -->
	<div class="flex gap-2">
		{#each profiles as { username, avatar }}
			<Button href="/community/{username}" size="icon">
				<img src={avatar} alt="" />
			</Button>
		{/each}
	</div>
{/if}
