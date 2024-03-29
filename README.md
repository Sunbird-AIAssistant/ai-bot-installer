# installer
This repository contains code to install the AI bot related services of Sunbird AI Assistant easily. Currently it has support for installation on AWS environment.

There are the following pre-requisite to be completed before running install.sh from your terminal.
1. Have cloud account ready with administrative access and have the secret access key and access key id handy.
2. Administrative credentials details will be required and to be provided while running install.sh script.
3. In case the bot service needs to be enabled through Telegram, you will need to create a telegram bot and secure public domain to configure webhook URL and add the details for the bot in the global-values.yaml file.
4. Refer to global-values.yaml file and update each environment variable with the required values.
5. Register the domain, add the TXT records in DNS mappings and generate the certificates, private key, domain and add that in the global-values.yaml file. 
6. Please note, global-cloud-values.yaml will be auto-generated during installation with terraform in the path ./helmcharts. if you have any file name as global-cloud-values.yml file in the same path please remove it.

Once ready with above details,  run the installation script (install_on_aws.sh) it will run the below pods :
1. activitysakhi
2. applications-unifiedtelegram
3. kong
4. marqo
5. postgres
6. redis
7. nginx-public-ingress

and complete the below migrations and installations :
1. kong-api
2. kong-consumer
3. kong-migrations
4. postgres-provision-postgres-migration

Once all the provisioning completed, login to cloud account and map the loadbalancer DNS with the domain name in the DNS mappings in CNAME records.

To set the BOT webhook use the below curl :
curl --location 'https://api.telegram.org/bot{BOT_TOKEN_HERE}/setWebhook' \
--header 'Content-Type: application/json' \
--data '{"url": "{DOMAIN_URL_HERE}/api/webhook/telegram"}' 

Note :  Replace the {BOT_TOKEN_HERE} and {DOMAIN_URL_HERE}/api/webhook/telegram with the actual values.

For accessing the telegram-unified service externally hit the URL : https://<domain_name>/api/webhook/telegram

Once installation is complete, to enable a specific use case, you can follow the below steps to index all the related contents:  

1. Install python on the machine from where the files need to be ingested
2. Place the files to be indexed in a folder in the machine.
3. Download index_documents.py and requirements-dev.txt file from https://github.com/Sunbird-AIAssistant/sakhi-api-service 
4. Run the following:
pip install -r requirements-dev.txt python3 index_documents.py --marqo_url=<MARQO_URL> --index_name=<MARQO_INDEX_NAME> --folder_path=<PATH_TO_INPUT_FILE_DIRECTORY> --fresh_index

Notes: 
1. Please run the commands via screen background as it will take couple of hours to run
2. “--fresh_index” is to be used when you are running the indexing for the first time or when you delete the existing index and freshly index it.  If you want to append new files to the existing index, run it without --fresh_index
3. For running without --fresh_index, make sure that your new files are kept in a new folder and the --folder_path is pointed to only the new set of files.
