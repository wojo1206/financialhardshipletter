import { v4 as uuidv4 } from "uuid";
import OpenAI from "openai";

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
export async function handler(event) {
  const openai = new OpenAI({
    apiKey: await getSecret(process.env.OPENAI_API_KEY),
  });

  const gptSessionIdStr = event["arguments"]["gptSessionId"];

  const stream = await openai.chat.completions.create({
    model: "gpt-4",
    messages: [
      {
        role: "system",
        content: `I want you to act as an hardship letter writer for a medical patient. 
    The name of the patient is Joe Doe and he was born on 3/3/2023 and he has been treated for DifficultyB at Chicago Christ Hospital at Chicago. 
    Please express gratitude to the hospital staff.`,
      },
    ],
    stream: true,
  });

  for await (const part of stream) {
    const uuid = uuidv4();
    var chunk = part.choices[0].delta.content;

    if (!chunk) continue;

    chunk = chunk.replace(/\n/g, "\\n");

    const mutation = `mutation MyMutation { createGptMessage(input: { id: "${uuid}", chunk: "${chunk}", gptSessionGptMessagesId: "${gptSessionIdStr}" }) { 
        id
        chunk
        gptSessionGptMessagesId
        createdAt
        updatedAt
      }
    }`;

    try {
      await fetch(
        "https://" + event["request"]["headers"]["host"] + "/graphql",
        {
          method: "POST",
          body: JSON.stringify({
            query: mutation,
            operationName: "MyMutation",
          }),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": event["request"]["headers"]["x-api-key"],
          },
        }
      );
    } catch (error) {
      console.error(`Error: ${error.message}`);
    }
  }

  return {
    statusCode: 200,
    body: "",
  };
}

async function getSecret(name) {
  const response = await fetch(
    `http://localhost:2773/systemsmanager/parameters/get/?name=${encodeURIComponent(
      name
    )}&withDecryption=true`,
    {
      headers: {
        "X-Aws-Parameters-Secrets-Token": process.env.AWS_SESSION_TOKEN,
      },
    }
  );

  const json = await response.json();

  return json.Parameter.Value;
}
