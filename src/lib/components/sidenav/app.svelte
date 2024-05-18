<script lang="ts">
	import { cn } from '$lib/shadcn/utils';
	import { NewspaperClipping, Nut, Package, UsersThree } from 'phosphor-svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	interface Props extends HTMLAttributes<HTMLDivElement> {
		// navClass?: HTMLAttributes<HTMLDivElement>['class'];
	}

	let { class: className }: Props = $props();

	const links = [
		{
			label: 'Community',
			href: '/community',
			Icon: UsersThree,
		},
		{
			label: 'Projects',
			href: '/projects',
			Icon: Nut,
		},
		{
			label: 'Updates',
			href: '/updates',
			Icon: NewspaperClipping,
		},
		{
			label: 'Shipathons',
			href: '/shipathons',
			Icon: Package,
		},
	];
</script>

<nav class={cn('text-lg font-medium', className)}>
	{#each links as { label, href, Icon }}
		<a
			{href}
			class="flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary"
		>
			{#if Icon}
				<span><Icon size={20} class="size-5" /></span>
			{/if}
			<span>{label}</span>
		</a>
	{/each}
</nav>
