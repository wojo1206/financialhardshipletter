import { v4 as uuidv4 } from "uuid";
import OpenAI from "openai";

// import { encodeChat } from "gpt-tokenizer";

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
export async function handler(event) {
  // console.log(event, process.env);

  const openai = new OpenAI({
    apiKey: await getSecret(process.env.OPENAI_API_KEY),
  });

  const MODEL = "gpt-4";

  const gptSessionIdStr = event["arguments"]["gptSessionId"];

  const TYPE = "medical"; // [medical|credit card|mortgage]
  const INSTITUTION_NAME = "Christ Medical Center";
  const INSTITUTION_ADDRESS = "1234 S Main St, Chicago, IL";
  const TONE = "friendly"; // [friendly|kind|neutral|positive|negative]
  const MY_NAME = "Joe Doe";
  const MY_CONTACT_INFO = "[my.email$gmail.com]";
  // [I am writing on behalf of [subject name]].`
  const LONG_OR_SHORT = "short";

  const messages = [
    {
      role: "system",
      content: `As a letter writer, your task to write a ${TYPE} hardship letter to ${TYPE} institution explaining my hardship to 
        ${INSTITUTION_NAME} at ${INSTITUTION_ADDRESS} using a ${TONE} tone. The main objective is to explain my situation clearly, 
        and write the letter with a “Subject:” statement at the very top with the body of the letter following the subject. 
        Please keep any placeholder information between brackets. My name is ${MY_NAME} and my contact info is ${MY_CONTACT_INFO}. Keep the letter ${LONG_OR_SHORT}.`,
    },
  ];

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
