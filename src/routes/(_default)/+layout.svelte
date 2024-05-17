<script>
	import Sidenav from '$lib/components/sidenav/app.svelte';
	import Menu from 'lucide-svelte/icons/menu';

	import { Button } from '$lib/shadcn/components/ui/button';
	import * as Sheet from '$lib/shadcn/components/ui/sheet';
	import Dropdown from '$lib/components/menu/';
	import Breadcrumb from '$lib/components/breadcrumbs';
	import { StarFour } from 'phosphor-svelte';

	const { data, children } = $props();
	const { user } = $derived(data);
</script>

<div class="border-t">
	<div class="container grid min-h-svh w-full md:grid-cols-[12rem_1fr]">
		<div class="hidden border-r py-3 md:block">
			<div class="flex h-full max-h-screen flex-col gap-2">
				<div class="flex h-14 items-center">
					<a href="/" class="group flex items-center gap-2 font-semibold">
						<div class="flex items-center justify-center rounded-lg bg-neutral-800 p-1">
							<StarFour
								class="size-6 rotate-45 transition-all duration-300 ease-in-out group-hover:-rotate-[135deg]"
								fill="gold"
							/>
						</div>
						<span>Buildstory</span>
					</a>
				</div>
				<Sidenav />
			</div>
		</div>
		<div class="flex flex-col md:border-r">
			<header class="flex h-14 items-center gap-4 border-b px-6 py-10">
				<Sheet.Root>
					<Sheet.Trigger asChild let:builder>
						<Button variant="outline" size="icon" class="shrink-0 md:hidden" builders={[builder]}>
							<Menu class="h-5 w-5" />
							<span class="sr-only">Toggle navigation menu</span>
						</Button>
					</Sheet.Trigger>
					<Sheet.Content side="left" class="flex flex-col">
						<a href="/" class="group flex items-center gap-2 font-semibold">
							<StarFour
								class="size-6 rotate-45 transition-all duration-300 ease-in-out group-hover:-rotate-[135deg]"
								fill="gold"
							/>
							<span class="">Buildstory</span>
						</a>
						<Sidenav class="grid gap-2 text-lg font-medium" />
					</Sheet.Content>
				</Sheet.Root>
				<div class="w-full flex-1">
					<Breadcrumb class="hidden sm:block" />
				</div>
				{#if user?.id}
					<Dropdown />
				{:else}
					<Button href="/auth/signin">Sign In</Button>
				{/if}
			</header>
			<main>
				{@render children()}
			</main>
		</div>
	</div>
</div>
