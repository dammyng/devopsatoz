const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const shortid = require('shortid');
const port = 3000;

const urlDatabase = {};

app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.render('index');
});

app.post('/urls', (req, res) => {
  const shortURL = shortid.generate();
  urlDatabase[shortURL] = req.body.longURL;
  const data = { shortURL, longURL: req.body.longURL };
  res.render('urls_show', { data });
});

app.get('/u/:shortURL', (req, res) => {
  const longURL = urlDatabase[req.params.shortURL];
  if (longURL) {
    res.redirect(longURL);
  } else {
    res.status(404).send('URL not found');
  }
});

app.listen(port, () => {
  console.log(`URL shortener app listening on port ${port}!`);
});
