<script lang="ts">
	import { fileProxy, superForm } from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';
	import * as Form from '$lib/shadcn/components/ui/form';
	import { Input } from '$lib/shadcn/components/ui/input';
	import { Textarea } from '$lib/shadcn/components/ui/textarea';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import { toast } from 'svelte-sonner';
	import {
		ArrowSquareOut,
		At,
		DiscordLogo,
		EnvelopeSimple,
		GithubLogo,
		IdentificationBadge,
		MapPin,
		TwitchLogo,
		XLogo,
	} from 'phosphor-svelte';
	import { schema } from './schema.js';
	import { onMount } from 'svelte';
	import Heading from '$lib/components/heading';
	import { Button } from '$lib/shadcn/components/ui/button';
	import { debounce } from '$lib/utils.svelte.js';
	import { searchForProfileByUsername } from '$lib/db/helpers.js';
	import { Label } from '$lib/shadcn/components/ui/label';
	import { Badge } from '$lib/shadcn/components/ui/badge';
	import type { Provider } from '@supabase/supabase-js';
	import { invalidateAll } from '$app/navigation';
	import { page } from '$app/stores';

	const { data } = $props();
	const { user, supabase } = $derived(data);

	const form = superForm(data.form, {
		validators: zodClient(schema),
		dataType: 'json',
		onUpdated: async ({ form }) => {
			if (form.valid) {
				for (const key of Object.keys($formData)) {
					//@ts-expect-error
					$formData[key] = form.data[key];
				}
				toast.success(form.message);
			} else {
				toast.error('Invalid form!', {
					description: form.message,
				});
			}
		},
		onError: async ({ result }) => {
			toast.error(`${result.type} ${result.status}`, {
				description: result.error.message,
			});
		},
		invalidateAll: true,
	});

	const { form: formData, enhance, submitting, errors } = form;

	let file: ReturnType<typeof fileProxy> | undefined = $state();
	if (form) file = fileProxy(form, 'avatar');

	let input: HTMLInputElement | undefined = $state();

	let checking = $state({
		username: false,
	});

	type Providers = {
		label: Capitalize<Provider> | string;
		provider: Provider;
		value: any;
		Logo: typeof GithubLogo | typeof TwitchLogo | typeof XLogo | typeof DiscordLogo;
	};
	const providers: Providers[] = $derived([
		{
			label: 'Github',
			Logo: GithubLogo,
			value: user.identities?.find((iden) => iden.provider === 'github')?.identity_data?.user_name,
			provider: 'github',
		},
		{
			label: 'Twitch',
			Logo: TwitchLogo,
			value: user.identities?.find((iden) => iden.provider === 'twitch')?.identity_data?.full_name,
			provider: 'twitch',
		},
		{
			label: 'X (Twitter)',
			Logo: XLogo,
			// have to check what twitter returns
			value: user.identities?.find((iden) => iden.provider === 'twitter')?.identity_data?.user_name,
			provider: 'twitter',
		},
		{
			label: 'Discord',
			Logo: DiscordLogo,
			value: user.identities?.find((iden) => iden.provider === 'discord')?.identity_data?.full_name,
			provider: 'discord',
		},
	]);

	const debounceUsername = debounce(async (e: Event & { currentTarget: HTMLInputElement }) => {
		checking.username = true;
		const { data, error } = await searchForProfileByUsername(supabase, e.currentTarget.value);
		if (error) console.log(error);
		else {
			checking.username = false;
			if (data.length) $errors.username = ['Username is taken'];
		}
	}, 500);

	onMount(() => {
		for (const key of Object.keys($formData) as Array<keyof typeof $formData>) {
			//@ts-expect-error
			$formData[key] = user.profile?.[key];
		}
	});
</script>

<div class="flex flex-col gap-6 p-10">
	<Heading element="h1">Edit your details</Heading>
	<form method="post" use:enhance class="flex flex-col gap-6" enctype="multipart/form-data">
		<div class="flex items-center justify-center gap-4 pt-10">
			<Heading element="h3">Appearance</Heading>
			<div class="flex-auto border-b"></div>
		</div>
		<div class="flex flex-col gap-6 rounded-lg border bg-accent/20 p-6">
			<Form.Field {form} name="avatar" class="flex items-center gap-6">
				<Form.Control let:attrs>
					<Avatar.Root class="size-16">
						{#if $formData}
							<input
								{...attrs}
								type="file"
								class="hidden max-h-8"
								bind:files={$file}
								bind:this={input}
							/>
						{/if}
						<Avatar.Image src={user.profile?.avatar} alt="" />
					</Avatar.Root>
					<Button
						variant="outline"
						onclick={() => {
							input?.click();
						}}
					>
						Upload photo
					</Button>
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
		</div>
		<div class="flex items-center justify-center gap-4 pt-10">
			<Heading element="h3">Account info</Heading>
			<div class="flex-auto border-b"></div>
		</div>
		<div class="flex flex-col gap-6 rounded-lg border bg-accent/20 p-6">
			<Form.Field {form} name="username">
				<Form.Control let:attrs>
					<div>
						<Form.Label>Username</Form.Label>
						<Form.Description>Updating this will change your profile URL.</Form.Description>
					</div>
					<Form.FieldErrors />
					<div class="relative w-full">
						<Input
							{...attrs}
							class="peer pl-8"
							bind:value={$formData.username}
							oninput={debounceUsername}
						/>
						<At
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
			</Form.Field>
			<Form.Field {form} name="email">
				<Form.Control let:attrs>
					<data>
						<Form.Label>Email</Form.Label>
						<Form.Description>
							Your email will be used to send you notifications and verifications.
						</Form.Description>
					</data>
					<div class="relative w-full">
						<Input {...attrs} class="peer pl-8" bind:value={$formData.email} readonly />
						<EnvelopeSimple
							size={16}
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
				<Form.Description class="pt-1">
					<a
						class="inline-flex items-center gap-2 text-sm underline hover:text-native-foreground"
						href="/update-email"
					>
						Need to update your email?
						<ArrowSquareOut size={16} />
					</a>
				</Form.Description>
				<Form.FieldErrors />
			</Form.Field>
		</div>
		<div class="flex items-center justify-center gap-4 pt-10">
			<Heading element="h3">About you</Heading>
			<div class="flex-auto border-b"></div>
		</div>
		<div class="flex flex-col gap-6 rounded-lg border bg-accent/20 p-6">
			<Form.Field {form} name="name">
				<Form.Control let:attrs>
					<data>
						<Form.Label>Display name</Form.Label>
						<Form.Description>We use this publicly on your profile.</Form.Description>
					</data>
					<div class="relative w-full">
						<Input {...attrs} class="peer pl-8" bind:value={$formData.name} />
						<IdentificationBadge
							size={16}
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="location">
				<Form.Control let:attrs>
					<div>
						<Form.Label>Location</Form.Label>
						<Form.Description
							>Where are you based? You can be as specific or general as you like.</Form.Description
						>
					</div>
					<div class="relative w-full">
						<Input {...attrs} class="peer pl-8" bind:value={$formData.location} />
						<MapPin
							size={16}
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="bio">
				<Form.Control let:attrs>
					<div>
						<Form.Label>Bio</Form.Label>
						<Form.Description>Tell us a little about yourself.</Form.Description>
					</div>
					<Textarea {...attrs} bind:value={$formData.bio} />
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="dream">
				<Form.Control let:attrs>
					<div>
						<Form.Label>Goals</Form.Label>
						<Form.Description
							>What are you dreams and/or goals that you hope to achieve?</Form.Description
						>
					</div>
					<Textarea {...attrs} bind:value={$formData.dream} />
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
		</div>
		<div class="flex items-center justify-center gap-4 pt-10">
			<Heading element="h3">Socials</Heading>
			<div class="flex-auto border-b"></div>
		</div>
		<div class="grid grid-cols-1 gap-6 rounded-lg border bg-accent/20 p-6 md:grid-cols-2">
			{#each providers as { label, Logo, value, provider }}
				<div class="">
					<Label>{label}</Label>
					<div class="relative w-full">
						{#if value}
							<Badge variant="outline" class="gap-2 py-2">
								<Logo size={16} class="" />
								{value}
							</Badge>
							<Button
								variant="destructive"
								size="sm"
								onclick={async () => {
									const iden = user.identities?.find((identity) => identity.provider === provider);
									if (!iden) return;
									const { error } = await supabase.auth.unlinkIdentity(iden);
									if (error)
										toast.error(`Can't unlink ${label}`, {
											description: error.message,
										});
									else {
										toast.success(`${label} unlinked`);
										invalidateAll();
									}
								}}
							>
								Unlink
							</Button>
						{:else}
							<Button
								variant="outline"
								class="gap-2"
								size="sm"
								onclick={async () => {
									const { error } = await supabase.auth.linkIdentity({
										provider,
										options: {
											redirectTo: `${$page.url.origin}/settings/profile`,
										},
									});
									if (error)
										toast.error(`Issue linking ${label} to your profile`, {
											description: error.message,
										});
									else {
										// toast.success(`Linked ${provider} to your profile!`);
									}
								}}
							>
								<Logo size={16} class="" />
								Link
							</Button>
						{/if}
					</div>
				</div>
			{/each}
		</div>
		<div>
			<Form.Button disabled={$submitting}>
				{#if $submitting}
					Saving...
				{:else}
					Submit
				{/if}
			</Form.Button>
		</div>
	</form>
</div>
