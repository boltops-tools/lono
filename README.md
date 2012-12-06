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

The initial lono it also sets up guard-lono and guard-cloudformation.  This continuously generate the cloud formation templates and continuously verify the cloud formation templates via AWS's cfn-validate-template command.