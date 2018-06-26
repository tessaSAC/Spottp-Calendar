const functions = require('firebase-functions')
const firebase = require('firebase-admin')
const express = require('express')
const engines = require('consolidate')

// Create firebase app
const firebaseApp = firebase.initializeApp(
  functions.config().firebase
)

// Create express instance
const app = express()

// Create handlebars rendering engine
app.engine('hbs', engines.handlebars)
app.set('views', './views')
app.set('view engine', 'hbs')


function getFacts() {
  // Create reference to facts
  const ref = firebaseApp.database().ref('facts')
  // Get return promise and unwrap value
  return ref.once('value').then(snap => snap.val())
}

app.get('/', (req, res) => {
  res.set('Cache-Control', 'public, max-age=300, s-maxage=600')  // Allow the timestamp to be cached on a public server
  getFacts()
  .then(facts => { res.render('index', { facts }) })
  .catch(err => { throw new Error(err) })
})

app.get('/facts.json', (req, res) => {
  res.set('Cache-Control', 'public, max-age=300, s-maxage=600')  // Allow the timestamp to be cached on a public server
  getFacts()
  .then(facts => { res.json(facts) })
  .catch(err => { throw new Error(err) })
})

// Make the express app the default export
exports.app = functions.https.onRequest(app)