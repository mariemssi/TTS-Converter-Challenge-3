import json
import boto3
import base64

def lambda_handler(event, context):
    try:
        # Get text to convert from request
        text = event['queryStringParameters']['text']

        # Initialize Polly client
        polly = boto3.client('polly')

        # Synthesize speech
        response = polly.synthesize_speech(
            Text=text,
            OutputFormat='mp3',
            VoiceId='Joanna'
        )

        # Return audio as base64 encoded string
        audio_stream = response['AudioStream'].read()
        audio_base64 = base64.b64encode(audio_stream).decode('utf-8')

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'audio/mpeg',
            },
            'body': audio_base64,
            'isBase64Encoded': True
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }