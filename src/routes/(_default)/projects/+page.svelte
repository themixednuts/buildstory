<script lang="ts">
	import Heading from '$lib/components/heading';
	import type { PageData } from './$types';

	// export let data: PageData;
</script>

<div>
	<div class="flex flex-col items-start justify-end gap-2 border-b bg-accent/50 px-6 pb-4 pt-20">
		<Heading element="h1">Projects</Heading>
		<Heading element="h2" variant="h5" class="font-normal opacity-50"
			>See what the community has been working on.</Heading
		>
	</div>
	<ul>
		<li>Project 1</li>
		<li>Project 2</li>
		<li>Project 3</li>
	</ul>
</div>
