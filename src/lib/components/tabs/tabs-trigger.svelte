<script lang="ts">
	import { Tabs as TabsPrimitive } from 'bits-ui';
	import { cn } from '$lib/shadcn/utils.js';

	type $$Props = TabsPrimitive.TriggerProps;
	type $$Events = TabsPrimitive.TriggerEvents;

	let className: $$Props['class'] = undefined;
	export let value: $$Props['value'];
	export { className as class };
</script>

<TabsPrimitive.Trigger
	class={cn(
		'inline-flex items-center justify-center whitespace-nowrap border-b border-transparent px-3 pb-3 pt-1.5 font-medium ring-offset-background transition-all hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:border-foreground data-[state=active]:text-foreground data-[state=active]:shadow-sm',
		className
	)}
	{value}
	{...$$restProps}
	on:click
>
	<slot />
</TabsPrimitive.Trigger>
