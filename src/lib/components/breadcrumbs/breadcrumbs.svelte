<script lang="ts">
	import { page } from '$app/stores';
	import * as Breadcrumb from '$lib/shadcn/components/ui/breadcrumb';
	import { cn } from '$lib/shadcn/utils';

	const crumbs = $derived(
		$page.url.href
			.split('/')
			.slice(3)
			.map((crumb, idx, arr) => ({
				label: crumb,
				href: `/${arr.slice(0, idx + 1).join('/')}`,
			}))
	);
</script>

<Breadcrumb.Root>
	<Breadcrumb.List class={cn('capitalize')}>
		{#if crumbs.length > 1}
			{#each crumbs as { label, href }, idx}
				<Breadcrumb.Link
					{href}
					class={cn('', {
						'normal-case': $page.params.username && idx === 1,
					})}>{label}</Breadcrumb.Link
				>
				{#if idx < crumbs.length - 1}
					<Breadcrumb.Separator />
				{/if}
			{/each}
		{/if}
	</Breadcrumb.List>
</Breadcrumb.Root>
