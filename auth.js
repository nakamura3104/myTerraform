// Cognito User Poolの設定
const poolData = {
  UserPoolId: 'your_user_pool_id',
  ClientId: 'your_client_id',
};

const userPool = new AmazonCognitoIdentity.CognitoUserPool(poolData);

// サインインフォームのサブミットイベントをリッスン
$('#signin-form').submit((event) => {
  event.preventDefault();

  const username = $('#username').val();
  const password = $('#password').val();

  signIn(username, password);
});

// サインイン処理
function signIn(username, password) {
  const authenticationDetails = new AmazonCognitoIdentity.AuthenticationDetails({
    Username: username,
    Password: password,
  });

  const cognitoUser = new AmazonCognitoIdentity.CognitoUser({
    Username: username,
    Pool: userPool,
  });

  cognitoUser.authenticateUser(authenticationDetails, {
    onSuccess: (result) => {
      console.log('Sign in success');
      console.log('Access token: ' + result.getAccessToken().getJwtToken());
      console.log('ID token: ' + result.getIdToken().getJwtToken());
      console.log('Refresh token: ' + result.getRefreshToken().getToken());
    },
    onFailure: (err) => {
      console.error('Sign in error: ', err);
    },
  });
}
