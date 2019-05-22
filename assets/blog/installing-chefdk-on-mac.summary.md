# Getting Started With ChefDK
#meta sort 2019-05-22
### May 22, 2019

I am getting back into [Chef](https://www.chef.io/), and the landscape
seems to have changed quite a bit in the last 10 years.  I am going
to documenting the journey in a series of bite sized articles.

```
CHEF_VERSION=3.10.1 && \
  CHEF_SUBV=1 && \
  MACOSX_VERSION=$(sw_vers | grep ProductVersion | egrep -o '\d+\.\d+') && \
  curl -o /tmp/chefdk.dmg \
    https://packages.chef.io/files/stable/chefdk/${CHEF_VERSION}/mac_os_x/${MACOSX_VERSION}/chefdk-${CHEF_VERSION}-${CHEF_SUBV}.dmg && \
  open /tmp/chefdk.dmg
```