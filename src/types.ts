export interface Category {
	name: string;
	id: number;
}

export interface Feed {
	id: number;
	name: string;
	url: string;
	updatedAt: string;
	categoryId: number;
}

export interface Item {
	url: string;
	title: string;
	publishedAt: string;
	feedId: number;
}
