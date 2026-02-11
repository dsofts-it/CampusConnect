# 🔐 LOGIN STEPS - View Profile Data

## Current Issue

✅ Profile API is working correctly
✅ Profile screen is ready
❌ You need to LOGIN first to get a valid JWT token

## 📋 Step-by-Step Instructions

### Step 1: Clear Browser Data

1. Open Chrome DevTools (F12)
2. Go to **Application** tab
3. In the left sidebar, find **Storage**
4. Click **Clear site data**
5. Click **Clear site data** button
6. Close DevTools

### Step 2: Navigate to Login

1. In the app, look for the URL bar
2. If you're at `localhost:XXXXX/#/main`, change it to `localhost:XXXXX/#/login`
3. OR refresh the page - it should redirect to login automatically

### Step 3: Login with Valid Credentials

Use credentials that work in Postman:

**For Teacher Account:**

- Email: `teacher@college.com`
- Password: (your password)

**OR Create New Account:**

- Click "Sign Up" instead
- Fill in the form
- Choose role: Student or Teacher
- Complete signup
- Then login

### Step 4: After Login

1. You'll be redirected to the main screen
2. Click on the **Profile** tab (bottom right)
3. **Expected:** Your profile data should appear!

## 🔍 What to Look for in Console

### ✅ Successful Login

```
🔐 Attempting login...
📧 Email: teacher@college.com
🔐 Login API call starting...
📥 Login response status: 200
📥 Login response body: {"success":true,"token":"eyJ...","role":"teacher",...}
✅ Login response received:
   Full response: {success: true, token: eyJ..., ...}
🔍 FULL TOKEN (for debugging): eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
💾 Saving token: eyJhbGciOiJIUzI1NiIs...
✅ Token saved successfully
📏 Token length: 200+ (should be long!)
```

### ✅ Successful Profile Load

```
🔄 Loading profile data...
👤 Getting profile...
🔍 FULL TOKEN (for debugging): eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
📡 Calling: https://campusconnect-vweo.onrender.com/api/users/me
🔐 Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6...
📥 Profile response status: 200 ✅ (not 401!)
📥 Profile response body: {"success":true,"message":"User data fetched successfully",...}
✅ Profile loaded successfully: John Doe (teacher)
```

## ❌ If You Still Get 401 After Login

This means the token is invalid. Try these:

### Option 1: Clear Everything and Re-login

```javascript
// Run in browser console (F12)
localStorage.clear();
sessionStorage.clear();
location.reload();
```

### Option 2: Check Token in Console

After login, check the console for:

- `🔍 FULL TOKEN (for debugging):`
- Copy the token
- Verify it starts with `eyJ`
- Verify it's long (150+ characters)

### Option 3: Test Token in Postman

1. Login in Flutter app
2. Copy the full token from console
3. In Postman, use that token for `GET /api/users/me`
4. If Postman also fails → Token is genuinely invalid
5. If Postman works → Issue is in how Flutter sends it

## 🎯 Quick Fix Commands

### In Browser Console (F12):

```javascript
// Check if token exists
console.log('Token:', localStorage.getItem('flutter.token'));
console.log('Role:', localStorage.getItem('flutter.role'));

// If token is null or weird, clear and re-login:
localStorage.clear();
sessionStorage.clear();
location.href = '/#/login';
```

## 📊 Expected Flow

```
1. Clear browser data
   ↓
2. Go to login page
   ↓
3. Enter valid credentials
   ↓
4. Click Login
   ↓
5. Token saved (check console: "✅ Token saved successfully")
   ↓
6. Redirected to main screen
   ↓
7. Click Profile tab
   ↓
8. Profile loads! (status: 200)
```

## 🚀 Ready to Test!

**Right now, do this:**

1. **Press F12** (open console - keep it open!)
2. **Type in console:**
   ```javascript
   localStorage.clear();
   location.href = '/#/login';
   ```
3. **Login** with your credentials
4. **Watch the console** for token messages
5. **Click Profile tab**
6. **Check console** - should say status: 200!

---

## 💡 Important Notes

- ✅ The API is working fine (Postman proves this)
- ✅ The Flutter code is correct
- ❌ You just need a VALID token from login
- 🔑 Token is only valid for 24 hours
- 🔄 If token expires, login again

**The 401 error is EXPECTED if you haven't logged in yet!**

After you login, the profile will work perfectly! 🎉
