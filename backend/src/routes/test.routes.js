import express from 'express';
const router = express.Router();

// Test endpoint to verify token without full auth
router.get('/test-token', (req, res) => {
  console.log('\n🧪 TEST TOKEN ENDPOINT');
  console.log('='.repeat(50));

  const authHeader = req.header('Authorization');
  console.log('Authorization Header:', authHeader);

  if (authHeader) {
    const token = authHeader.replace('Bearer ', '');
    console.log('Token Length:', token.length);
    console.log('Token:', token);
    console.log('First 50 chars:', token.substring(0, 50));
    console.log('Last 50 chars:', token.substring(token.length - 50));
    console.log('Token starts with eyJ:', token.startsWith('eyJ'));

    // Try to decode without verification
    try {
      const parts = token.split('.');
      if (parts.length === 3) {
        const header = JSON.parse(Buffer.from(parts[0], 'base64').toString());
        const payload = JSON.parse(Buffer.from(parts[1], 'base64').toString());
        console.log('✅ Token structure valid');
        console.log('Header:', header);
        console.log('Payload:', payload);
      } else {
        console.log('❌ Token has', parts.length, 'parts (should be 3)');
      }
    } catch (e) {
      console.log('❌ Cannot decode token:', e.message);
    }
  } else {
    console.log('❌ No Authorization header');
  }

  console.log('='.repeat(50));

  res.json({
    received: !!authHeader,
    length: authHeader ? authHeader.replace('Bearer ', '').length : 0,
  });
});

export default router;
