import { LambdaClient, InvokeCommand } from "@aws-sdk/client-lambda";

const client = new LambdaClient({
  region: process.env.REGION,
});

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
export async function handler(event) {
  const command = new InvokeCommand({
    FunctionName: `writerchatgpt-${process.env.ENV}`,
    InvocationType: "Event",
    Payload: JSON.stringify(event, null, 2),
  });

  return {
    statusCode: 200,
    body: await client.send(command),
  };
}
