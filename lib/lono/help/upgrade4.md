Lono version 4 changed a few things:

* Simplified the [directory structure](http://lono.cloud/docs/directory-structure/) of a lono project.
* Format of the [settings.yml](http://lono.cloud/docs/settings/) changed.
* LONO_ENV are longer full names now.
* Refer to the [CHANGELOG](https://github.com/tongueroo/lono/blob/master/CHANGELOG.md) for more details.

This task helps you upgrade from lono version 3 to version 4.

### Example Output

    $ lono upgrade4
    Upgrading structure of your current project to the new lono version 4 project structure
    mv helpers app/helpers
    mv params config/params
    mv config/templates app/definitions
    mv templates app/templates
    mv app/templates/partial app/partials
    mv app/partials/user_data app/user_data
    Updating structure of config/variables
    Updating structure of app/definitions
    mv config/params/prod config/params/production
    mv config/params/stag config/params/staging
    Upgrade to lono version 4 complete!
    $
