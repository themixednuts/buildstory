<script lang="ts">
	import Heading from '$lib/components/heading';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	const { data } = $props();
	const { projects } = $derived(data);
</script>

<div>
	<div class="flex flex-col items-start justify-end gap-2 border-b bg-accent/50 px-6 pb-4 pt-20">
		<Heading element="h1">Projects</Heading>
		<Heading element="h2" variant="h5" class="font-normal opacity-50"
			>See what the community has been working on.</Heading
		>
	</div>
	<ul>
		{#if projects}
			{#each projects as { title, description, logo, url, updated_at, created_at, id, profile } (id)}
				<a href="/project/123" class="flex flex-col gap-8 border-b p-8 hover:bg-accent/20">
					<div class="flex items-center justify-between">
						<div class="flex-auto">
							<div class="flex items-center gap-6">
								<Avatar.Root class="h-20 w-32 rounded-lg">
									<Avatar.Image src={logo || 'https://picsum.photos/200'} />
								</Avatar.Root>
								<div>
									<Heading element="h3" variant="h4">
										{title} by @{profile?.username}
									</Heading>
									<div class="flex items-center gap-2">
										<span class="opacity-50">{description}</span>
									</div>
									<div class="flex justify-between">
										<div class="flex items-center gap-2">
											<span class="opacity-50"
												>Updated {new Date(updated_at).toLocaleDateString()}</span
											>
											<span class="opacity-50">•</span>
											<span class="opacity-50"
												>Created {new Date(created_at).toLocaleDateString()}</span
											>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</a>
			{/each}
		{/if}
	</ul>
</div>
