<script lang="ts">
	import { fileProxy, superForm } from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';
	import * as Form from '$lib/shadcn/components/ui/form';
	import { Input } from '$lib/shadcn/components/ui/input';
	import { Textarea } from '$lib/shadcn/components/ui/textarea';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import { toast } from 'svelte-sonner';
	import {
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
	import { Checkbox } from '$lib/shadcn/components/ui/checkbox';
	import Switch from '$lib/shadcn/components/ui/switch/switch.svelte';

	const { data } = $props();
	const { user } = $derived(data);

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
				toast.error(form.message);
			}
		},
		onError: async ({ result }) => {
			toast.error(`${result.type} ${result.status}`, {
				description: result.error.message,
			});
		},
		invalidateAll: true,
	});

	const { form: formData, enhance, submitting } = form;

	//@ts-expect-error
	let file: ReturnType<typeof fileProxy<NonNullable<typeof form>, 'avatar'>> | undefined = $state();
	if (form) file = fileProxy(form, 'avatar');

	let pfpEle: HTMLInputElement | undefined = $state();

	onMount(() => {
		for (const key of Object.keys($formData) as Array<keyof typeof $formData>) {
			//@ts-expect-error
			$formData[key] = user.profile?.[key];
		}
	});
</script>

<div class="flex max-w-3xl flex-col gap-6">
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
								bind:this={pfpEle}
							/>
						{/if}
						<Avatar.Image src={user.profile?.avatar} alt="" />
					</Avatar.Root>
					<Button
						variant="outline"
						onclick={() => {
							pfpEle?.click();
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
						<Input {...attrs} class="peer pl-8" bind:value={$formData.username} />
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
							Your email will be used to send you notifications and reset your password.
						</Form.Description>
					</data>
					<div class="relative w-full">
						<Input {...attrs} class="peer pl-8" bind:value={$formData.email} />
						<EnvelopeSimple
							size={16}
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
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
			<Form.Field {form} name="github">
				<Form.Control let:attrs>
					<Form.Label>Github</Form.Label>
					<div class="relative w-full">
						<Input {...attrs} class="peer pl-8" bind:value={$formData.github} />
						<GithubLogo
							size={16}
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="twitch">
				<Form.Control let:attrs>
					<Form.Label>Twitch</Form.Label>
					<div class="relative w-full">
						<Input {...attrs} class="peer pl-8" bind:value={$formData.twitch} />
						<TwitchLogo
							size={16}
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="discord">
				<Form.Control let:attrs>
					<Form.Label>Discord</Form.Label>
					<div class="relative w-full">
						<Input {...attrs} class="peer pl-8" bind:value={$formData.discord} />
						<DiscordLogo
							size={16}
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="twitter">
				<Form.Control let:attrs>
					<Form.Label>X (Twitter)</Form.Label>
					<div class="relative w-full">
						<Input {...attrs} class="peer pl-8" bind:value={$formData.twitter} />
						<XLogo
							size={16}
							class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
						/>
					</div>
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
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
