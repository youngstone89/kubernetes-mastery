https://spinnaker.io/setup/artifacts/github/

## Place the token in a file ($TOKEN_FILE) readable by Halyard:
echo $TOKEN > $TOKEN_FILE


## Editing your artifact settings
TOKEN_FILE=token_file
ARTIFACT_ACCOUNT_NAME=youngstone89-github-artifact-account

## Enabling artifact support
hal config features edit --artifacts-rewrite true


## enable the GitHub artifact provider:
hal config artifact github enable

## Next, add an artifact account:
hal config artifact github account add $ARTIFACT_ACCOUNT_NAME \
    --token-file $TOKEN_FILE
