// Setup:

const functions = require('firebase-functions')
const firebase = require('firebase-admin')
const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const engines = require('consolidate')

// Create firebase app
const firebaseApp = firebase.initializeApp(
  functions.config().firebase
)

// Create express instance
const app = express()

// Body parser
app.use(bodyParser.json())

// Allow CORS
app.use(cors({ origin: true }))

// Create handlebars rendering engine
app.engine('hbs', engines.handlebars)
app.set('views', './views')
app.set('view engine', 'hbs')

// Mock db:
const events = {
  '201867': {
    '23s': {
      eid: '23s',
      title: 'my fun event',
      description: 'this is the best appointment ever you guys',
      year: '2018',
      month: '6',
      day: '7',
      start: '10:11AM',
      end: '10:12AM'
    }
  }
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// REST Endpoints:

// Go to root route to see each event
app.get('/', (req, res) => {
  res.status(200).render('index', {
    events
  })
})

// GET ALL events
app.get('/events', (req, res) => {
  res.status(200).json(events)
})

// GET all events for SPECIFIC DATE
app.get('/events/:date', (req, res) => {
  const { date } = req.params
  const event = events[date]

  return event ? res.status(200).json(event) : res.sendStatus(404)
})

// GET all events for SPECIFIC EID
app.get('/events/:date/:eid', (req, res) => {
  const { date, eid } = req.params
  const event = events[date][eid]

  return event ? res.status(200).json(event) : res.sendStatus(404)
})

// POST and UPDATE an event:
app.route('/events').post(put).put(put)

// DELETE an event
app.delete('/events/:date/:eid', (req, res) => {
  const { date, eid } = req.params;

  events[date] = events[date] || {}
  const eventToDelete = events[date][eid]

  if (!eventToDelete) return res.sendStatus(404)

  events[date][eid] = undefined

  return res.status(200).json(eventToDelete)
})

function put(req, res) {
  const {
    eid,
    title,
    description,
    year,
    month,
    day,
    start,
    end
  } = req.body;

  const date = year + month + day

  const newEvent = {
    eid,
    title,
    description,
    year,
    month,
    day,
    start,
    end
  }

  events[date] = events[date] || {}
  events[date][eid] = newEvent

  res.status(201)
    // .location(`/events/${date}/${eid}`)
    .json(newEvent);
}

/*  Old firebase methods:

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

*/


// Make the express app the default export
exports.app = functions.https.onRequest(app)