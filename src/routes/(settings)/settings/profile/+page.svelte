<script lang="ts">
	import { superForm } from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';
	import { schema } from './schema.js';
	import * as Form from '$lib/shadcn/components/ui/form';
	import { Input } from '$lib/shadcn/components/ui/input';
	import { Textarea } from '$lib/shadcn/components/ui/textarea';
	import { toast } from 'svelte-sonner';
	import { At } from 'phosphor-svelte';

	const { data } = $props();
	const { user, supabase } = $derived(data);

	const form = superForm(data.form, {
		validators: zodClient(schema),
		onUpdated: async ({ form }) => {
			if (form.valid) {
				toast.success(form.message);
			} else {
				toast.error(form.message);
			}
		},
		onError: async ({ result }) => {
			toast.error(`${result.type} ${result.status}`, {
				description: result.error.message
			});
		},
		invalidateAll: true
	});

	$inspect(user.profile!.data);

	$effect(() => {
		$formData.name = user.profile!.data!.name;
		$formData.email = user.profile!.data!.email;
		$formData.username = user.profile!.data!.username;
		$formData.bio = user.profile!.data!.bio;
	});

	const { form: formData, enhance } = form;
</script>

<form method="post" use:enhance>
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
			<Input {...attrs} bind:value={$formData.email} />
		</Form.Control>
		<!-- <Form.Description>Email</Form.Description> -->
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
	<Form.Field {form} name="bio">
		<Form.Control let:attrs>
			<Form.Label>Bio</Form.Label>
			<Textarea {...attrs} bind:value={$formData.bio} />
		</Form.Control>
		<Form.Description>Describe yourself, passions and goals.</Form.Description>
		<Form.FieldErrors />
	</Form.Field>
	<Form.Button>Submit</Form.Button>
</form>
