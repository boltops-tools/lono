# Blueprint Starter README

## Usage

1. Configure: configs/BLUEPRINT values
2. Deploy blueprint

## Configure

First you want to configure the `configs/BLUEPRINT/params` and `configs/BLUEPRINT/variables` files.

If the blueprint has implemented it, you can use `lono seed` to quickly configure starter values for these `config/BLUEPRINT` files.

    LONO_ENV=development lono seed BLUEPRINT --args key1:value1 key2:value2

To additional environments:

    LONO_ENV=production  lono seed BLUEPRINT --args key1:value1 key2:value2

The generated files in `config/BLUEPRINT` folder look something like this:

    configs/BLUEPRINT/
    ├── params
    │   ├── development.txt
    │   └── production.txt
    └── variables
        ├── development.rb
        └── production.rb

The PARAM depends on how the blueprint was authored.  The PARAM conventionally defaults to BLUEPRINT.

## Deploy

Use the [lono cfn deploy](http://lono.cloud/reference/lono-cfn-deploy/) command to deploy. Example:

    LONO_ENV=development lono cfn deploy BLUEPRINT-development --blueprint BLUEPRINT --iam
    LONO_ENV=production  lono cfn deploy BLUEPRINT-production --blueprint BLUEPRINT --iam
