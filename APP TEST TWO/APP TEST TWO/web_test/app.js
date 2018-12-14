// Initialize Firebase





// // Initialize Firebase
// var config = {
//   apiKey: "AIzaSyD3Cu8Q2kOAe0aPdJIZ6DrB64LtMeJVcgo",
//   authDomain: "app-test-ii.firebaseapp.com",
//   databaseURL: "https://app-test-ii.firebaseio.com",
//   projectId: "app-test-ii",
//   storageBucket: "app-test-ii.appspot.com",
//   messagingSenderId: "1028572679976"
// };
// firebase.initializeApp(config);

//Get Elements

// Browserify Setup



var preObject = document.getElementById('object');


// Create reference
var dbRefObject = firebase.database().ref().child('Posts')



// Sync object changes
dbRefObject.on('value', snap => console.log(snap.val()));
