<script lang="ts">
	import { Heading } from '$lib/components/heading';
	import { PageHeader } from '$lib/components/page-header';
</script>

<div>
	<PageHeader title="Shipathons" subtitle="See information on current and upcoming shipathons." />
	<div class="p-6">
		<Heading element="h1" variant="h3">Current Shipathon</Heading>
		<div class="mt-2 rounded-lg border border-accent bg-accent/20 p-6">
			<Heading element="h2" variant="h4">Fall 2026: Shipathon #03</Heading>
			<div>
				Participants: <span class="font-semibold">15</span>
			</div>
		</div>
		<div class="h-12"></div>
		<Heading element="h1" variant="h3">Past Shipathons</Heading>
		<div class="mt-2 grid grid-cols-2 gap-6">
			<div class="rounded-lg border border-accent bg-accent/20 p-6">
				<Heading element="h2" variant="h4">Fall 2020: Shipathon #02</Heading>
				<div>
					Participants: <span class="font-semibold">8</span>
				</div>
			</div>
			<div class="rounded-lg border border-accent bg-accent/20 p-6">
				<Heading element="h2" variant="h4">Fall 2021: Shipathon #02</Heading>
				<div>
					Participants: <span class="font-semibold">9</span>
				</div>
			</div>
			<div class="rounded-lg border border-accent bg-accent/20 p-6">
				<Heading element="h2" variant="h4">Fall 2022: Shipathon #02</Heading>
				<div>
					Participants: <span class="font-semibold">10</span>
				</div>
			</div>
		</div>
	</div>
</div>
