export const debounce = <T extends any[]>(fn: (...args: T) => void, delay: number) => {
	let id: Timer | undefined = $state();

	return (...args: T) => {
		if (id) clearTimeout(id);
		id = setTimeout(() => {
			fn(...args);
		}, delay);
	};
};
