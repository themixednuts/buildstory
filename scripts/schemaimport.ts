const file = Bun.file('./src/lib/db/schemas.ts');

async function main() {
	const text = await file.text();
	const lines = text.split(/\r?\n/);

	const idx = lines.findIndex((line) => line.includes('import { Json }'));
	if (idx !== -1) lines[idx] = "import type { Json } from './types';";

	const lineEnding = text.includes('\r\n') ? '\r\n' : '\n';
	Bun.write('./src/lib/db/schemas.ts', lines.join(lineEnding));
}
main();
