<script lang="ts">
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import type { HTMLAnchorAttributes } from 'svelte/elements';
	interface Props {
		src?: HTMLAnchorAttributes['href'];
	}
	let { src }: Props = $props();
</script>

<Avatar.Root>
	<Avatar.Image {src} />
</Avatar.Root>
