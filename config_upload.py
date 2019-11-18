import logging
import boto3
#import botostubs
import json
from botocore.exceptions import ClientError


def upload_file(file_name, bucket, object_name=None):
    """Upload a file to an S3 bucket

    :param file_name: File to upload
    :param bucket: Bucket to upload to
    :param object_name: S3 object name. If not specified then file_name is used
    :return: True if file was uploaded, else False
    """

    # If S3 object_name was not specified, use file_name
    if object_name is None:
        object_name = file_name

    # Upload the file
    s3_client = boto3.client('s3')
    try:
        response = s3_client.upload_file(file_name, bucket, object_name)
    except ClientError as e:
        logging.error(e)
        return False
    return True


def lambda_handler(event, context):
    file_name = "test.json"
    bucket = "escssconfiglogs"
    s3upload = upload_file(file_name, bucket)
    if s3upload is True:
        file_name = "url.txt"
        bucket = "escssconfiglogs"
        res = upload_file(file_name, bucket)
        return {
            'statusCode': 200,
            'body': json.dumps("Both config and url.txt has been uploaded")

        }
    else:
        s3upload = False
        return {
            'statusCode': 200,
            'body': json.dumps("The function failed to upload the files")

        }


