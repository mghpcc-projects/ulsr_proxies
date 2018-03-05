Serverless framework (https://serverless.com) code that creates an AWS Lambda function to access DynamoDB, and with a set of API Gateway endpoints for uploading and retrieving DyanmoDB items.

To deploy

  ```sls deploy --stage XXXXX```
  
where ```XXXX``` is a veraion and instance id string that can be used to support multiple versions and instances, supporting both production and development activities as well as different systems.

Instructions on configuring the serverless framework can be found at the project [web site](https://serverless.com). 

When initially setting up a serverless environment for the code AWS IAM credentials will need to be specified using ```sls configure```.
