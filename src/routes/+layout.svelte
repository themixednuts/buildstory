<script lang="ts">
	import '../app.pcss';
	import { Toaster } from 'svelte-sonner';
	import { ModeWatcher } from 'mode-watcher';

	const { data, children } = $props();
</script>

<ModeWatcher />
<Toaster />
{@render children()}
