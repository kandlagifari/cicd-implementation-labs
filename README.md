# cicd-implementation-labs

### (Optional) Run CFN Lint as Docker Container
Please, refer to `https://github.com/aws-cloudformation/cfn-lint`
**Step 1:** Build the Docker Image
```
docker build --tag cfn-python-lint:latest .
```

**Step 2:** Run CFN Lint for the target CloudFormation YAML File
```
docker run --rm -v `pwd`:/data cfn-python-lint:latest /data/cloudformation/final_pipeline.yaml
```
