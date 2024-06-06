# Part 1: Install SAM CLI
You can refer this [documentation](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) to install SAM CLI based on your OS
```shell
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip

unzip aws-sam-cli-linux-x86_64.zip -d sam-installation

sudo ./sam-installation/install

sam --version
```

# Part 2: Deploy Backend Infra
**Step 1:** Change directory to **cicd-implementation-labs** folder and use AWS SAM to build **template.yaml** file.
```shell
cd cicd-implementation-labs/
sam build
sam deploy --guided
```

**Step 2:** 
Then, you will be presented with the AWS SAM deploy configuration. For *Stack Name*, type **trivia-app**. For other configurations, leave the default by pressing **Enter**.