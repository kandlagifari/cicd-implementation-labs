**NOTE:** Currently API Gateway Web Socket is not supported in Jakarta Region, please use N. Virginia Region


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
![Alt text](pics/03_sam-build.png)

**Step 2:** 
Then, you will be presented with the AWS SAM deploy configuration. For *Stack Name*, type **trivia-app**. For other configurations, leave the default by pressing **Enter**.

![Alt text](pics/04_sam-deploy-1.png)

![Alt text](pics/05_sam-deploy-2.png)

**Step 3:** Still in the terminal, pay attention to the *Outputs* table. Copy the **Value** from the API Gateway websockets endpoint. The values ​​will look like this:
```shell
wss://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com/Prod
```


# Part 3: Testing the Frontend
**Step 1:** Please open the file *cicd-implementation-labs/front-end-react/src/config.js* (you can use the toggletree alias Explorer on the left), then update the *WebsocketEndpoint* value with the endpoint you copied earlier. If so, make sure you save the file by pressing the CTRL+S combination.
```shell
module.exports = {
  WebsocketEndpoint: 'wss://xxxxxxxxxx.execute-api.ap-southeast-1.amazonaws.com/Prod'
};
```

**Step 2:** Back in the your terminal, set the Node version to v16 (codename: Gallium).
```shell
nvm install lts/gallium
nvm alias default lts/gallium
```

**Step 3:** Move to the front-end-react folder, install NPM dependencies, then run Trivia App.
```shell
cd front-end-react/
npm install
npm run start
```

**Note:** There is currently an issue with webpack dependencies with Node v17 version. If you see an error like this: 'ERR_OSSL_EVP_UNSUPPORTED', make sure to run the application with Node v16 version.

**Step 4:** After the NPM dependencies installation is complete, you may see NPM warnings. Don't worry, don't worry about it for now. You can continue to the next step.

**Step 5:** You will see the Trivia App running. Please try Trivia App to your heart's content.

![Alt text](pics/06_app-run.png)

If you deploy on server, you can also see on the browser
![Alt text](pics/07_access-app.png)