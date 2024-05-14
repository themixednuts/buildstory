import { fail, superValidate } from 'sveltekit-superforms'
import { schema } from './schema.js'
import { zod } from 'sveltekit-superforms/adapters'
import { updateProfile } from '$lib/db/helpers.js'

export const load = async ({ locals }) => {

    return {
        form: await superValidate(zod(schema))
    }
}
export const actions = {
    default: async (event) => {
        const { locals: { supabase } } = event
        const { data: { user } } = await supabase.auth.getUser()
        const form = await superValidate(event, zod(schema))
        if (!user?.id) return fail(400, { form })
        if (!form.valid) return fail(400, { form })

        await updateProfile(supabase, { id: user.id, ...form.data })

        return {
            form
        }
    }

}