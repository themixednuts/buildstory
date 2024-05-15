<script lang="ts">
	import { fileProxy, superForm } from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';
	import * as Form from '$lib/shadcn/components/ui/form';
	import { Input } from '$lib/shadcn/components/ui/input';
	import { Textarea } from '$lib/shadcn/components/ui/textarea';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import { toast } from 'svelte-sonner';
	import { At } from 'phosphor-svelte';
	import { schema } from './schema.js';
	import { onMount } from 'svelte';

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

	const { form: formData, enhance } = form;

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

<form method="post" use:enhance class="flex flex-col gap-6" enctype="multipart/form-data">
	<Form.Field {form} name="avatar">
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
				<button
					type="button"
					class="size-full"
					onclick={() => {
						pfpEle?.click();
					}}
				>
					<Avatar.Image src={user.profile?.avatar} alt="" />
				</button>
			</Avatar.Root>
		</Form.Control>
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="username">
		<Form.Control let:attrs>
			<Form.Label>Username</Form.Label>
			<div class="relative w-full">
				<At class="absolute left-1 top-1/2 -translate-y-1/2" />
				<Input {...attrs} class="pl-5" bind:value={$formData.username} />
			</div>
		</Form.Control>
		<Form.Description>Public username</Form.Description>
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="name">
		<Form.Control let:attrs>
			<Form.Label>Name</Form.Label>
			<Input {...attrs} bind:value={$formData.name} />
		</Form.Control>
		<Form.Description>Public display name</Form.Description>
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="email">
		<Form.Control let:attrs>
			<Form.Label>Email</Form.Label>
			<div class="relative w-full">
				<Input {...attrs} class="peer pl-8" bind:value={$formData.email} />
				<At
					size={16}
					class="absolute left-2.5 top-1/2 -translate-y-1/2 opacity-50 peer-focus:opacity-100"
				/>
			</div>
			<Form.Description>
				Your email will be used to send you notifications and reset your password.
			</Form.Description>
		</Form.Control>
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="location">
		<Form.Control let:attrs>
			<Form.Label>Location</Form.Label>
			<Input {...attrs} bind:value={$formData.location} />
		</Form.Control>
		<Form.Description>Public display name</Form.Description>
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="bio">
		<Form.Control let:attrs>
			<Form.Label>Bio</Form.Label>
			<Textarea {...attrs} bind:value={$formData.bio} />
		</Form.Control>
		<Form.Description>Describe yourself, passions and goals.</Form.Description>
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="dream">
		<Form.Control let:attrs>
			<Form.Label>Dream</Form.Label>
			<Textarea {...attrs} bind:value={$formData.dream} />
		</Form.Control>
		<Form.Description>What are you dreams?</Form.Description>
		<Form.FieldErrors />
	</Form.Field>
	<!-- can probably use a tab component for these socials? -->
	<Form.Field {form} name="github">
		<Form.Control let:attrs>
			<Form.Label>Github</Form.Label>
			<Input {...attrs} bind:value={$formData.github} />
		</Form.Control>
		<!-- <Form.Description>Github</Form.Description> -->
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="twitch">
		<Form.Control let:attrs>
			<Form.Label>Twitch</Form.Label>
			<Input {...attrs} bind:value={$formData.twitch} />
		</Form.Control>
		<!-- <Form.Description>Twitch</Form.Description> -->
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="discord">
		<Form.Control let:attrs>
			<Form.Label>Discord</Form.Label>
			<Input {...attrs} bind:value={$formData.discord} />
		</Form.Control>
		<!-- <Form.Description>Discord</Form.Description> -->
		<Form.FieldErrors />
	</Form.Field>
	<Form.Field {form} name="twitter">
		<Form.Control let:attrs>
			<Form.Label>Twitter</Form.Label>
			<Input {...attrs} bind:value={$formData.twitter} />
		</Form.Control>
		<!-- <Form.Description>Twitter</Form.Description> -->
		<Form.FieldErrors />
	</Form.Field>
	<div>
		<Form.Button>Submit</Form.Button>
	</div>
</form>
