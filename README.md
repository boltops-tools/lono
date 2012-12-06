Lono
===========

Lono generates Cloud Formation templates based on ERB templates. 

Usage
------------

<pre>
$ gem install lono
$ mkdir lono_project
$ lono init 
</pre>

This sets up the basic lono project with an example template in source/app.json.erb.

<pre>
$ lono generate
</pre>

This generates the templates that have been defined in config/lono.rb.

<pre>
$ guard
</pre>

The lono init comamnd also sets up guard-lono and guard-cloudformation.  Guard-lono continuously generates the cloud formation templates and guard-cloudformation continuously verifies that the cloud formation templates are valid via AWS's cfn-validate-template command.