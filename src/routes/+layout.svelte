<script lang="ts">
	import '../app.pcss';
	import { Toaster } from 'svelte-sonner';
	import { ModeWatcher } from 'mode-watcher';

	// export let data
	const { data, children } = $props();
	const { user } = $derived(data);
</script>

<ModeWatcher />
<Toaster />

<!-- <slot> </slot> -->
{@render children()}
