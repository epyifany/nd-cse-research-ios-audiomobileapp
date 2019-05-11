// Initialize Firebase
var config = {
  apiKey: "AIzaSyBnCGf7ziM25Y7v8JudOT3SrzPoFw8tfnc",
  authDomain: "audiorecordingapp-ec23c.firebaseapp.com",
  databaseURL: "https://audiorecordingapp-ec23c.firebaseio.com",
  projectId: "audiorecordingapp-ec23c",
  storageBucket: "audiorecordingapp-ec23c.appspot.com",
  messagingSenderId: "1028572679976"
};
firebase.initializeApp(config);


var database = firebase.database();


var rootRef = firebase.database().ref().child("All Audio Recordings");

rootRef.on("child_added", snap => {

  var tag = snap.child("Tag").val();
  var date = snap.child("Date").val();
  var length = snap.child("Length").val();
  var size = snap.child("Size").val();
  var time = snap.child("Time").val();
  var type = snap.child("Type").val();
  var url = snap.child("url").val();

  $("#myTable").DataTable().row.add([
    tag, date, length, size, time, type, url
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
