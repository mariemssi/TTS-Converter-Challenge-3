# TTS Converter App - Challenge3 - Adding React Frontend (S3, Route53, Cloudfront, ACM)


![image](https://github.com/mariemssi/TTS-Converter-Challenge-3/assets/69463864/6d01d90e-ddc0-4c36-9644-f6bf3164fbd7)


![image](https://github.com/mariemssi/TTS-Converter-Challenge-3/assets/69463864/e44281da-bf5d-4c57-ad02-8733a56d1e52)





The third challenge involves integrating a React frontend with the backend of challenge2, employing AWS services, Terraform for infrastructure management, and GitHub Actions for automated deployment. 
To solve it, new terraform files are added and two new pipelines are created (react-frontend-code-deploy pipeline and frontend-aws-deploy pipeline) 

# Steps to run the solution of challenge 3 

1. Clone the repo of challenge 3
   
2. Create an S3 bucket for the terraform remote backend and update the name of the bucket in "backend-terraform-config.tf" and "frontend-terraform-config.tf"

### Deploy the backend
   
3. Create a versioned S3 bucket for uploading zipped Lambda file

4. Update the **bucket name** and **object key** in "lambda.tf" and **aws-bucket** in the step "Upload to S3" in "lambda-code-upload.yaml" by the bucket created in step 3
   
5. Set your AWS credentials (access key and secret access key) as environment secrets in your github repo with the names "AWS_ACCESS_KEY_ID" and "AWS_SECRET_ACCESS_KEY"

   ![image](https://github.com/mariemssi/TTS-Converter-Challenge-2/assets/69463864/f0029d84-0d2d-4df2-bc20-f4d2d1e4656e)
  
6. Run "lambda-code-upload pipeline" - verify that you have a zipped file in the bucket that you created in step 3

7. After a successful run of the "lambda-code-upload pipeline", the "backend-AWS-deploy pipeline" TTS will be triggered automatically to deploy the TTS Converter App backend Infra. However, the deployment of resources requires manual triggering by selecting the "Apply" input option in the TTS Converter App backend Infra pipeline. 
  
8. Verify that the backend is running correctly in AWS. You can ensure it by running a curl query using the invokeURL of the API Gateway stage, which you can obtain from the output of the Terraform code or directly from the AWS Management Console (you can use the example in [this link](https://medium.com/@lucas.ludicsa99/texttospeechconvertertext-to-speech-converter-using-aws-lambda-polly-and-api-gateway-bf814d2bbe84)) 
   
### Deploy the frontend

9. Set your **domain name**, **S3 frontend bucket name** and **api gateway invoke URL** created in step 7 as secrets in your github repo with the names "DOMAIN_NAME", "S3_FRONTEND_BUCKET" and "API_GATEWAY_INVOKE_URL"
    
11. Trigger "frontend-AWS-deploy pipeline" to create the TTS converter frontend AWS resources.
    
13. Set your **cloudfront distribution id** created in step 10 (output) as secrets in your github repo with the name CLOUDFRONT_DISTRIBUTION_ID
    
15. Trigger "react-frontend-code-deploy" pipeline

16. Open your web browser and navigate to your domain using HTTPS like https://yourdomain.com. If everything is fine, you will receive a result like this:

![image](https://github.com/mariemssi/TTS-Converter-Challenge-3/assets/69463864/a21f7d69-41dc-4b11-a161-cbb75463650f)


You can find more details [here](https://medium.com/@meriemiag/tts-converter-app-challenge3-adding-react-frontend-s3-route53-cloudfront-acm-66936b26ad7f) 

**Note:** After completing testing, remember to select the "Destroy" option in the TTS Converter App Infra pipelines to tear down the resources and prevent unexpected charges from AWS at the end of the month 😉
