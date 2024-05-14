<script lang="ts">
	import '../app.pcss';
	import { ModeWatcher } from 'mode-watcher';

	const { data, children } = $props();
</script>

<ModeWatcher />
{@render children()}
