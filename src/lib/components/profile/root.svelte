<script lang="ts">
	import { cn } from '$lib/shadcn/utils';
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	interface Props extends HTMLAttributes<HTMLDivElement> {
		children?: Snippet;
	}
	let { children, class: className }: Props = $props();
</script>

<div class={cn('rounded-2xl bg-neutral-900', className)}>
	{#if children}
		{@render children()}
	{/if}
</div>
