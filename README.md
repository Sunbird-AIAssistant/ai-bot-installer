# installer
This repository contains code to install the AI bot related services of Sunbird AI Assistant easily
There are the following pre-requisite to be completed before running install.sh from your terminal.
1. User should have cloud account ready with administrative access and have the secret access key and access key id handy.
2. Administrative credentials details will be required and to be provided while running install.sh script.
3. User will need to configure telegram bot and secure public domain to configure webhook URL and add the details for the bot in the global-values.yaml file.
4. User should refer to global-values.yaml file and update each environment variable with the required values also add the values in ./helmcharts/applications/charts/activitysakhi/configs/gcp.json fie as well.
5. User need to register the domain, add the TXT records in DNS mappings and generate the certificates, private key, domain and add that in the global-values.yaml file. 
6. Please note, global-cloud-values.yaml will be auto-generated during installation with terraform in the path ./helmcharts. if you have any file name as global-cloud-values.yml file in the same path please remove it.
7. Please note, indexing of the documents on Marqo to be done manually once completions of all the provisioning of infra and deployment of the service.
8. Once all the provisioning will done just login to cloud account and map the loadbalancer DNS with the domain name in the DNS mappings in CNAME records.


Once ready with above details, user should run installation.

For creating the Certificates and private key for your domain follow the steps : 
1. go to https://punchsalad.com/ssl-certificate-generator/ and put the required domain name, add mail ID, select DNS and Accept and click on create free SSL certificate.
2. After that you will get a TXT record and its value add that both values in your DNS mappings and click on Check DNS.
3. Once the DNS checking is done click on the verify domain 
4. After that you will get the ca-bundle.txt file and a private-key.txt file download it.
5. Update these both files in the global-values.yaml file.

For mapping the Loadbalancer with the DNS follow the steps : 
1. Once all the infra provisioning is done just login to cloud account 
2. Go to ec2 console and under Loadbalncing go to loadbalancer dashboard.
3. Copy the Loadbalancer DNS record mapped with the VPC sbai.
4. Go to your DNS mappings under CNAME records add the sub-domain name and in values add the loadbalancer DNS and save.

To set the BOT webhook use the below curl :
curl --location 'https://api.telegram.org/bot{BOT_TOKEN_HERE}/setWebhook' \
--header 'Content-Type: application/json' \
--data '{"url": "{DOMAIN_URL_HERE}/api/webhook/telegram"}' 

Note :  Replace the {BOT_TOKEN_HERE} and {DOMAIN_URL_HERE}/api/webhook/telegram with the actual values.


For accessing the telegram-unified service externally hit the URL : https://<domain_name>/api/webhook/telegram




