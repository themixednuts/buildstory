type Timer = ReturnType<typeof setTimeout>;

export const debounce = <T extends any[]>(fn: (...args: T) => void, delay: number) => {
	let id: Timer | undefined = $state();

	return (...args: T) => {
		if (id) clearTimeout(id);
		id = setTimeout(() => {
			fn(...args);
		}, delay);
	};
};

export const timeRounder = (time: number) => {
	// convert to seconds
	const t = Math.floor(time / 1000);

	if (t < 60) return `${t} seconds`;
	if (t < 3600) return `${Math.floor(t / 60)} minutes`;
	if (t < 86400) return `${Math.floor(t / 3600)} hours`;
	if (t < 604800) return `${Math.floor(t / 86400)} days`;
	if (t < 2628000) return `${Math.floor(t / 604800)} weeks`;
	if (t < 31536000) return `${Math.floor(t / 2628000)} months`;
	return `${Math.floor(t / 31536000)} years`;
};
