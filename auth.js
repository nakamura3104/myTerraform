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

      // ここでAPIを呼び出します
      callApi(result.getIdToken().getJwtToken());
    },
    onFailure: (err) => {
      console.error('Sign in error: ', err);
    },
  });
}

// API呼び出し
function callApi(idToken) {
  $.ajax({
    url: 'your_api_endpoint',
    headers: {
      Authorization: idToken
    },
    method: 'GET',
    success: (data) => {
      // レスポンスを表示します
      console.log('API response:', data);
    },
    error: (jqXHR, textStatus, errorThrown) => {
      console.error('API call error:', errorThrown);
    }
  });
}
