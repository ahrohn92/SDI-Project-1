const express = require('express')
const app = express()
const bodyParser = require("body-parser")
const cors = require('cors');
app.use(cors())
app.options('*', cors())
const port = 8084

app.use(bodyParser.json())

const Pool = require('pg').Pool;
const pool = new Pool({
    user: 'admin',
    host: 'db',
    database: 'mx_schedule',
    password: 'admin',
    port: 5432
})

// Find a User by User ID
app.get('/users/:user_id', (req, res) => {
    pool.query('SELECT * FROM App_User WHERE User_ID = $1', [req.params.user_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

app.get('/workcenters/:work_center_id', (req, res) => {
    console.log(req.params.work_center_id)
    pool.query('SELECT * FROM Work_Center WHERE Work_Center_ID = $1', [req.params.work_center_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

// Find Tickets by Workcenter ID
app.get('/tickets/:work_center_id', (req, res) => {
    pool.query('SELECT * FROM Ticket_Information WHERE Work_Center_ID = $1', [req.params.work_center_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

// Returns Aircraft at a Workcenter
app.get('/aircraft/:work_center_id', (req, res) => {
    pool.query('SELECT * FROM Aircraft WHERE Work_Center_ID = $1', [req.params.work_center_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

// Returns Components at a Workcenter
app.get('/components/:work_center_id', (req, res) => {
    pool.query('SELECT * FROM Components WHERE Work_Center_ID = $1', [req.params.work_center_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

// Adds a Ticket to Database
app.post('/addticket', (req, res) => {
    pool.query('INSERT INTO Ticket (created_by_user_id, work_center_id, component_id, start_timestamp, suspense_timestamp, close_timestamp, is_scheduled, narrative, closed_by_user_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)',
        [req.body.created_by_user_id, req.body.work_center_id, req.body.component_id, req.body.start_timestamp, req.body.suspense_timestamp,
        req.body.close_timestamp, req.body.is_scheduled, req.body.narrative, req.body.closed_by_user_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})



// Updates a Component's Status
app.post('/updatecomponent/:component_id', (req, res) => {
    pool.query('UPDATE Component SET Component_Status = $1 WHERE Component_ID = $2', [req.body.component_status, req.params.component_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

// Updates an Aircraft's Operational Status
app.post('/aircraft/:aircraft_id', (req, res) => {
    pool.query('UPDATE Aircraft SET Operational_Status = $1 WHERE Aircraft_ID = $2', [req.body.operational_status, req.params.aircraft_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

// Updates a Ticket's Information When Closing a Ticket
app.post('/tickets/:ticket_id', (req, res) => {
    pool.query('UPDATE Ticket SET Close_Timestamp = $1, Fix_Action = $2, Closed_By_User_ID = $3 WHERE Ticket_ID = $4',
    [req.body.close_timestamp, req.body.fix_action, req.body.closed_by_user_id, req.params.ticket_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

app.delete('/tickets/:ticket_id', (req, res) => {
    pool.query('DELETE FROM Ticket WHERE Ticket_ID = $1', [req.params.ticket_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
})

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`))