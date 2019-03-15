Start aws console with okta authentication

```
docker-compose run --rm aws-console
```

```
source ./okta_aws_login.sh xxxx.okta.com abcdefg123456789xyz mail@mail.com
```

```
source ./assume_role.sh myrole
```

If you want to see the current identity you are autheticated as, invoke the AWS CLI:

```
aws sts get-caller-identity
```
