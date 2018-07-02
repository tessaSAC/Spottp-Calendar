// Setup:

const functions = require('firebase-functions')
const firebase = require('firebase-admin')
const express = require('express')
const cors = require('cors')
const engines = require('consolidate')

// Create firebase app
const firebaseApp = firebase.initializeApp(
  functions.config().firebase
)

// Create express instance
const app = express()

// Allow CORS
app.use(cors({ origin: true }))

// Create handlebars rendering engine
app.engine('hbs', engines.handlebars)
app.set('views', './views')
app.set('view engine', 'hbs')


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// REST Endpoints:

// POST/events -- Should create an event
app.post('/events', (req, res) => {
  postEvent(req.body)
    .then(res => {
      if (typeof res === String) return res
      throw new Error(res)
    })
    .catch(err => {
      throw new Error(err)
    })
})

// GET / -- render all events to host https://spottp-calendar.firebaseapp.com
app.get('/', (req, res) => {
  getEvents()
  .then(events => {
    return res.render('index', {
      events
    })
  })
  .catch(err => {
    throw new Error(err)
  })
})

// GET/events -- Should return all events
app.get('/events', (req, res) => {
  getEvents()
    .then(events => {
      return res.json(events)
    })
    .catch(err => {
      throw new Error(err)
    })
})

// DELETE/events/:id -- Should delete an event
app.delete('events/:eid', (req, res) => res.send(Events.delete(req.params.eid)))

// PUT/events/:id -- Should update an existing event
app.put('events/:eid', (req, res) => res.send(updateEvent(req.params.eid, req.body)));


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// Cloud functions:

function postEvent({ eid, title, description, year, month, day, start, end }) {
  return firebase.database().ref('events/' + eid).set(JSON.parse(JSON.stringify({
    eid,
    title,
    description,
    year,
    month,
    day,
    start,
    end
  })), err => err ? err : 'Event added successfully!')
}

function getEvents() {
  // Create reference to facts
  const ref = firebaseApp.database().ref('events')
  // Get return promise and unwrap value
  return ref.once('value').then(event => event.val())
}

function updateEvent(eid, { title, description, year, month, day, start, end }) {
  // An event
  const eventData = {
    eid,
    title,
    description,
    year,
    month,
    day,
    start,
    end
  }

  // Get a key for a new Event.
  const newEventKey = firebase.database().ref().child('events').push().key;

  // Update the event
  updates['/events/' + eid + '/' + newEventKey] = eventData;

  return firebase.database().ref().update(updates);
}

function deleteEvent(eid) {
  return firebase.database().ref().remove(['/events/' + eid]);
}

// Make the express app the default export
exports.app = functions.https.onRequest(app)