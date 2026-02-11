// Test file to verify token extraction
// Run this in browser console to test token handling

// Simulate backend response
const mockResponse = {
  success: true,
  token:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlYWNoZXJAY29sbGVnZS5jb20iLCJpZCI6IjY5OGM2NDU4YWE1NzAyNjRjY2ZmMDc2NyIsInJvbGUiOiJ0ZWFjaGVyIiwiaWF0IjoxNzM5MjgwNzMzLCJleHAiOjE3MzkzNjcxMzN9.Ge59iN6IimIeMe0d/S9ro/HGBODb4agry',
  role: 'teacher',
  user: {
    _id: '698c6458aa570264ccff0767',
    name: 'John Doe',
    email: 'teacher@college.com',
    role: 'teacher',
    isVerified: true,
    createdAt: '2026-02-11T11:13:28.300Z',
    updatedAt: '2026-02-11T11:13:28.300Z',
    __v: 0,
  },
  message: 'User logged in successfully',
};

console.log('Testing token extraction...');
console.log('Response:', mockResponse);
console.log('Token:', mockResponse.token);
console.log('Role:', mockResponse.role);
console.log('Token length:', mockResponse.token.length);
console.log('Token starts with:', mockResponse.token.substring(0, 20));

// Test Authorization header
const authHeader = `Bearer ${mockResponse.token}`;
console.log('Authorization header:', authHeader);
console.log('Header length:', authHeader.length);
