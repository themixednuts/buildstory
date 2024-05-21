<script>
	import Sidenav from '$lib/components/sidenav/app.svelte';
	import Menu from 'lucide-svelte/icons/menu';

	import { Button } from '$lib/shadcn/components/ui/button';
	import * as Sheet from '$lib/shadcn/components/ui/sheet';
	import Dropdown from '$lib/components/menu/';
	import Breadcrumb from '$lib/components/breadcrumbs';
	import { MagnifyingGlass, StarFour } from 'phosphor-svelte';
	import Input from '$lib/shadcn/components/ui/input/input.svelte';

	const { data, children } = $props();
	const { user } = $derived(data);
</script>

<div class="border-y">
	<div class="container grid min-h-svh w-full md:grid-cols-[12rem_1fr]">
		<div class="hidden border-r py-3 md:block">
			<div class="sticky top-3 space-y-2">
				<div class="flex h-14 items-center">
					<a href="/" class="group flex items-center gap-2 font-semibold">
						<div
							class="group-hocus:bg- flex items-center justify-center rounded-lg bg-neutral-800 p-2 shadow-[0px_1px_40px] shadow-amber-500/60 transition-all duration-[400ms] ease-in-out group-hocus:shadow-amber-400/80"
						>
							<svg
								class="size-3 text-amber-500 transition-all duration-[400ms] ease-in-out group-hocus:-rotate-[180deg] group-hocus:scale-125 group-hocus:text-amber-400"
								xmlns="http://www.w3.org/2000/svg"
								viewBox="0 0 16 16"
								fill="none"
							>
								<path
									fill="currentColor"
									fill-rule="evenodd"
									d="M15.847.145a.89.89 0 0 0-.012-.01.504.504 0 0 0-.659-.022C10.394 3.33 5.743 3.63.83.119a.504.504 0 0 0-.596-.04.505.505 0 0 0-.113.754c3.508 4.91 3.208 9.56-.005 14.339a.504.504 0 0 0 .001.645.535.535 0 0 0 .046.049.504.504 0 0 0 .659.021c4.784-3.215 9.434-3.517 14.347-.006a.504.504 0 0 0 .594.04l.004-.003a.472.472 0 0 0 .128-.118l.006-.008a.504.504 0 0 0-.023-.625c-3.507-4.911-3.206-9.559.006-14.34a.505.505 0 0 0-.036-.683v.001Z"
									clip-rule="evenodd"
								/>
							</svg>
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
							<div
								class="group-hocus:bg- flex items-center justify-center rounded-lg bg-neutral-800 p-2 shadow-[0px_1px_40px] shadow-amber-500/50 transition-all duration-[400ms] ease-in-out group-hocus:shadow-amber-400/70"
							>
								<svg
									class="size-3 text-amber-500 transition-all duration-[400ms] ease-in-out group-hocus:-rotate-[180deg] group-hocus:scale-125 group-hocus:text-amber-400"
									xmlns="http://www.w3.org/2000/svg"
									viewBox="0 0 16 16"
									fill="none"
								>
									<path
										fill="currentColor"
										fill-rule="evenodd"
										d="M15.847.145a.89.89 0 0 0-.012-.01.504.504 0 0 0-.659-.022C10.394 3.33 5.743 3.63.83.119a.504.504 0 0 0-.596-.04.505.505 0 0 0-.113.754c3.508 4.91 3.208 9.56-.005 14.339a.504.504 0 0 0 .001.645.535.535 0 0 0 .046.049.504.504 0 0 0 .659.021c4.784-3.215 9.434-3.517 14.347-.006a.504.504 0 0 0 .594.04l.004-.003a.472.472 0 0 0 .128-.118l.006-.008a.504.504 0 0 0-.023-.625c-3.507-4.911-3.206-9.559.006-14.34a.505.505 0 0 0-.036-.683v.001Z"
										clip-rule="evenodd"
									/>
								</svg>
							</div>
							<span>Buildstory</span>
						</a>
						<Sidenav class="grid gap-2 text-lg font-medium" />
					</Sheet.Content>
				</Sheet.Root>
				<div class="relative w-full flex-1">
					<Input placeholder="Search..." class="peer max-w-64 pl-10" />
					<MagnifyingGlass
						class="pointer-events-none absolute left-3 top-3  opacity-50 peer-focus:opacity-100"
					/>
					<!-- <Breadcrumb class="hidden sm:block" /> -->
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
