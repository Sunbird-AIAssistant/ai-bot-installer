# installer
This repository contains code to install the AI bot related services of Sunbird AI Assistant easily
There are the following pre-requisite to be completed before running install.sh from your terminal.
1. User should have cloud account ready with administrative access and have the secret access key and access key id handy.
2. Administrative credentials details will be required and to be provided while running install.sh script.
3. User will need to configure telegram bot and secure public domain to configure webhook URL and add the details for the bot in the global-values.yaml file.
4. User should refer to global-values.yaml file and update each environment variable with the required values.
5. User need to register the domain, add the TXT records in DNS mappings and generate the certificates, private key, domain and add that in the global-values.yaml file. 
6. Please note, global-cloud-values.yaml will be auto-generated during installation with terraform in the path ./helmcharts. if you have any file name as global-cloud-values.yml file in the same path please remove it.

Once ready with above details, user should run installation.

Once all the provisioning completed, user should login to cloud account and map the loadbalancer DNS with the domain name in the DNS mappings in CNAME records.



To set the BOT webhook use the below curl :
curl --location 'https://api.telegram.org/bot{BOT_TOKEN_HERE}/setWebhook' \
--header 'Content-Type: application/json' \
--data '{"url": "{DOMAIN_URL_HERE}/api/webhook/telegram"}' 

Note :  Replace the {BOT_TOKEN_HERE} and {DOMAIN_URL_HERE}/api/webhook/telegram with the actual values.


For accessing the telegram-unified service externally hit the URL : https://<domain_name>/api/webhook/telegram




