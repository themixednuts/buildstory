import { z } from "zod"
export const schema = z.object({
    name: z.string().min(2).max(35).nullable().optional(),
    bio: z.string().nullable().optional(),
    email: z.string().email().optional(),
    username: z.string().min(3).max(15).optional()
})

export type Schema = typeof schema