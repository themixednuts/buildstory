<script>
	import { Heading } from '$lib/components/heading';
	import * as Tabs from '$lib/shadcn/components/ui/tabs';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import { Separator } from '$lib/shadcn/components/ui/separator';
	import { FigmaLogo, GithubLogo, Package, Trophy } from 'phosphor-svelte';
	import { timeRounder } from '$lib/utils.svelte';

	const { data } = $props();
	const { data: project } = $derived(data.project);
</script>

<div>
	{#if project}
		<div class="flex flex-col items-start justify-end border-b bg-accent/30">
			<div class="flex items-center gap-4 px-6 py-4">
				<Avatar.Root class="aspect-video h-full w-64 rounded-lg">
					<Avatar.Image src={project.logo || 'https://picsum.photos/200'} />
				</Avatar.Root>
				<div class="flex flex-col gap-3">
					<div>
						<Heading element="h1" variant="h2">{project.title}</Heading>
						{#if project.description}
							<Heading element="h2" variant="h5" class="font-normal opacity-50"
								>{project.description}</Heading
							>
						{/if}
					</div>
					<div class="flex items-center gap-2">
						<div>
							By
							<a class="hocus:underline" href={`/profile/${project.profile?.username}`}>
								@{project.profile?.username}</a
							>
						</div>
						<span>•</span>
						<div>
							Updated {timeRounder(Date.now() - new Date(project.updated_at).getTime())} ago
						</div>
					</div>
				</div>
			</div>
			<div class="flex w-full items-center gap-2 border-t px-6 py-4">
				<span
					class="inline-flex items-center gap-2 rounded border border-native-foreground/20 bg-native px-2 py-1 text-sm"
				>
					<Package />
					Shipathon #00
				</span>
				<span
					class="inline-flex items-center gap-2 rounded border border-amber-500/50 bg-amber-500/20 px-2 py-1 text-sm text-amber-100"
				>
					<Trophy />
					12 Awards
				</span>
			</div>
		</div>
		<div>
			<Tabs.Root value="updates">
				<div class="flex border-b px-6 py-4">
					<Tabs.List>
						<Tabs.Trigger value="updates">Updates</Tabs.Trigger>
						<Tabs.Trigger value="about">About</Tabs.Trigger>
						<Tabs.Trigger value="awards">Awards</Tabs.Trigger>
						<Tabs.Trigger value="links">Links</Tabs.Trigger>
					</Tabs.List>
				</div>
				<Tabs.Content value="updates">
					<div class="p-6">Updates go here.</div>
				</Tabs.Content>
				<Tabs.Content value="about">
					<div class="p-6">
						{project.description}
					</div>
				</Tabs.Content>
				<Tabs.Content value="awards">
					<div class="p-6">Awards go here.</div>
				</Tabs.Content>
				<Tabs.Content value="links">
					<ul class="grid grid-cols-2 gap-4 p-6">
						{#if project.url}
							<li>
								<a class="hocus:underline" href={project.url}>{project.url}</a>
							</li>
						{/if}
						<li class="w-full">
							<a
								class="hocus:underline inline-flex w-full items-center gap-2 rounded-lg border bg-accent/50 p-4"
								href="#"
							>
								<GithubLogo />
								<span>Github</span>
							</a>
						</li>
						<li class="w-full">
							<a
								class="hocus:underline inline-flex w-full items-center gap-2 rounded-lg border bg-accent/50 p-4"
								href="#"
							>
								<FigmaLogo />
								<span>Figma</span>
							</a>
						</li>
					</ul>
				</Tabs.Content>
			</Tabs.Root>
		</div>
	{/if}
</div>
