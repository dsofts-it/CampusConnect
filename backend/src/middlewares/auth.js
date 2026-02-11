import jwt from 'jsonwebtoken';

export const auth = async (req, res, next) => {
  try {
    console.log('');
    console.log('🔐 AUTH MIDDLEWARE - Validating Token');
    console.log('========================================');

    // extract token - with null checks
    const tokenFromCookie = req.cookies ? req.cookies.token : null;
    const tokenFromBody = req.body ? req.body.token : null;
    const authHeader = req.header('Authorization');
    const tokenFromHeader = authHeader && authHeader.replace('Bearer ', '');

    console.log('Step 1: Token Sources');
    console.log('  - req.cookies exists:', !!req.cookies);
    console.log('  - req.body exists:', !!req.body);
    console.log(
      '  - Cookie:',
      tokenFromCookie ? `${tokenFromCookie.substring(0, 20)}...` : 'null',
    );
    console.log(
      '  - Body:',
      tokenFromBody ? `${tokenFromBody.substring(0, 20)}...` : 'null',
    );
    console.log('  - Auth Header:', authHeader || 'null');
    console.log(
      '  - Token from Header:',
      tokenFromHeader ? `${tokenFromHeader.substring(0, 20)}...` : 'null',
    );

    const token = tokenFromCookie || tokenFromBody || tokenFromHeader;

    console.log('');
    console.log('Step 2: Final Token');
    if (token) {
      console.log('  - ✅ Token found');
      console.log('  - Length:', token.length);
      console.log('  - First 30 chars:', token.substring(0, 30));
      console.log('  - FULL TOKEN:', token);
    } else {
      console.log('  - ❌ No token found');
    }

    if (!token) {
      console.log('');
      console.log('❌ RESULT: Token is missing');
      console.log('========================================');
      console.log('');
      return res.status(401).json({
        success: false,
        message: 'Token is missing',
      });
    }

    // verify the token
    console.log('');
    console.log('Step 3: Verifying Token with JWT...');
    console.log('  - JWT_SECRET exists:', !!process.env.JWT_SECRET);

    try {
      const decode = jwt.verify(token, process.env.JWT_SECRET);
      console.log('  - ✅ Token verified successfully');
      console.log('  - Decoded payload:', decode);
      req.user = decode;
      console.log('');
      console.log('✅ RESULT: Authentication successful');
      console.log('========================================');
      console.log('');
      next();
    } catch (err) {
      // verification - issue
      console.log('  - ❌ Token verification failed');
      console.log('  - Error:', err.message);
      console.log('');
      console.log('❌ RESULT: Token is invalid');
      console.log('========================================');
      console.log('');
      return res.status(401).json({
        success: false,
        message: 'token is invalid',
      });
    }
  } catch (error) {
    console.log('');
    console.log('❌ UNEXPECTED ERROR in auth middleware');
    console.log('  - Error:', error.message);
    console.log('  - Stack:', error.stack);
    console.log('========================================');
    console.log('');
    return res.status(401).json({
      success: false,
      message: 'Something went wrong while validating the token',
    });
  }
};

export const isStudent = async (req, res, next) => {
  try {
    if (req.user.role !== 'student') {
      return res.status(401).json({
        success: false,
        message: 'This is a protected route for Students only',
      });
    }
    next();
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'User role cannot be verified, please try again',
    });
  }
};

export const isTeacher = async (req, res, next) => {
  try {
    if (req.user.role !== 'teacher') {
      return res.status(401).json({
        success: false,
        message: 'This is a protected route for Teachers only',
      });
    }
    next();
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'User role cannot be verified, please try again',
    });
  }
};
