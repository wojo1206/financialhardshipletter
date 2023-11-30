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
  // console.log(event);

  const openai = new OpenAI({
    apiKey: await getSecret(process.env.OPENAI_API_KEY),
  });

  const MODEL = "gpt-4-1106-preview";

  const email = event["arguments"]["email"];
  const gptSessionId = event["arguments"]["gptSessionId"];
  const messages = [event["arguments"]["message"]];

  // 1. Query user info.
  const q1 = `query MyQuery1 {
        settingsByEmail(email: "${email}") {
          items {
            id
            tokens
            _version
          }
        }
      }`;

  const res1 = await myFetch(
    event,
    JSON.stringify({
      query: q1,
      operationName: "MyQuery1",
    })
  );
  const json1 = await res1.json();

  const setId = json1["data"]["settingsByEmail"]["items"][0]["id"];
  const tokens = parseInt(
    json1["data"]["settingsByEmail"]["items"][0]["tokens"]
  );
  const _version = parseInt(
    json1["data"]["settingsByEmail"]["items"][0]["_version"]
  );

  if (tokens <= 0) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "No tokens." }),
    };
  }

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
    const _ttl = Math.floor(Date.now() / 1000) + 60;

    const mut1 = `mutation MyMut1 { createGptMessage(input: { id: "${uuid}", chunk: "${chunk}", _ttl: ${_ttl}, gptSessionGptMessagesId: "${gptSessionId}"}) { 
          id
          owner
          chunk
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

  // 3. Query user info.
  var newTokens = tokens - cost;
  if (newTokens < 0) newTokens = 0;

  const mut2 = `mutation MyMut2 {
      updateSetting(input: {id: "${setId}", tokens:  ${newTokens}, _version: ${_version} }) {
        id
      }
    }`;

  const res2 = await myFetch(
    event,
    JSON.stringify({
      query: mut2,
      operationName: "MyMut2",
    })
  );
  const resp2 = await res2.json();
  console.log(resp2);
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
