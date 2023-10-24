import { v4 as uuidv4 } from "uuid";
import * as https from "https";
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
    messages: [{ role: "system", content: "Say this is a test" }],
    stream: true,
  });

  const options = {
    hostname: event["request"]["headers"]["host"],
    port: 443,
    path: "/graphql",
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": event["request"]["headers"]["x-api-key"],
    },
  };

  for await (const part of stream) {
    const uuid = uuidv4();
    const chunk = part.choices[0].delta.content
      .replace("\n", "\\n")
      .replace("\t", "\\t");

    const mutation = `mutation MyMutation { createGptMessage(input: { id: "${uuid}", chunk: "${chunk}", gptSessionGptMessagesId: "${gptSessionIdStr}" }) { 
        id
        chunk
        gptSessionGptMessagesId
        createdAt
        updatedAt
      }
    }`;

    const req = https.request(options);

    req.on("error", (e) => {
      console.error(e);
    });

    const write = JSON.stringify({
      query: mutation,
      operationName: "MyMutation",
    });

    console.log(write);

    req.write(write);
  }

  return {
    statusCode: 200,
    //  Uncomment below to enable CORS requests
    //  headers: {
    //      "Access-Control-Allow-Origin": "*",
    //      "Access-Control-Allow-Headers": "*"
    //  },
    body: JSON.stringify("Hello from Lambda!"),
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
