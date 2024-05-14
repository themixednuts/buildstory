<script lang="ts">
	import { Button } from '$lib/shadcn/components/ui/button';
	import { cn } from '$lib/shadcn/utils';
	import type { HTMLAttributes } from 'svelte/elements';

	interface Props extends HTMLAttributes<HTMLDivElement> {
		navClass?: HTMLAttributes<HTMLDivElement>['class'];
	}

	let { class: className, navClass }: Props = $props();

	const links = [
		{
			label: 'Profile',
			href: '/settings/profile',
			Icon: ''
		}
		// {
		// 	label: 'Community',
		// 	href: '/community',
		// 	Icon: ''
		// },
		// {
		// 	label: 'Projects',
		// 	href: '/projects'
		// },
		// {
		// 	label: 'Shipathons',
		// 	href: '/shipathons'
		// },
		// {
		// 	label: 'Settings',
		// 	href: '/settings'
		// }
	];
</script>

<div class={cn('flex-1', className)}>
	<nav class={cn('grid items-start px-2 text-sm font-medium lg:px-4', navClass)}>
		{#each links as { label, href, Icon }}
			<a
				{href}
				class="flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary"
			>
				{label}
			</a>
		{/each}
	</nav>
</div>
