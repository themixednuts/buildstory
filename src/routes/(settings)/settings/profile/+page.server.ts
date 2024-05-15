import { fail, message, setError, superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { updateProfile } from '$lib/db/helpers.js';
import { schema } from './schema.js';

export const load = async ({ locals: { supabase } }) => {
	return {
		form: await superValidate(zod(schema)),
	};
};

export const actions = {
	default: async (event) => {
		const {
			locals: { supabase },
		} = event;
		const {
			data: { user },
		} = await supabase.auth.getUser();
		const form = await superValidate(event, zod(schema));

		if (!user?.id) return fail(400, { form });
		if (!form.valid) return fail(400, { form });

		const { avatar: file } = form.data;

		if (file && file instanceof File) {
			const ext = file.name.split('.').pop();
			const path = `${crypto.randomUUID()}.${ext}`;

			const { data: uploadData, error: uploadError } = await supabase.storage
				.from('profile_pictures')
				.upload(path, file);

			if (uploadError) return setError(form, 'avatar', 'Error uploading profile pic');

			const { data: url } = supabase.storage
				.from('profile_pictures')
				.getPublicUrl(uploadData.path, {
					transform: {
						width: 400,
						height: 400,
						resize: 'cover', // 'cover' | 'fill' | 'contain'
					},
				});

			if (!url) {
				return message(form, 'Issue with getting Public URL', { status: 500 });
			}

			form.data.avatar = url.publicUrl;
		} else {
			form.data.avatar = undefined;
		}

		//@ts-expect-error
		const { error } = await updateProfile(supabase, { ...form.data, id: user.id });

		if (error) {
			//	TODO handle each conflict case instead of this generic
			const id = crypto.randomUUID();
			console.log(id, error);
			return message(form, `Issue with updating form! id: ${id}`, { status: 500 });
		}

		return message(form, 'Updated profile!');
	},
};
