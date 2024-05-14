import { dev } from '$app/environment'
import {
    PUBLIC_SUPABASE_ANON_KEY,
    PUBLIC_SUPABASE_URL,
    PUBLIC_SUPABASE_DEV_ANON,
    PUBLIC_SUPABASE_DEV_URL
} from '$env/static/public'
import { getProfileById } from '$lib/db/helpers.js'
import type { Database } from '$lib/db/types'
import { createBrowserClient, createServerClient, isBrowser, parse } from '@supabase/ssr'

const _URL = dev ? PUBLIC_SUPABASE_DEV_URL : PUBLIC_SUPABASE_URL
const _ANON = dev ? PUBLIC_SUPABASE_DEV_ANON : PUBLIC_SUPABASE_ANON_KEY

export const load = (async ({ fetch, data, depends }) => {
    depends('supabase:auth')

    const supabase = isBrowser()
        ? createBrowserClient<Database>(_URL, _ANON, {
            global: {
                fetch,
            },
            cookies: {
                get(key) {
                    const cookie = parse(document.cookie)
                    return cookie[key]
                },
            },
        })
        : createServerClient<Database>(_URL, _ANON, {
            global: {
                fetch,
            },
            cookies: {
                get() {
                    return JSON.stringify(data.session)
                },
            },
        })

    /**
     * It's fine to use `getSession` here, because on the client, `getSession` is
     * safe, and on the server, it reads `session` from the `LayoutData`, which
     * safely checked the session using `safeGetSession`.
     */
    const {
        data: { session }
    } = await supabase.auth.getSession()

    const {
        data: { user },
    } = await supabase.auth.getUser()

    return {
        supabase,
        session,
        user: {
            ...user,
            profile: session?.user?.id ? await getProfileById(supabase, session.user.id) : undefined
        },

    }
})