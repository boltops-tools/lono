Uploads output/scripts/scripts-md5sum.tgz to s3_folder configured in settings.yml.  This command must be ran after `lono script build` since it relies the artifacts of that command. Namely:

  * output/scripts/scripts-md5sum.tgz
  * output/data/scripts_name.txt

## Examples

  lono script upload
