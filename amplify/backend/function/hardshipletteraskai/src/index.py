import boto3
import json
import openai
import os

ssm = boto3.client('ssm')

def handler(event, context):

  param1 = ssm.get_parameter(Name=os.environ['OPENAI_API_KEY'], WithDecryption=True)

  openai.api_key = param1['Parameter']['Value']
  completion = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
	  {"role": "system", 
        "content": "I want you to act as an hardship letter writer for a medical patient. The name of the patient is Joe Doe and he was born on 3/3/2023 and he has been treated for DifficultyB at HospitalA at Chicago. Please express gratitude to the hospital staff."}
    ]
  )

  print(completion)
  print(event)
  
  return {
      'statusCode': 200,
      'headers': {
          'Access-Control-Allow-Headers': '*',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
      },
      'body': json.dumps('Hello from your new Amplify Python lambda!')
  }