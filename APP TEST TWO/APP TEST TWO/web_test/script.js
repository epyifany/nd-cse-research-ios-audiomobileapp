// Initialize Firebase
var config = {
  apiKey: "AIzaSyD3Cu8Q2kOAe0aPdJIZ6DrB64LtMeJVcgo",
  authDomain: "app-test-ii.firebaseapp.com",
  databaseURL: "https://app-test-ii.firebaseio.com",
  projectId: "app-test-ii",
  storageBucket: "app-test-ii.appspot.com",
  messagingSenderId: "1028572679976"
};
firebase.initializeApp(config);


var database = firebase.database();


var rootRef = firebase.database().ref().child("Posts");

rootRef.on("child_added", snap => {

  var tag = snap.child("Tag").val();
  var type = snap.child("Type").val();
  var url = snap.child("url").val();


  $("#myTable").DataTable().row.add([
    tag, type, url
]).draw();
  // $("#table_body").append("<tr><td>" + name + "</td><td>"+ tag +"</td><tr>");
  // $("#table_body").append("<tr><td>" + tag + "</td><td>"+ type + "</td><td>"+ url + "</td></tr>");
}

)

// const ref = database.ref('object');
//
//
// var preObject = document.getElementById('object');
//
//
// // Create reference
// var dbRefObject = firebase.database().ref().child('object')
//
//
//
//
//
// // Sync object changes
// dbRefObject.on('value', snap =>
// console.log(snap.val())
