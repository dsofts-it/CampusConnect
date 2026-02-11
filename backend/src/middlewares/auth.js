import jwt from 'jsonwebtoken';

export const auth = async (req, res, next) => {
  try {
    // extract token
    const token =
      req.cookies.token ||
      req.body.token ||
      (req.header('Authorization') &&
        req.header('Authorization').replace('Bearer ', ''));

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token is missing',
      });
    }

    // verify the token
    try {
      const decode = jwt.verify(token, process.env.JWT_SECRET);
      console.log(decode);
      req.user = decode;
    } catch (err) {
      // verification - issue
      return res.status(401).json({
        success: false,
        message: 'token is invalid',
      });
    }
    next();
  } catch (error) {
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
