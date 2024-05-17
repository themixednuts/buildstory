<script lang="ts">
	import { Bell, CaretDown } from 'phosphor-svelte';
	import * as DropdownMenu from '$lib/shadcn/components/ui/dropdown-menu';
	import { Button } from '$lib/shadcn/components/ui/button';
	import { page } from '$app/stores';
	import type { PageData } from '../../../routes/(_default)/$types';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import type { HTMLAttributes } from 'svelte/elements';
	import { cn } from '$lib/shadcn/utils';
	import { Item } from '$lib/shadcn/components/ui/breadcrumb';

	interface Props extends HTMLAttributes<HTMLDivElement> {}
	const { class: className }: Props = $props();

	const { profile } = $derived($page.data.user) as PageData['user'];
</script>

{#if profile}
	<div class={cn('flex items-center gap-2', className)}>
		<Button variant="ghost" size="icon" class="ml-auto size-8">
			<Bell class="size-6" />
			<span class="sr-only">Toggle notifications</span>
		</Button>
		<DropdownMenu.Root>
			<DropdownMenu.Trigger asChild let:builder>
				<Button variant="ghost" class="flex items-center gap-2 px-2.5" builders={[builder]}>
					<Avatar.Root class="size-6 rounded-lg">
						<Avatar.Image class="rounded-lg" src={profile.avatar}></Avatar.Image>
					</Avatar.Root>
					<div>{profile.username}</div>
					<CaretDown />
					<span class="sr-only">Toggle navigation menu</span>
				</Button>
			</DropdownMenu.Trigger>
			<DropdownMenu.Content align="end">
				<DropdownMenu.Label>{profile.email}</DropdownMenu.Label>
				<DropdownMenu.Separator />
				<DropdownMenu.Item href="/settings/profile">Settings</DropdownMenu.Item>
				<DropdownMenu.Item href={`/profile/${profile.username}`}>Profile</DropdownMenu.Item>
				<!-- <DropdownMenu.Item>Support</DropdownMenu.Item> -->
				<DropdownMenu.Separator />
				<DropdownMenu.Item on:click={() => $page.data.supabase.auth.signOut()}
					>Logout</DropdownMenu.Item
				>
			</DropdownMenu.Content>
		</DropdownMenu.Root>
	</div>
{/if}
