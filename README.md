# aws-export-assume-profile

`aws-export-assume-profile` is a bash script that will output AWS export statements of your chosen aws boto profile. In case you have to manage multiple AWS accounts that rely on different boto profiles, you can *activate* a chosen profile by making it available in your shell environment.

This tool requires `aws` cli and retrieves credentials via `aws sts assume-role`. If you are looking for a way to export boto profiles already present in `~/.aws/credentials` have a look at **[aws-export-profile](https://github.com/cytopia/aws-export-profile)**.

[![Build Status](https://travis-ci.org/cytopia/aws-export-assume-profile.svg?branch=master)](https://travis-ci.org/cytopia/aws-export-assume-profile)
![Release](https://img.shields.io/github/release/cytopia/aws-export-assume-profile.svg)

**Note:** Wrap the command in **`$(aws-export-assume-profile)`** to actually export your boto environment variables.


## But why?

Most AWS related tools support boto profiles out of the box, such as the `aws-cli` (Example: `aws ec2 --profile <BOTO_PROFILE>`). However sometimes it is required to have your chosen boto profile available as shell variables. One of the use cases is when you use Docker and want a specific boto login available inside your container.:
```bash
# Export staging boto profile
user> $(aws-export-assume-profile staging)

# Make AWS login available inside your Docker container
user> docker run --rm -it \
  --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --env AWS_REGION=$AWS_REGION \
  my-aws-docker
```


## Available exports

The following export variables are currently supported.

| Variable               | Description |
|------------------------|-------------|
| `AWS_ACCESS_KEY`       | Access key  |
| `AWS_ACCESS_KEY_ID`    | Alternative name for `AWS_ACCESS_KEY`|
| `AWS_SECRET_KEY`       | Secret key  |
| `AWS_SECRET_ACCESS_KEY`| Alternative name for `AWS_SECRET_KEY`|
| `AWS_SESSION_TOKEN`    | Session token |
| `AWS_DELEGATION_TOKEN` | Alternative name for `AWS_SESSION_TOKEN` |
| `AWS_SECURITY_TOKEN`   | Secret token (unset only) |
| `AWS_REGION`           | Region |


## Examples

This tool simply output the exports to stdout. In order to auto-source them, wrap the command in **`$(...)`**.

#### Boto profile `testing`

```bash
user> aws-export-assume-profile testing

export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"
export AWS_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="A1Bc/XXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_KEY="A1Bc/XXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_REGION="eu-central-1"
```

#### Boto profile `testing` with custom paths

```bash
user> aws-export-assume-profile deploy /jenkins/aws/config

export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"
export AWS_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="A1Bc/XXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_KEY="A1Bc/XXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_REGION="eu-central-1"
```

#### Boto profile `production` with more exports
```bash
user> aws-export-assume-profile production

export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"
export AWS_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="A1Bc/XXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_KEY="A1Bc/XXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_SESSION_TOKEN="XXXXXXXXXXXXXXXXx/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXX="
export AWS_REGION="eu-central-1"
```

#### Export boto profile `production`
```bash
user> $(aws-export-assume-profile production)

# Validate
user> env | grep AWS_

AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"
AWS_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXX"
AWS_SECRET_ACCESS_KEY="A1Bc/XXXXXXXXXXXXXXXXXXXXXXXXXXX"
AWS_SECRET_KEY="A1Bc/XXXXXXXXXXXXXXXXXXXXXXXXXXX"
AWS_SESSION_TOKEN="XXXXXXXXXXXXXXXXx/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXX="
AWS_REGION="eu-central-1"
```

#### Unset all AWS_ variables
```bash
user> $(aws-export-assume-profile -u)
```


## Usage

```bash
Usage: aws-export-assume-profile [profile] [config]
       aws-export-assume-profile --unset, -u
       aws-export-assume-profile --help|-h
       aws-export-assume-profile --version|-v

This bash helper will output AWS export statements of your chosen aws boto profile.
Wrap this script in $(aws-export-assume-profile) to export those environment variables.

Optional parameter:
    [profile]      Boto profile name to export. Default is 'default'
    [config]       Path to your aws config file.
                   If no config file is found, AWS_REGION export will not be available.
                   Default is ~/.aws/config

Arguments:
    --unset, -u    Unset currently set AWS variables from env
    --help, -h     Show this help screen
    --version, -v  Show version

Available exports:
    AWS_ACCESS_KEY_ID
    AWS_ACCESS_KEY
    AWS_SECRET_ACCESS_KEY
    AWS_SECRET_KEY
    AWS_SESSION_TOKEN
    AWS_DELEGATION_TOKEN (unset only)
    AWS_SECURITY_TOKEN (unset only)
    AWS_REGION

Examples to show output:
    aws-export-assume-profile testing
    aws-export-assume-profile production /jenkins/aws/config

Examples to export:
    $(aws-export-assume-profile testing)
    $(aws-export-assume-profile production /jenkins/aws/config)

Examples to unset all AWS variables
    $(aws-export-assume-profile -u)
```

## License

**[MIT License](LICENSE.md)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
