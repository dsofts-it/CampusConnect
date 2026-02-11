# CampusConnect API Integration Test Guide

## Backend API Endpoints (Deployed)

**Base URL**: `https://campusconnect-vweo.onrender.com/api`

---

## 1. Authentication APIs ✅

### Signup

- **Endpoint**: `POST /auth/signup`
- **Body**:

```json
{
  "name": "Test Student",
  "email": "student@test.com",
  "password": "password123",
  "confirmPassword": "password123",
  "role": "student"
}
```

- **Flutter Integration**: `lib/views/auth/signup_screen.dart`
- **Service Method**: `ApiService.signup()`

### Login

- **Endpoint**: `POST /auth/login`
- **Body**:

```json
{
  "email": "student@test.com",
  "password": "password123"
}
```

- **Response**: Returns `token` and `user` object
- **Flutter Integration**: `lib/views/auth/login_screen.dart`
- **Service Method**: `ApiService.login()`

---

## 2. Profile API ✅

### Get User Profile

- **Endpoint**: `GET /users/me`
- **Headers**:
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`
- **Response**:

```json
{
  "success": true,
  "message": "User data fetched successfully",
  "data": {
    "_id": "...",
    "name": "Test Student",
    "email": "student@test.com",
    "role": "student",
    "createdAt": "..."
  }
}
```

- **Flutter Integration**: `lib/views/profile/profile_screen.dart`
- **Service Method**: `ApiService.getProfile()`

---

## 3. Updates/Dashboard APIs ✅

### Get All Updates

- **Endpoint**: `GET /updates`
- **Headers**:
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`
- **Query Parameters** (optional):
  - `category`: Filter by category
  - `isImportant`: Filter by importance (true/false)
- **Response**:

```json
{
  "success": true,
  "message": "All Updates Fetched Successfully",
  "data": [
    {
      "_id": "...",
      "title": "Exam Schedule",
      "description": "Final exams start next week",
      "category": "Exam",
      "isImportant": true,
      "createdBy": {
        "name": "Teacher Name",
        "email": "teacher@test.com"
      },
      "startDate": "2026-03-01T00:00:00.000Z",
      "endDate": "2026-03-10T00:00:00.000Z",
      "likes": [],
      "createdAt": "..."
    }
  ]
}
```

- **Flutter Integration**:
  - `lib/views/dashboard/dashboard_screen.dart` (Home tab)
  - `lib/views/explore/explore_screen.dart` (Explore tab with search)
- **Service Method**: `ApiService.getAllUpdates()`

### Create Update (Teachers Only)

- **Endpoint**: `POST /updates`
- **Headers**:
  - `Authorization: Bearer <token>` (must be teacher role)
  - `Content-Type: application/json`
- **Body**:

```json
{
  "title": "New Assignment",
  "description": "Complete chapters 1-5",
  "category": "Assignment",
  "isImportant": false,
  "startDate": "2026-03-01T00:00:00.000Z",
  "endDate": "2026-03-10T00:00:00.000Z"
}
```

- **Flutter Integration**: `lib/views/upload/upload_screen.dart`
- **Service Method**: `ApiService.createUpdate()`

### Like/Unlike Update

- **Endpoint**: `PUT /updates/:id/like`
- **Headers**:
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`
- **Flutter Integration**: `lib/widgets/update_card.dart` (future implementation)
- **Service Method**: `ApiService.likeUpdate()`

---

## Testing Checklist

### ✅ Step 1: Test Authentication

1. Open the app in Chrome
2. Click "Sign Up"
3. Fill in details (name, email, password, role)
4. Verify successful signup
5. Login with the same credentials
6. Verify redirect to Home tab

### ✅ Step 2: Test Profile Page

1. Navigate to Profile tab (bottom navigation)
2. Verify user name is displayed
3. Verify email is displayed
4. Verify role badge (STUDENT/TEACHER)
5. Check console for: `✅ Profile loaded successfully: [name] ([role])`

### ✅ Step 3: Test Home/Dashboard

1. Navigate to Home tab
2. Check console for: `📡 Fetching updates from API...`
3. Check console for: `✅ Response received: ...`
4. Check console for: `📊 Total updates loaded: X`
5. Verify updates are displayed in cards
6. Pull down to refresh and verify reload

### ✅ Step 4: Test Upload (Teachers Only)

1. Login as a teacher
2. Verify Upload tab appears in bottom navigation
3. Click Upload tab
4. Fill in update details:
   - Title
   - Category (dropdown)
   - Description
   - Dates (optional)
   - Important toggle
5. Click "Create Update"
6. Verify success message
7. Navigate to Home tab
8. Verify new update appears

### ✅ Step 5: Test Explore/Search

1. Navigate to Explore tab
2. Type in search box
3. Verify real-time filtering works
4. Search by title, description, or category

---

## Debug Console Messages

### Profile Screen

- `🔄 Loading profile data...` - Started loading
- `⏳ Waiting for profile data...` - API call in progress
- `✅ Profile loaded successfully: [name] ([role])` - Success
- `❌ Profile error: [error]` - Error occurred

### Dashboard Screen

- `📡 Fetching updates from API...` - Started fetching
- `✅ Response received: {...}` - API response received
- `📊 Total updates loaded: X` - Updates count
- `❌ Error fetching updates: [error]` - Error occurred

---

## Common Issues & Solutions

### Issue: "No token found"

**Solution**: User needs to login first. Token is stored in SharedPreferences.

### Issue: "Server error: 401"

**Solution**: Token expired or invalid. Logout and login again.

### Issue: "No updates available"

**Solution**: Database is empty. Create some updates as a teacher first.

### Issue: Profile shows "Error loading profile"

**Solution**:

1. Check if token is valid
2. Check backend is running
3. Check network connection
4. View console for detailed error

---

## API Service Configuration

**File**: `lib/services/api_service.dart`
**Base URL**: `https://campusconnect-vweo.onrender.com/api`

All API calls include:

- Proper error handling
- Token management via SharedPreferences
- Response parsing
- Exception throwing for error states

---

## Next Steps

1. ✅ APIs are integrated
2. ✅ Error handling implemented
3. ✅ Debug logging added
4. 🔄 Test with real data
5. 🔄 Implement like/unlike functionality
6. 🔄 Add update edit/delete for teachers
7. 🔄 Add filtering by category in Dashboard
