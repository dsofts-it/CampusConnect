// TEST TOKEN HANDLING - Paste this in browser console after login

console.log('🧪 Testing Token Handling...');
console.log('');

// Check SharedPreferences keys
const token = localStorage.getItem('flutter.token');
const role = localStorage.getItem('flutter.role');

console.log('📦 Storage Check:');
console.log('  Token exists:', token !== null);
console.log('  Token length:', token ? token.length : 0);
console.log(
  '  Token starts with "eyJ":',
  token ? token.startsWith('eyJ') : false,
);
console.log('  Role:', role);
console.log('');

if (!token) {
  console.log('❌ NO TOKEN FOUND!');
  console.log('   Solution: Go to login page and login');
  console.log('   Run: location.href = "/#/login";');
} else {
  console.log('✅ Token found!');
  console.log('   First 50 chars:', token.substring(0, 50) + '...');
  console.log('');

  // Try to decode JWT (just the payload, not verify)
  try {
    const parts = token.split('.');
    if (parts.length === 3) {
      const payload = JSON.parse(atob(parts[1]));
      console.log('🔐 Token Payload:');
      console.log('  Email:', payload.email);
      console.log('  ID:', payload.id);
      console.log('  Role:', payload.role);
      console.log(
        '  Issued at:',
        new Date(payload.iat * 1000).toLocaleString(),
      );
      console.log(
        '  Expires at:',
        new Date(payload.exp * 1000).toLocaleString(),
      );

      const now = Date.now() / 1000;
      if (payload.exp < now) {
        console.log('');
        console.log('⚠️ TOKEN HAS EXPIRED!');
        console.log('   Solution: Login again to get a fresh token');
        console.log(
          '   Run: localStorage.clear(); location.href = "/#/login";',
        );
      } else {
        console.log('');
        console.log('✅ Token is still valid!');
        const remainingHours = ((payload.exp - now) / 3600).toFixed(1);
        console.log(`   Expires in ${remainingHours} hours`);
      }
    }
  } catch (e) {
    console.log('⚠️ Could not decode token:', e.message);
  }
}

console.log('');
console.log('🔧 Quick Actions:');
console.log(
  '  Clear and re-login: localStorage.clear(); location.href = "/#/login";',
);
console.log(
  '  Go to profile: location.href = "/#/main"; /* then click Profile tab */',
);
console.log('  Refresh app: location.reload();');
