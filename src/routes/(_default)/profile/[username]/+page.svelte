<script lang="ts">
	import { Heading } from '$lib/components/heading';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import * as Tabs from '$lib/shadcn/components/ui/tabs';
	import { DiscordLogo, GithubLogo, TwitchLogo, TwitterLogo, XLogo } from 'phosphor-svelte';

	const { data } = $props();
	const { data: profile, error } = $derived(data.profile);

	$inspect(error);
</script>

<main>
	{#if profile}
		<header class="flex items-end border-b bg-accent/30 p-8">
			<div class="flex flex-auto items-center gap-8">
				<Avatar.Root class="size-32 rounded-lg">
					<Avatar.Image src={profile.avatar} />
				</Avatar.Root>
				<div>
					<Heading element="h1" variant="h2">
						{profile.name}
					</Heading>
					<div class="flex flex-col justify-center gap-2">
						<div class="flex items-center gap-2 opacity-50">
							<span>
								@{profile.username}
							</span>
							<span>•</span>
							<span>
								{profile.location}
							</span>
						</div>
						<p>
							{profile.bio}
						</p>
					</div>
				</div>
			</div>
			<div class="flex items-center gap-4 pb-3">
				{#if profile.twitter}
					<a
						href={`https://twitter.com/${profile.twitter}`}
						class="flex items-center gap-2 rounded-md p-2 opacity-50 hover:bg-accent hover:opacity-100"
					>
						<XLogo class="size-4" />
						<span class="sr-only">X/Twitter</span>
					</a>
				{/if}
				{#if profile.github}
					<a
						href={`https://github.com/${profile.github}`}
						class="flex items-center gap-2 rounded-md p-2 opacity-50 hover:bg-accent hover:opacity-100"
					>
						<GithubLogo class="size-4" />
						<span class="sr-only">Github</span>
					</a>
				{/if}
				{#if profile.discord}
					<a
						href={`https://discord.gg/${profile.discord}`}
						class="flex items-center gap-2 rounded-md p-2 opacity-50 hover:bg-accent hover:opacity-100"
					>
						<DiscordLogo class="size-4" />
						<span class="sr-only">Discord</span>
					</a>
				{/if}
				{#if profile.twitch}
					<a
						href={`https://twitch.tv/${profile.twitch}`}
						class="flex items-center gap-2 rounded-md p-2 opacity-50 hover:bg-accent hover:opacity-100"
					>
						<TwitchLogo class="size-4" />
						<span class="sr-only">Twitch</span>
					</a>
				{/if}
			</div>
		</header>

		<Tabs.Root value="projects">
			<div class="flex border-b px-6 py-4">
				<Tabs.List>
					<Tabs.Trigger value="projects">Projects</Tabs.Trigger>
					<Tabs.Trigger value="comments">Comments</Tabs.Trigger>
					<Tabs.Trigger value="shipathons">Shipathons</Tabs.Trigger>
					<Tabs.Trigger value="badges">Badges</Tabs.Trigger>
				</Tabs.List>
			</div>
			<Tabs.Content value="projects" class="mt-0">
				<div>
					{#each profile.projects as { title, description, logo, url, updated_at, created_at, id } (id)}
						<a href="/project/123" class="flex flex-col gap-8 border-b p-8 hover:bg-accent/20">
							<div class="flex items-center justify-between">
								<div class="flex-auto">
									<div class="flex items-center gap-6">
										<Avatar.Root class="h-20 w-32 rounded-lg">
											<Avatar.Image src={logo || 'https://picsum.photos/200'} />
										</Avatar.Root>
										<div>
											<Heading element="h3" variant="h4">
												{title}
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
				</div>
			</Tabs.Content>
			<Tabs.Content value="comments">
				<div class="p-8">User comments go here.</div>
			</Tabs.Content>
			<Tabs.Content value="shipathons">
				<div class="p-8">User shipathons go here.</div>
			</Tabs.Content>
			<Tabs.Content value="badges">
				<div class="p-8">User badges go here.</div>
			</Tabs.Content>
		</Tabs.Root>
	{/if}
</main>
