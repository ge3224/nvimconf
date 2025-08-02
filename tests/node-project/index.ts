const express = require('express');
const app = express();

app.get('/', (req: any, res: any) => {
  res.send('Hello from Node.js!');
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});