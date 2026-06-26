const express = require('express');

const app = express();
const port = process.env.MOCK_API_PORT || 3000;

app.use(express.json());

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'glylens-mock-api', version: '1.0.0' });
});

// Stub Food Intelligence endpoint (BP2)
app.get('/v1/foods/:id', (req, res) => {
  res.status(501).json({
    error: 'not_implemented',
    message: 'Mock API — Food Intelligence deferred to Build Program 2',
    foodId: req.params.id,
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`glylens-mock-api listening on ${port}`);
});
