---
title: Generate the Template
---

With the `config/lono.rb` and `templates/instance.yml.erb` in place, we are ready to generate the CloudFormation templates.  Run the following command:

```sh
lono generate
```

You should see similar output:

```
$ lono generate
Generating both CloudFormation template and parameter files.
Generating CloudFormation templates:
  output/single_instance.yml
  output/instance_and_route53.yml
Generating params files
$
```

Take a look at the generated CloudFormation templates in the output folder and compare them.  You will notice that the route53 logic is in the `instance_with_route53.yml` file and is not in the `single_instance.yml` file.  A quick way to see this is with th `diff` or `colordiff` command.

```
$ diff output/single_instance.yml output/instance_and_route53.yml
85a86,91
>   HostedZoneName:
>     Description: The route53 HostedZoneName. For example, "mydomain.com."  Don't forget the period at the end.
>     Type: String
>   Subdomain:
>     Description: The subdomain of the dns entry. For example, hello -> hello.mydomain.com, hello is the subdomain.
>     Type: String
389a396,405
>   DnsRecord:
>     Type: AWS::Route53::RecordSet
>     Properties:
>       HostedZoneName: !Ref 'HostedZoneName'
>       Comment: DNS name for my instance.
>       Name: !Join ['', [!Ref 'Subdomain', ., !Ref 'HostedZoneName']]
>       Type: CNAME
>       TTL: '900'
>       ResourceRecords:
>       - !GetAtt EC2Instance.PublicIp
$
```

Next we'lll move onto specifying the parameters to be use for lauching the CloudFormation stack.

<a id="prev" class="btn btn-basic" href="/docs/scratch-template-config/">Back</a>
<a id="next" class="btn btn-primary" href="/docs/scratch-params-build/">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

