## Prerequisites
1. Java runtime, we are using OpenJDK, should also work with Oracle Java
2. `bash`, `kubectl`, `aws cli`, configured connection to the EKS cluster
3. Configured namespace `adx` with installed operator and running etcd cluster
4. Install Jinni, we will use Jinni to encrypt application secrets
 * Download and unzip the [Jinni archive](https://github.com/braintribehq/sns-resources/raw/main/resources/jinni-2.1.83-application.zip) from Github
 * Test that you are able to encrypt simple text `bin/jinni.sh : encrypt --value 'secretTextToEncrypt'`, you should get some output without errors
5. Working PostgreSQL knowledge, some management tool e.g. `psql`

## Set up Postgresql database
1. Create Postgresql Aurora instance
2. Allow access from the EKS cluster
2. Create a new user in this instance: `create user dbuser with createdb; \password dbuser`
3. Connect with the newly created user. Then create a new database in the instance, we will use the same database for DCSA, conversion and as a main database. It is also possible to create 3 separate databases especially for PROD deployments. `create database db_name`
4. Encrypt the database password using Jinni, you will need it later

## Create S3 bucket
1. Create IAM user that will be used to access the bucket
2. Allow programatic access, create access keys
3. Encrypt access key secret and key id using Jinni, you will need it later
4. Create S3 bucket that will be used to store documents
5. Grant access to it to the S3 user

## Create k8s secrets
1. Run the helper script to create secrets `./create-additional-db-credentials.sh -n adx -u database_user -p encrypted_database_password -- database_credentials`
2. Verify that credentials have been created `kubectl -n adx get secret database_credentials`

## Configure the Tribefire Runtime
1. We are going to edit the file `resources/adx.yaml`
2. Replace placeholders with correct values:
 * `__DATABASE_HOST__`
 * `__DATABASE_NAME__`
 * `__S3_ACCESS_KEY_ENCRYPTED__` - use the encrypted access key id for the S3 user
 * `__S3_BUCKET_NAME__`
 * `__S3_SECRET_ENCRYPTED__` -  - use the encrypted secret access key for the S3 user
 * `__S3_CACHE_ACCESS_KEY_ENCRYPTED__` - use the same as for the S3 bucket
 * `__S3_CACHE_SECRET_ENCRYPTED__` - also the same as for the S3 bucket
 * `__DOMAIN__`
 * `__DB_USER__`
 * `__DB_PASSWORD_ENCRYPTED__`
 * `__CONV_DB_USER__` -  the same as the DB user
 * `__CONV_DB_PASSWORD_ENCRYPTED__` - the same as the DB password

## Deploy the Tribefire Runtime
1. Deploy the configured runtime.yaml: `kubectl -n adx apply -f resources/adx.yaml`
2. Check Tribefire component status `kubectl -n adx get pods`

## Connect to the runtime
1. Get HOST from ingress: `kubectl -n adx get ing`
2. Connect to `https://HOST/services`