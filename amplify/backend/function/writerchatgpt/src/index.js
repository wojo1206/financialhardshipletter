/*
Use the following code to retrieve configured secrets from SSM:

const aws = require('aws-sdk');

const { Parameters } = await (new aws.SSM())
  .getParameters({
    Names: ["OPENAI_API_KEY"].map(secretName => process.env[secretName]),
    WithDecryption: true,
  })
  .promise();

Parameters will be of the form { Name: 'secretName', Value: 'secretValue', ... }[]
*/

import { v4 as uuidv4 } from "uuid";
import OpenAI from "openai";

// import { encodeChat } from "gpt-tokenizer";

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
export async function handler(event) {
  console.log(event);

  const openai = new OpenAI({
    apiKey: await getSecret(process.env.OPENAI_API_KEY),
  });

  const MODEL = "gpt-4";

  const userId = event["arguments"]["userId"];
  const gptSessionId = event["arguments"]["gptSessionId"];
  const messages = [event["arguments"]["message"]];

  const chat = await openai.chat.completions.create({
    model: MODEL,
    messages: messages,
    stream: true,
  });

  // 2. Init open IA and capture messages.
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

    const mut1 = `mutation MyMut1 { createGptMessage(input: { id: "${uuid}", chunk: "${chunk}", createdAtTimestamp: ${createdAtTimestamp}, gptSessionGptMessagesId: "${gptSessionId}"}) { 
        id
        chunk
        createdAtTimestamp
        gptSessionGptMessagesId
        createdAt
        updatedAt
      }
    }`;

    await myFetch(
      event,
      JSON.stringify({
        query: mut1,
        operationName: "MyMut1",
      })
    );

    cost++;
  }

  return {
    statusCode: 200,
    body: "",
  };
}

async function myFetch(event, body) {
  try {
    return await fetch(
      "https://" + event["request"]["headers"]["host"] + "/graphql",
      {
        method: "POST",
        body: body,
        headers: {
          "Content-Type": "application/json",
          Authorization:
            "Bearer " + event["request"]["headers"]["authorization"],
        },
      }
    );
  } catch (error) {
    console.error(`Error: ${error.message}`);
  }
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
