<script lang="ts">
	import { cn } from '$lib/shadcn/utils';
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	interface Props extends HTMLAttributes<HTMLHeadingElement> {
		element: 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6';
		variant?: 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6';
		class?: string;
		children: Snippet;
	}
	let { class: className, element, variant = element, children }: Props = $props();

	let variants = $state({
		h1: 'scroll-m-20 text-4xl font-bold tracking-tight lg:text-5xl"',
		h2: 'scroll-m-20 pb-2 text-3xl font-semibold tracking-tight first:mt-0',
		h3: 'scroll-m-20 pb-2 text-3xl font-semibold tracking-tight first:mt-0',
		h4: 'scroll-m-20 text-xl font-semibold tracking-tight',
		h5: 'scroll-m-20 text-lg font-semibold tracking-tight',
		h6: 'scroll-m-20 text-sm font-semibold tracking-tight uppercase',
		span: '',
		p: '',
		div: '',
	});

	let variantClassNames = $derived(variants[variant]);
</script>

<svelte:element this={element} class={cn(variantClassNames, className)}>
	{@render children()}
</svelte:element>
