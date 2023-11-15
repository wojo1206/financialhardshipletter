import { v4 as uuidv4 } from "uuid";
import OpenAI from "openai";

// import { encodeChat } from "gpt-tokenizer";

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
export async function handler(event) {
  const openai = new OpenAI({
    apiKey: await getSecret(process.env.OPENAI_API_KEY),
  });

  const MODEL = "gpt-4";

  const gptSessionIdStr = event["arguments"]["gptSessionId"];
  const messages = [event["arguments"]["message"]];

  const chat = await openai.chat.completions.create({
    model: MODEL,
    messages: messages,
    stream: true,
  });

  // const tokens = encodeChat(messages, MODEL);

  var cost = 0; //  tokens.length;
  for await (const part of chat) {
    const uuid = uuidv4();
    const chunk = JSON.stringify(part)
      .replace(/[\\]/g, "\\\\")
      .replace(/[\"]/g, '\\"')
      .replace(/[\/]/g, "\\/")
      .replace(/[\b]/g, "\\b")
      .replace(/[\f]/g, "\\f")
      .replace(/[\n]/g, "\\n")
      .replace(/[\r]/g, "\\r")
      .replace(/[\t]/g, "\\t");
    const createdAtTimestamp = Math.floor(Date.now() / 1000);

    const mutation = `mutation MyMutation { createGptMessage(input: { id: "${uuid}", chunk: "${chunk}", createdAtTimestamp: ${createdAtTimestamp}, gptSessionGptMessagesId: "${gptSessionIdStr}"}) { 
        id
        chunk
        createdAtTimestamp
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

    cost++;
  }

  console.log(`Cost: ${cost} token.`);

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
