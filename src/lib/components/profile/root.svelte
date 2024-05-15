<script lang="ts">
	import type { Tables } from '$lib/db/types';
	import { cn } from '$lib/shadcn/utils';
	import { setContext, type Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	interface Props extends HTMLAttributes<HTMLDivElement> {
		children?: Snippet;
		profile: Tables<'profiles'>;
	}
	let { children, profile, class: className }: Props = $props();

	setContext('profile', profile);
</script>

<div class={cn('rounded-2xl bg-neutral-900', className)}>
	{#if children}
		{@render children()}
	{/if}
</div>
