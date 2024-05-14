<script lang="ts">
	import { page } from '$app/stores';
	import * as Breadcrumb from '$lib/shadcn/components/ui/breadcrumb';

	const crumbs = $derived(
		$page.url.href
			.split('/')
			.slice(3)
			.map((crumb, idx, arr) => ({
				label: crumb,
				href: `/${arr.slice(0, idx + 1).join('/')}`
			}))
	);
</script>

<Breadcrumb.Root>
	<Breadcrumb.List class="capitalize">
		{#if crumbs.length > 1}
			{#each crumbs as { label, href }, idx}
				<Breadcrumb.Link {href}>{label}</Breadcrumb.Link>
				{#if idx < crumbs.length - 1}
					<Breadcrumb.Separator />
				{/if}
			{/each}
		{/if}
	</Breadcrumb.List>
</Breadcrumb.Root>
