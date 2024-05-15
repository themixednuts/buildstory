<script lang="ts">
	import { Bell, CaretDown } from 'phosphor-svelte';
	import * as DropdownMenu from '$lib/shadcn/components/ui/dropdown-menu';
	import { Button } from '$lib/shadcn/components/ui/button';
	import { page } from '$app/stores';
	import type { PageData } from '../../../routes/(app)/$types';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';

	const { profile: p } = $page.data.user as PageData['user'];
	const profile = $derived(p!.data!);
</script>

<div class="flex items-center gap-2">
	<Button variant="ghost" size="icon" class="ml-auto size-8">
		<Bell class="size-6" />
		<span class="sr-only">Toggle notifications</span>
	</Button>
	<Avatar.Root class="size-8 rounded-lg">
		<Avatar.Image class="rounded-lg" src={profile.avatar}></Avatar.Image>
	</Avatar.Root>
	<div>{profile.username}</div>
	<DropdownMenu.Root>
		<DropdownMenu.Trigger asChild let:builder>
			<Button variant="outline" class="size-6" size="icon" builders={[builder]}>
				<CaretDown />
				<span class="sr-only">Toggle navigation menu</span>
			</Button>
		</DropdownMenu.Trigger>
		<DropdownMenu.Content align="end">
			<DropdownMenu.Label>{profile.email}</DropdownMenu.Label>
			<DropdownMenu.Separator />
			<DropdownMenu.Item href="/settings">Settings</DropdownMenu.Item>
			<!-- <DropdownMenu.Item>Support</DropdownMenu.Item> -->
			<DropdownMenu.Separator />
			<DropdownMenu.Item on:click={() => $page.data.supabase.auth.signOut()}
				>Logout</DropdownMenu.Item
			>
		</DropdownMenu.Content>
	</DropdownMenu.Root>
</div>
