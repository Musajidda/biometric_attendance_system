const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'yourpassword',
  database: 'attendance_db'
});

db.connect(err => {
  if (err) {
    throw err;
  }
  console.log('MySQL connected...');
});

app.post('/register', (req, res) => {
  let user = { name: req.body.name, email: req.body.email };
  let sql = 'INSERT INTO users SET ?';
  db.query(sql, user, (err, result) => {
    if (err) throw err;
    res.send('User registered...');
  });
});

app.post('/attendance', (req, res) => {
  let attendance = { userId: req.body.userId, timestamp: new Date() };
  let sql = 'INSERT INTO attendance SET ?';
  db.query(sql, attendance, (err, result) => {
    if (err) throw err;
    res.send('Attendance logged...');
  });
});

app.get('/attendance/:userId', (req, res) => {
  let sql = 'SELECT COUNT(*) as count FROM attendance WHERE userId = ?';
  db.query(sql, [req.params.userId], (err, results) => {
    if (err) throw err;
    res.json(results[0]);
  });
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});
