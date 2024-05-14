<script>
	import Sidenav from '$lib/components/sidenav/app.svelte';
	import Menu from 'lucide-svelte/icons/menu';

	import { Button } from '$lib/shadcn/components/ui/button';
	import * as Sheet from '$lib/shadcn/components/ui/sheet';
	import Dropdown from '$lib/components/menu/';
	import { onMount } from 'svelte';
	import { goto, invalidate } from '$app/navigation';
	import Breadcrumb from '$lib/components/breadcrumbs';
	import { StarFour } from 'phosphor-svelte';

	const { data, children } = $props();
	const { supabase, user, session } = $derived(data);

	onMount(() => {
		const { data } = supabase.auth.onAuthStateChange((_, newSession) => {
			if (!newSession) {
				/**
				 * Queue this as a task so the navigation won't prevent the
				 * triggering function from completing
				 */
				setTimeout(() => {
					goto('/', { invalidateAll: true });
				});
			}
			if (newSession?.expires_at !== session?.expires_at) {
				invalidate('supabase:auth');
			}
		});

		return () => data.subscription.unsubscribe();
	});
</script>

<div class="grid min-h-screen w-full md:grid-cols-[220px_1fr] lg:grid-cols-[280px_1fr]">
	<div class="hidden border-r bg-muted/40 md:block">
		<div class="flex h-full max-h-screen flex-col gap-2">
			<div class="flex h-14 items-center border-b px-4 lg:h-[60px] lg:px-6">
				<a href="/" class="flex items-center gap-2 font-semibold">
					<StarFour class="size-6 rotate-45" fill="gold" />
					<span class="">Buildstory</span>
				</a>
			</div>
			<Sidenav />
		</div>
	</div>
	<div class="flex flex-col">
		<header class="flex h-14 items-center gap-4 border-b bg-muted/40 px-4 lg:h-[60px] lg:px-6">
			<Sheet.Root>
				<Sheet.Trigger asChild let:builder>
					<Button variant="outline" size="icon" class="shrink-0 md:hidden" builders={[builder]}>
						<Menu class="h-5 w-5" />
						<span class="sr-only">Toggle navigation menu</span>
					</Button>
				</Sheet.Trigger>
				<Sheet.Content side="left" class="flex flex-col">
					<Sidenav navClass="grid gap-2 text-lg font-medium" />
				</Sheet.Content>
			</Sheet.Root>
			<div class="w-full flex-1">
				<Breadcrumb />
				<!-- <form>
					<div class="relative">
						<Search class="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
						<Input
							type="search"
							placeholder="Search products..."
							class="w-full appearance-none bg-background pl-8 shadow-none md:w-2/3 lg:w-1/3"
						/>
					</div>
				</form> -->
			</div>
			{#if user?.id}
				<Dropdown />
			{:else}
				<Button href="/auth/signin">Sign In</Button>
			{/if}
		</header>
		<main class="">
			<!-- <main class="flex flex-1 flex-col gap-4 p-4 lg:gap-6 lg:p-6"> -->
			{@render children()}
		</main>
	</div>
</div>
