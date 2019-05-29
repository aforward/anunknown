# Using CHEF Kitchen with AWS
### May 27, 2019

In our first article, we looked at [Installing ChefDK on your mac](/articles/installing-chefdk-on-mac).
Here we are going to get [Kitchen](https://kitchen.ci/) connected to your AWS account
using the [Official kitchen-ec2 Driver](https://github.com/test-kitchen/kitchen-ec2)

## Connect To AWS using SAML

Let's install [saml2aws](https://github.com/Versent/saml2aws) to allow
us to login and retrieve AWS temporary credentials.  This uses SAML with
ADFS or PingFederate Identity Providers.

```
brew tap versent/homebrew-taps
brew install saml2aws
```

Now let's configure account access (and 12 hour access)

```
saml2aws configure -a [AWS Account Name] --session-duration 43200
```

The output should look similar to

```
? Please choose a provider:  [Use arrows to move, type to filter]
❯ ADFS
  ADFS2
  F5APM
  GoogleApps
  JumpCloud
  KeyCloak
  Okta
```

Answer the questions and now you should be able to login using

```
saml2aws login -a [AWS Account Name]
```


