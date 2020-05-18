

## Atlas Image Handler

### Production

```bash
cd deployment
./atlas-deploy.sh build
./atlas-deploy.sh deploy_stack
```

### Staging

```bash
cd deployment
STACK_ENV=staging ./atlas-deploy.sh build
STACK_ENV=staging ./atlas-deploy.sh deploy_stack
```

* `deploy_stack`: Deploy Cloudformation stack
* `build`: Build & package image handler function
* `update`: Trigger lambda function update from built code from s3

***

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
