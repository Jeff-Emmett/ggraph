import OpenAI from "openai";

const openai = new OpenAI({
	apiKey: import.meta.env.VITE_OPENAI_API_KEY,
	dangerouslyAllowBrowser: true,
});

export async function llm(
	systemPrompt: string,
	userPrompt: string,
	onToken: (partialResponse: string, done: boolean) => void,
) {
	console.log("System Prompt:", systemPrompt);
	console.log("User Prompt:", userPrompt);
	let partial = "";
	const stream = await openai.chat.completions.create({
		model: "gpt-4o",
		messages: [
			{ role: "system", content: 'You are a helpful assistant.' },
			{ role: "user", content: userPrompt },
		],
		stream: true,
	});
	for await (const chunk of stream) {
		partial += chunk.choices[0]?.delta?.content || "";
		onToken(partial, false);
	}
	console.log("Generated:", partial);
	onToken(partial, true);
}
