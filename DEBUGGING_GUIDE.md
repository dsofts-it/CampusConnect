# 🔍 API Debugging Guide - CampusConnect

## Current Status

✅ All debugging logs added
✅ App is running on Chrome
✅ Base URL: https://campusconnect-vweo.onrender.com/api

## 🧪 Testing Steps

### Step 1: Open Browser Console

1. Press **F12** in Chrome
2. Go to **Console** tab
3. Keep it open while testing

### Step 2: Test Login Flow

1. Go to Login screen
2. Enter credentials (or sign up first)
3. Click Login
4. **Watch console for these messages:**
   - `🔐 Attempting login...`
   - `📧 Email: your@email.com`
   - `✅ Login response received: {...}`
   - `🎫 Token: abc123...`
   - `👤 Role: student/teacher`
   - `💾 Saving token: abc123...`
   - `✅ Token saved successfully`
   - `💾 Saving user role: student`
   - `✅ Role saved successfully`

### Step 3: Test Profile Page

1. Navigate to Profile tab
2. **Watch console for:**
   - `🔄 Loading profile data...`
   - `⏳ Waiting for profile data...`
   - `👤 Getting profile...`
   - `🎫 Retrieved token: abc123...`
   - `📡 Calling: https://campusconnect-vweo.onrender.com/api/users/me`
   - `📥 Profile response status: 200`
   - `📥 Profile response body: {...}`
   - `✅ Profile loaded successfully: Name (role)`

### Step 4: Test Dashboard/Home

1. Navigate to Home tab
2. **Watch console for:**
   - `📡 Fetching updates from API...`
   - `📚 Getting all updates...`
   - `🎫 Retrieved token: abc123...`
   - `📡 Calling: https://campusconnect-vweo.onrender.com/api/updates?`
   - `📥 Updates response status: 200`
   - `📥 Updates response body: {...}`
   - `✅ Response received: {...}`
   - `📊 Total updates loaded: X`

## 🐛 Common Issues & What to Look For

### Issue: "No token found"

**Console shows:** `⚠️ No token found in storage`
**Solution:**

1. Logout completely
2. Sign up new account OR login again
3. Check if you see `💾 Saving token:` message

### Issue: "Server error: 401"

**Console shows:** `📥 Profile response status: 401`
**Possible causes:**

1. Token not saved properly - check for `✅ Token saved successfully`
2. Token format wrong - check `🎫 Token:` message
3. Backend issue - verify Postman works

**Solution:**

1. Clear browser data (Application > Storage > Clear site data)
2. Logout and login again
3. Check console for full error message

### Issue: "Exception: Server error: 401"

**This means:** Backend rejected the token
**Check:**

1. Is token being sent? Look for `🎫 Retrieved token:`
2. Is Authorization header correct? Should be `Bearer <token>`
3. Test same token in Postman

### Issue: No updates showing

**Console shows:** `📊 Total updates loaded: 0`
**Solution:**

1. Database might be empty
2. Login as teacher
3. Create a test update
4. Refresh Home tab

## 📝 What Each Emoji Means

- 🔐 = Authentication action
- 📧 = Email/credential
- ✅ = Success
- ❌ = Error
- 🎫 = Token operation
- 👤 = User/Profile operation
- 💾 = Saving to storage
- 🔑 = Retrieving from storage
- 📡 = API call being made
- 📥 = API response received
- 📚 = Updates/Dashboard operation
- 🗑️ = Delete operation
- ⚠️ = Warning

## 🔧 Quick Fixes

### Fix 1: Clear All Data

```javascript
// Run in browser console
localStorage.clear();
sessionStorage.clear();
location.reload();
```

### Fix 2: Check Token Manually

```javascript
// Run in browser console
console.log('Token:', localStorage.getItem('flutter.token'));
console.log('Role:', localStorage.getItem('flutter.role'));
```

### Fix 3: Test API Directly

```bash
# In Postman or curl
curl -X GET \
  https://campusconnect-vweo.onrender.com/api/users/me \
  -H 'Authorization: Bearer YOUR_TOKEN_HERE'
```

## 📊 Expected Console Output (Successful Flow)

```
🔐 Attempting login...
📧 Email: test@example.com
✅ Login response received: {success: true, token: "eyJ...", role: "student", ...}
🎫 Token: eyJhbGciOiJIUzI1NiIs...
👤 Role: student
💾 Saving token: eyJhbGciOiJIUzI1NiIs...
✅ Token saved successfully
💾 Saving user role: student
✅ Role saved successfully
💾 Token and role saved successfully

[Navigate to Profile]
🔄 Loading profile data...
⏳ Waiting for profile data...
👤 Getting profile...
🔑 Token retrieved from storage: eyJhbGciOiJIUzI1NiIs...
🎫 Retrieved token: eyJhbGciOiJIUzI1NiIs...
📡 Calling: https://campusconnect-vweo.onrender.com/api/users/me
📥 Profile response status: 200
📥 Profile response body: {"success":true,"message":"User data fetched successfully","data":{...}}
✅ Profile loaded successfully: Test User (student)

[Navigate to Home]
📡 Fetching updates from API...
📚 Getting all updates...
🔑 Token retrieved from storage: eyJhbGciOiJIUzI1NiIs...
🎫 Retrieved token: eyJhbGciOiJIUzI1NiIs...
📡 Calling: https://campusconnect-vweo.onrender.com/api/updates?
📥 Updates response status: 200
📥 Updates response body: {"success":true,"message":"All Updates Fetched Successfully","data":[...]}
✅ Response received: {success: true, message: "All Updates Fetched Successfully", data: [...]}
📊 Total updates loaded: 5
```

## 🎯 Next Steps

1. **Open the app** (should already be running in Chrome)
2. **Open Console** (F12)
3. **Try to login**
4. **Copy all console output** and share if there are errors
5. **Take screenshot** of any error messages

The debugging is now comprehensive - we'll see exactly where the issue is!
