<script lang="ts">
	import { Heading } from '$lib/components/heading';
	import * as Avatar from '$lib/shadcn/components/ui/avatar';
	import { Button } from '$lib/shadcn/components/ui/button';

	import { Textarea } from '$lib/shadcn/components/ui/textarea';
	import { ThumbsUp } from 'lucide-svelte';
	import { ChatCentered } from 'phosphor-svelte';

	const DUMMY_UPDATES = [
		{
			id: 1,
			content:
				'Really happy with how this is coming along. Anyone else have experience with Lucia? What do you like about it? Any downsides?',
			date: '2023-01-01',
			images: ['https://picsum.photos/300?diff=4'],
			author: 'user1',
			project: 'ACME Project',
		},
		{
			id: 2,
			content:
				'The designs are final. I have a lot of work to do on the dev side but I am really happy with how this looks',
			images: [
				'https://picsum.photos/300',
				'https://picsum.photos/300?diff=2',
				'https://picsum.photos/300?diff=3',
			],
			date: '2023-01-02',
			author: 'user2',
			project: 'Test Project',
		},
		{
			id: 3,
			content: `Haven't been able to do much yet, but I am getting back on track today. Lets do this. 🫡`,
			images: null,
			date: '2023-01-03',
			author: 'user3',
			project: 'Fresh Project',
		},
		{
			id: 4,
			content: 'Need some help fam: which do you like better, A or B?',
			images: ['https://picsum.photos/300?diff=5', 'https://picsum.photos/300?diff=6'],
			date: '2023-01-04',
			author: 'user4',
			project: 'New Project',
		},
		{
			id: 5,
			content:
				'Anyone else have some doubts after getting deep into your project? What helped you in that moment. Feeling kinda stuck.',
			date: '2023-01-05',
			author: 'user5',
			project: 'Another Project',
		},
		{
			id: 6,
			content:
				'TheMixedNuts is an absolute Supabase wizard. So thankful to have him on this project. He cooked up all these RLS rules and I did not have to think about it one bit. 🙏',
			date: '2023-01-06',
			images: ['https://picsum.photos/300?diff=7'],
			author: 'user6',
			project: 'ACME Project',
		},
	];
</script>

<div>
	<div class="border-b bg-accent/30 p-6">
		<Heading element="h1" variant="h2">Updates</Heading>
		<Heading element="h2" variant="h5" class="font-normal opacity-50">
			See updates on community projects.
		</Heading>
	</div>
	<form class="flex flex-col gap-4 border-b bg-accent/30 p-6">
		<div>
			<Textarea autofocus class="text-lg" />
		</div>
		<div class="flex items-center justify-between gap-4">
			<div class="opacity-50">Posting for: <span class="font-semibold">ACME Project</span></div>
			<Button>Post Update</Button>
		</div>
	</form>
	<section>
		{#each DUMMY_UPDATES as update}
			<article class="flex gap-8 border-b p-6">
				<Avatar.Root class="size-14 rounded-lg">
					<Avatar.Image src={`https://picsum.photos/200?diff=${update.id}`} alt="" />
				</Avatar.Root>
				<div class="flex flex-col gap-3">
					<div class="flex items-center gap-2 text-sm">
						<a
							class="inline-block opacity-50 hocus:underline hocus:opacity-100"
							href={`/profile/${update.author}`}
							>@{update.author}
						</a>
						<span class="inline-block opacity-50"> / </span>
						<a
							class="inline-block opacity-50 hocus:underline hocus:opacity-100"
							href={`/project/${update.project}`}>{update.project}</a
						>
					</div>
					<div class="flex flex-col gap-2">
						<div class="text-lg">{update.content}</div>
						{#if update.images}
							<div class="mt-3 flex flex-wrap gap-2">
								{#each update.images as image}
									<img class="aspect-video w-48 rounded-lg" src={image} alt="" />
								{/each}
							</div>
						{/if}
					</div>
					<div class="mt-4 flex items-center gap-2">
						<Button class="gap-2" variant="outline" size="sm">
							<ChatCentered size={16} />
							<span>3</span>
						</Button>
						<Button class="gap-2" variant="outline" size="sm">
							<ThumbsUp size={16} />
							<span>12</span>
						</Button>
					</div>
				</div>
			</article>
		{/each}
	</section>
</div>
