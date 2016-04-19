# Customised ElasticBeanstalk ECS AMI with dnsdock

# How to

1. Install packer ( from http://www.packer.io )
2. Load AWS credentials in your environment (the expected environment variable
  names are (`AWS_ACCESS_KEY` and `AWS_SECRET_ACCESS_KEY`)
    * Also, ensure those credentials have the permissions necessary for EC2 
    instance and AMI creation.
3. Run `pack_ami.sh`
    * You must provide a region name, unless `AWS_DEFAULT_REGION` is set and
    you want to go with that
4. Configure the built AMI into your ElasticBeanstalk environment
5. Your containers can now refer to each other using the convention
  `<container name>.docker`

## Why would I need this?

As of the time of this writing, ECS doesn't have an AMI bundling Docker
version 1.10 (first one with built-in container DNS), or support to launch
containers in specific docker networks.

These limitations would prevent a ElasticBeanstalk user from leveraging DNS
discovery between containers.

In general, relying on DNS discovery is much simpler and allows to tackle some
scenarios that could not be tackled with injection of environment variables. An
example is when there are circular dependencies between containers.

## How is it done?

These scripts perform a few small modifications to the AMI provided by Amazon.

The modifications are there to ensure that a container running [dnsdock](https://github.com/tonistiigi/dnsdock) is present in the system, and
that DNS requests from the containers are first going to this dnsdock service.
