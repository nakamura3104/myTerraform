// Test GET method
fetch('https://example.com', {
  method: 'GET',
  mode: 'cors',
})
  .then(response => {
    if (response.ok) {
      console.log('CORS is allowed for GET method');
    } else {
      console.log('CORS is not allowed for GET method');
    }
  })
  .catch(error => {
    console.log('An error occurred: ', error);
  });

// Test PUT method
fetch('https://example.com', {
  method: 'PUT',
  mode: 'cors',
})
  .then(response => {
    if (response.ok) {
      console.log('CORS is allowed for PUT method');
    } else {
      console.log('CORS is not allowed for PUT method');
    }
  })
  .catch(error => {
    console.log('An error occurred: ', error);
  });

// Test POST method
fetch('https://example.com', {
  method: 'POST',
  mode: 'cors',
})
  .then(response => {
    if (response.ok) {
      console.log('CORS is allowed for POST method');
    } else {
      console.log('CORS is not allowed for POST method');
    }
  })
  .catch(error => {
    console.log('An error occurred: ', error);
  });
