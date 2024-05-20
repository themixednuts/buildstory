<script lang="ts">
	import { Heading } from '../heading';

	interface PageHeaderProps {
		title: string;
		subtitle?: string | null;
	}

	const { title, subtitle }: PageHeaderProps = $props();
</script>

<div class="flex flex-col items-start justify-end border-b bg-accent/30 px-6 pb-4 pt-20">
	<Heading element="h1" variant="h2">{title}</Heading>
	{#if subtitle}
		<Heading element="h2" variant="h5" class="font-normal opacity-50">{subtitle}</Heading>
	{/if}
</div>
