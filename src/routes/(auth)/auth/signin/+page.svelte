<script lang="ts">
	import { ThemeMinimal } from '@supabase/auth-ui-shared';
	import { Auth } from '@supabase/auth-ui-svelte';
	export let data;
</script>

<div class="w-full lg:grid lg:min-h-[600px] lg:grid-cols-2 xl:min-h-[800px]">
	<div class="flex items-center justify-center py-12">
		<div class="mx-auto grid w-[350px] gap-6">
			<Auth
				supabaseClient={data.supabase}
				providers={['google', 'github', 'twitter', 'twitch']}
				redirectTo=""
				appearance={{
					theme: ThemeMinimal,
				}}
			/>
		</div>
	</div>
	<div class="hidden bg-muted lg:block">
		<!-- <img
			src="/images/placeholder.svg"
			alt="placeholder"
			width="1920"
			height="1080"
			class="h-full w-full object-cover dark:brightness-[0.2] dark:grayscale"
		/> -->
	</div>
</div>
