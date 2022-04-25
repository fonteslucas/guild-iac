
# Arquivo: template-tf
## Introdução
Esse módulo tem como função fazer a validação e deploy de templates em  terraform. A pipeline visa a validação de recursos de infraestrutura (não contempla testes unitários e build de aplicações docker, por hora).

<!--ts-->
   * [Sobre](#Sobre)
     * [High Level Design](#high-level-design)
   * [Como usar](#como-usar)
   * [Tecnologias](#tecnologias)
   * [Serviços criados com o Formation](#serviços-criados-com-o-formation)
<!--te-->


## Sobre
Através da criação de uma pipeline com o **CodeBuild** esse template tem como função fazer a validação de arquivos terraforms enviados para a conta aws. Usando as ferramentas **TFSec** e **TFLint** esse formation quando rodado na conta, cria a pipeline que irá automaticamente realizar a validação dos arquivos terraform.

### High Level Design

![High Level Design](/imagens/design-high-level.png "This is a High Level Design image.")

## Tecnologias
As seguintes tecnologias são usadas dentro do projeto:
- [AWS Commit](https://docs.aws.amazon.com/codecommit/latest/userguide/welcome.html)
- [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html)
- [AWS CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html)
- [TFLint](https://github.com/terraform-linters/tflint)
- [TFSec](https://github.com/aquasecurity/tfsec)

## Como usar
1 - Primeiramente é necessário abrir o serviço do CloudFormation  e criar a stack com o arquivo template-tf.yaml
2 - Coloque o nome da Stack e Bucket de preferencia e crie a stack.
3 - Após isso aguarde a criação dos serviços.

## Serviços criados com o Formation
- Primeiramente será criado o CodeCommit, onde os arquivos terraform serão depositados para passar na pipeline:
- 
```
 rCodeCommitRepository:
    Type: AWS::CodeCommit::Repository
    Properties:
      RepositoryName: !Ref pSourceRepoName
    DeletionPolicy: Delete
```

- Logo após o trigger será definido para que a pipeline possa ser acionada assim que o upload do arquivo terraform seja feito no CodeCommit.

```
rTriggerRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
        - Effect: Allow
          Principal:
            Service: 
            - events.amazonaws.com
          Action: 
          - sts:AssumeRole
      Path: /
      Policies:
        - PolicyName: !Sub start-pipeline-execution-${AWS::Region}-${pSourceRepoName}
          PolicyDocument:
            Statement:
            - Effect: Allow
              Action: "codepipeline:StartPipelineExecution"
              Resource: !Sub arn:aws:codepipeline:${AWS::Region}:${AWS::AccountId}:${rPipeline}

  rCodeCommitRepoTrigger:
    Type: AWS::Events::Rule
    Properties:
      Description: Trigger the pipeline on change to repo/branch
      EventPattern:
        source:
          - "aws.codecommit"
        detail-type:
          - "CodeCommit Repository State Change"
        resources:
          - !GetAtt rCodeCommitRepository.Arn
        detail:
          event:
            - "referenceCreated"
            - "referenceUpdated"
          referenceType:
            - "branch"
          referenceName:
            - !Ref pSourceRepoBranch
      RoleArn: !GetAtt rTriggerRole.Arn
      State: ENABLED
      Targets: 
        - Arn: !Sub arn:aws:codepipeline:${AWS::Region}:${AWS::AccountId}:${rPipeline}
          Id: !Sub codepipeline-${pSourceRepoName}-${pSourceRepoBranch}-pipeline
          RoleArn: !GetAtt rTriggerRole.Arn

```

- Tambem será criada uma role que será configurada dando permissão total aos Buckets **rTFStateBucket** e **rArtifactBucket** para o CodeBuild. A policy necessária também será criada juntamente a esse parametro. 
Veja que os **resources** estão referenciando o **rTFStateBucket** e **rArtifactBucket**, recursos que serão criados mais a frente no código. Observe o bloco de código abaixo:

```
  rCodeBuildTFRole:
    Type: AWS::IAM::Role
    DeletionPolicy: Delete
    Properties:
      Path: /
      AssumeRolePolicyDocument:
        Statement:
        - Effect: Allow
          Principal:
            Service:
            - codebuild.amazonaws.com
          Action:
          - sts:AssumeRole
      Policies:
        - PolicyName: tfpolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Resource: '*'
                Effect: Allow
                Action: '*'
              - Resource: !Sub arn:aws:s3:::${rTFStateBucket}
                Effect: Allow
                Action:
                  - s3:List*
              - Resource: !Sub arn:aws:s3:::${rTFStateBucket}/*
                Effect: Allow
                Action:
                  - s3:GetObject
                  - s3:PutObject
              - Resource: !Sub arn:aws:s3:::${rArtifactBucket}/*
                Effect: Allow
                Action:
                  - s3:GetObject
                  - s3:PutObject
                  - s3:GetObjectVersion

```

- Agora serão dada as devidas permissões para o **CodePipeline**, e criada a sua policy:

``` 
 rCodePipelineServiceRole:
    Type: AWS::IAM::Role
    DeletionPolicy: Delete
    Properties:
      Path: /
      AssumeRolePolicyDocument: 
        Statement:
        - Effect: Allow
          Principal:
            Service:
            - codepipeline.amazonaws.com
          Action:
          - sts:AssumeRole
      Policies:
        - PolicyName: codepipelinepolicy
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Resource:
                  - !Sub arn:aws:s3:::${rArtifactBucket}/*
                Effect: Allow
                Action:
                  - s3:PutObject
                  - s3:GetObject
                  - s3:GetObjectVersion
                  - s3:GetBucketVersioning
              - Resource: "*"
                Effect: Allow
                Action:
                  - codebuild:StartBuild
                  - codebuild:BatchGetBuilds
                  - cloudformation:*
                  - iam:PassRole
                  - codecommit:CancelUploadArchive
                  - codecommit:GetBranch
                  - codecommit:GetCommit
                  - codecommit:GetUploadArchiveStatus
                  - codecommit:UploadArchive
```

- Dadas as devidas permissões será feita a criação dos dois buckets que foram referenciando anteriormente, **rArtifactBucket** (hospedará o state do terraform) e  **rTFStateBucket** (hosperadará os artefatos da pipeline):

```
rArtifactBucket:
    Type: AWS::S3::Bucket
    DeletionPolicy: Retain
    UpdateReplacePolicy: Delete
  
  rTFStateBucket:
    Type: AWS::S3::Bucket
    DeletionPolicy: Retain
    UpdateReplacePolicy: Delete

```

- A próxima etapa realizada pelo código é a construção de duas builds no CodeBuild.     
  - Primeiramente será criada a build correspondente ao **TFLint**:
  
  ```
  rTFLintCodeBuildProject:
      Type: AWS::CodeBuild::Project
      Properties:
          Name: !Sub ${pSourceRepoName}-tf-lint-code-build-project
          Description: CodeBuild Project to validate terraform templates using tf-lint
          Artifacts:
            Type: CODEPIPELINE
          Environment:
              Type: LINUX_CONTAINER
              ComputeType: BUILD_GENERAL1_SMALL
              Image: aws/codebuild/amazonlinux2-x86_64-standard:2.0
          ServiceRole:
            !GetAtt rCodeBuildTFRole.Arn
          Source:
              Type: CODEPIPELINE
              BuildSpec: |
                version: 0.2
                phases:
                  pre_build:
                    commands:
                    - echo "Executing tflint"
                    - mkdir -p $CODEBUILD_SRC_DIR/infra/tflint/
                    - curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
                  build:
                      commands:
                      - cd "$CODEBUILD_SRC_DIR/infra"
                      - tflint --init
                      - ls
                      - tflint -f junit > "tflint/tflint_report.xml"
                      - ls tflint
                reports:
                    tflint:
                      files:
                        - infra/tflint/*.xml
                      file-format": "JUNITXML"
  
  ```
  
  - Logo após será inserida a build do **TFSec**:
  
  ```
  rTFSecCodeBuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
        Name: !Sub ${pSourceRepoName}-tf-sec-code-build-project
        Description: CodeBuild Project to validate terraform templates using tf-sec
        Artifacts:
          Type: CODEPIPELINE
        Environment:
            Type: LINUX_CONTAINER
            ComputeType: BUILD_GENERAL1_SMALL
            # With the image below we must specify a runtime-version in the Buildspec (see below)
            Image: tfsec/tfsec:latest
            EnvironmentVariables:
              - Value: !Ref AWS::Region
                Name: AWS_DEFAULT_REGION
        ServiceRole:
          !GetAtt rCodeBuildTFRole.Arn
        Source:
            Type: CODEPIPELINE
            BuildSpec: |
              version: 0.2
              env:
                exported-variables: 
                    - BuildID
                    - BuildTag
                    - Region
                    - checks_errors
                    - check_high
                    - check_warning
                    - check_low
                git-credential-helper: yes
              phases:
                  pre_build:
                      commands:
                      - echo "Executing tfsec"
                      - apk update
                      - apk add git
                      - mkdir -p $CODEBUILD_SRC_DIR/infra/tfsec/
                  build:
                      commands:
                      - tfsec --version
                      - cd $CODEBUILD_SRC_DIR/infra
                      - git --version
                      - ls
                      - git clone https://git-codecommit.us-west-2.amazonaws.com/v1/repos/tf-sec
                      - ls tf-sec/
                      - cat tf-sec/tag_tfchecks.yaml
                      - tfsec -s --tfvars-file terraform.tfvars --custom-check-dir tf-sec --format junit > tfsec/report.xml
                      - num_errors=$(tfsec -s --tfvars-file terraform.tfvars |  grep ERROR | wc -l)
                      - num_high=$(tfsec -s --tfvars-file terraform.tfvars |  grep HIGH | wc -l)
                      - num_warning=$(tfsec -s --tfvars-file terraform.tfvars |  grep WARNING | wc -l)
                      - num_low=$(tfsec -s --tfvars-file terraform.tfvars |  grep LOW | wc -l)
                      - export BuildID=$(echo $CODEBUILD_BUILD_ID | cut -d':' -f1)
                      - export BuildTag=$(echo $CODEBUILD_BUILD_ID | cut -d':' -f2)
                      - export Region=$AWS_DEFAULT_REGION
                      - export checks_errors=$num_errors
                      - export check_high=$num_high
                      - export check_warning=$num_warning
                      - export check_low=$num_low
              reports:
                  tfsec-reports:
                    files: 
                      - infra/tfsec/*.xml
                    file-format: "JUNITXML"

  ```
- Agora será criado no CodeBuild um Container Linux que irá fazer o _terraform init_ e _terraform plan_ do projeto, dando ao desenvolvedor a tarefa de validar manualmente se seu terraform está da forma como deseja:

```
  rTFPlanCodeBuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
        Name: !Sub ${pSourceRepoName}-tf-plan-code-build-project
        Description: CodeBuild Project to plan terraform templates
        Artifacts:
          Type: CODEPIPELINE
        Environment:
            Type: LINUX_CONTAINER
            ComputeType: BUILD_GENERAL1_SMALL
            Image: aws/codebuild/amazonlinux2-x86_64-standard:2.0
            EnvironmentVariables:
              - Value: !Ref pTFVersion
                Name: TFVERSION
        ServiceRole:
          !GetAtt rCodeBuildTFRole.Arn
        Source:
            Type: CODEPIPELINE
            BuildSpec: !Sub |
              version: 0.2
              phases:
                  install:
                      commands:
                      - cd /usr/bin
                      - curl -s -qL -o terraform.zip "https://releases.hashicorp.com/terraform/$TFVERSION/terraform_$(echo $TFVERSION)_linux_amd64.zip"
                      - unzip -o terraform.zip
                  build:
                      commands:
                      - echo Terraform deployment started on `date`
                      - cd "$CODEBUILD_SRC_DIR/infra"
                      - echo "terraform" { > backend.tf
                      - echo "   backend \"s3\" {} " >> backend.tf
                      - echo "}" >> backend.tf
                      - terraform init -input=false --backend-config="bucket=${rTFStateBucket}" --backend-config="key=${pSourceRepoName}-${pSourceRepoBranch}.tfsate" --backend-config="region=${AWS::Region}"
                      - terraform plan -input=false -var-file=./variables-${pSourceRepoBranch}.tfvars
                  post_build:
                      commands:
                      - echo "Terraform completed on `date`"
  ```
                      
- Seguindo a mesma lógica será feito o _terraform apply_ do terraform caso ele esteja em conformidade:

```
rTFApplyCodeBuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
        Name: !Sub ${pSourceRepoName}-tf-apply-code-build-project
        Description: CodeBuild Project to apply terraform templates
        Artifacts:
          Type: CODEPIPELINE
        Environment:
            Type: LINUX_CONTAINER
            ComputeType: BUILD_GENERAL1_SMALL
            Image: aws/codebuild/amazonlinux2-x86_64-standard:2.0
            EnvironmentVariables:
              - Value: !Ref pTFVersion
                Name: TF_VERSION
        ServiceRole:
          !GetAtt rCodeBuildTFRole.Arn
        Source:
            Type: CODEPIPELINE
            BuildSpec: !Sub |
              version: 0.2
              phases:
                  install:
                      commands:
                      - cd /usr/bin
                      - curl -s -qL -o terraform.zip "https://releases.hashicorp.com/terraform/$TFVERSION/terraform_$(echo $TFVERSION)_linux_amd64.zip"
                      - unzip -o terraform.zip
                  build:
                      commands:
                      - echo Terraform deployment started on `date`
                      - cd "$CODEBUILD_SRC_DIR/infra"
                      - echo "terraform" { > backend.tf
                      - echo "   backend \"s3\" {} " >> backend.tf
                      - echo "}" >> backend.tf
                      - terraform init -input=false --backend-config="bucket=${rTFStateBucket}" --backend-config="key=${pSourceRepoName}-${pSourceRepoBranch}.tfsate" --backend-config="region=${AWS::Region}"
                      - terraform apply -input=false -var-file=./variables-${pSourceRepoBranch}.tfvars -auto-approve
                  post_build:
                      commands:
                      - echo "Terraform completed on `date`"

```

- Configurado o CodeBuild, partiremos agora para o CodePipeline, fazendo toda a sua configuração, juntanto e ordenando respsctivos builds que criamos anteriormente juntamente as definições do CodeBuild.

```
rPipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      RoleArn: !GetAtt rCodePipelineServiceRole.Arn
      RestartExecutionOnUpdate: False
      ArtifactStore:
        Type: S3
        Location: !Ref rArtifactBucket
      Name:  !Sub "${pSourceRepoName}-${pSourceRepoBranch}-Pipeline"
      # DisableInboundStageTransitions:
      #   - Reason: "Testing - Do not build when create or update this CFN"
      #     StageName: "Build"
      Stages:
        - Name: Source
          Actions:
            - Name: Source
              ActionTypeId:
                Category: Source
                Owner: AWS
                Version: "1"
                Provider: CodeCommit
              Configuration:
                RepositoryName: !Ref pSourceRepoName
                BranchName: !Ref pSourceRepoBranch
                PollForSourceChanges: false
              OutputArtifacts:
                - Name: SourceOutput
              RunOrder: 1
        - Name: ValidateTemplate
          Actions:
            - Name: TF-Lint
              ActionTypeId:
                Category: Build
                Owner: AWS
                Version: "1"
                Provider: CodeBuild
              Configuration:
                ProjectName: !Ref rTFLintCodeBuildProject
              InputArtifacts:
                - Name: SourceOutput
              RunOrder: 1
            - Name: TF-Sec
              ActionTypeId:
                Category: Build
                Owner: AWS
                Version: "1"
                Provider: CodeBuild
              Namespace: "TFSEC"
              Configuration:
                ProjectName: !Ref rTFSecCodeBuildProject
              InputArtifacts:
                - Name: SourceOutput
              RunOrder: 1
        - Name: TerrafromActions
          Actions:
            - Name: approval-tfsec
              ActionTypeId:
                Category: Approval
                Owner: AWS
                Version: "1"
                Provider: Manual
              RunOrder: 1
              Configuration:
                CustomData: "tfsec errors found: #{TFSEC.checks_errors}, tfsec high found: #{TFSEC.check_high}, tfsec warning found: #{TFSEC.check_warning}, tfsec low found: #{TFSEC.check_low}"
                ExternalEntityLink: !Sub "https://#{TFSEC.Region}.console.aws.amazon.com/codesuite/codebuild/${AWS::AccountId}/projects/#{TFSEC.BuildID}/build/#{TFSEC.BuildID}%3A#{TFSEC.BuildTag}/reports?region=#{TFSEC.Region}"
            - Name: terraform-plan
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: 1
              RunOrder: 2
              InputArtifacts:
                - Name: SourceOutput
              Configuration:
                ProjectName: !Ref rTFPlanCodeBuildProject
            - Name: approval-terraform-plan
              ActionTypeId:
                Category: Approval
                Owner: AWS
                Version: "1"
                Provider: Manual
              RunOrder: 3
            - Name: terraform-apply
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: 1
              RunOrder: 4
              InputArtifacts:
                - Name: SourceOutput
              Configuration:
                ProjectName: !Ref rTFApplyCodeBuildProject

```