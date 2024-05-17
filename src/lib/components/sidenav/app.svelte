<script lang="ts">
	import { Button } from '$lib/shadcn/components/ui/button';
	import { cn } from '$lib/shadcn/utils';
	import { Nut, UsersThree } from 'phosphor-svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	interface Props extends HTMLAttributes<HTMLDivElement> {
		navClass?: HTMLAttributes<HTMLDivElement>['class'];
	}

	let { class: className, navClass }: Props = $props();

	const links = [
		// {
		// 	label: 'Dashboard',
		// 	href: '/dashboard',
		// 	Icon: '',
		// },
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
		// {
		// 	label: 'Shipathons',
		// 	href: '/shipathons',
		// },
		// {
		// 	label: 'Settings',
		// 	href: '/settings'
		// }
	];
</script>

<nav class={cn('text-lg font-medium', className)}>
	{#each links as { label, href, Icon }}
		<a
			{href}
			class="flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary"
		>
			{#if Icon}
				<Icon size={20} />
			{/if}
			<span>{label}</span>
		</a>
	{/each}
</nav>
