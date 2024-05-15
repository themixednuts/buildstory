export const PROFILE = `*, 
    projects!projects_profile_id_fkey(*, upvotes:projects_upvotes(*), contributors(*, profile:profiles(*))), 
    badges:profiles_badges(id:badge_id, created_at, ...badges(name)), 
    points:profiles_points(...points(value.sum()))
    `;
