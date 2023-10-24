import boto3
import json
import openai
import os
import uuid
import requests

ssm = boto3.client('ssm')

def handler(event, context):
  print(event)

  gptSessionIdStr = event["arguments"]["gptSessionId"]

  # establish a session with requests session
  session = requests.Session()

  APPSYNC_API_ENDPOINT_URL = 'https://45f4mphicvb77pmj3f7i4l4j2m.appsync-api.us-east-2.amazonaws.com/graphql'
  APPSYNC_API_KEY = 'da2-rqh5ngeo75a5bcoznihnuslpxu'
  
  openai.api_key = ssm.get_parameter(Name=os.environ['OPENAI_API_KEY'], WithDecryption=True)['Parameter']['Value']
  completion = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
	  {"role": "system", 
        "content": """I want you to act as an hardship letter writer for a medical patient. 
        The name of the patient is Joe Doe and he was born on 3/3/2023 and he has been treated for DifficultyB at Chicago Christ Hospital at Chicago. 
        Please express gratitude to the hospital staff."""}
    ],
    stream=True
  )

  for chunk in completion:
    print(chunk)

    uuidStr=str(uuid.uuid4())
    contentStr=chunk["choices"][0]["delta"]["content"].replace("\n", "\\n").replace("\t", "\\t")

    mutation = f'''mutation MyMutation {{ createGptMessage(input: {{ id: \"{uuidStr}\", chunk: \"{contentStr}\", gptSessionGptMessagesId: \"{gptSessionIdStr}"\ }}) {{ 
        id
        chunk
        gptSessionGptMessagesId
        createdAt
        updatedAt
      }}
    }}'''

    response = session.request(
      url=APPSYNC_API_ENDPOINT_URL,
      method='POST',
      headers={
        'x-api-key': APPSYNC_API_KEY,
        'Content-Type': 'application/json'
      },
      json={'query': mutation, 'operationName': 'MyMutation'}
    )

    print(response.content)
  
  return {
      'statusCode': 200,
      'body': ''
  }