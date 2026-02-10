import User from '../models/User.js';
import OTP from '../models/OTP.js';
import jwt from 'jsonwebtoken';

// Send OTP
export const sendOTP = async (req, res) => {
  try {
    const { email, role } = req.body;

    if (!email || !role) {
      return res.status(403).json({
        success: false,
        message: 'Email and Role are required',
      });
    }

    // Check if user already exists
    let user = await User.findOne({ email });

    // If user doesn't exist, create a new one (Implicit Signup)
    if (!user) {
      user = await User.create({
        email,
        role,
      });
    } else {
      // User exists logic...
    }

    // Generate OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();

    // Create OTP Object in DB
    await OTP.create({ email, otp });

    res.status(200).json({
      success: true,
      message: 'OTP sent successfully',
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Verify OTP
export const verifyOTP = async (req, res) => {
  try {
    const { email, otp } = req.body;

    if (!email || !otp) {
      return res.status(400).json({
        success: false,
        message: 'All fields are required',
      });
    }

    // Find the most recent OTP for the email
    const response = await OTP.find({ email }).sort({ createdAt: -1 }).limit(1);

    if (response.length === 0 || otp !== response[0].otp) {
      return res.status(400).json({
        success: false,
        message: 'The OTP is not valid',
      });
    }

    // OTP is valid
    // Update USER Verification status
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: 'User not found',
      });
    }

    user.isVerified = true;
    await user.save();

    // Generate JWT Token
    const payload = {
      email: user.email,
      id: user._id,
      role: user.role,
    };

    const token = jwt.sign(payload, process.env.JWT_SECRET, {
      expiresIn: '24h',
    });

    user.token = token;
    user.password = undefined;

    // Option: Set cookie
    const options = {
      expires: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000),
      httpOnly: true,
    };

    res.cookie('token', token, options).status(200).json({
      success: true,
      token,
      role: user.role,
      user,
      message: 'User logged in successfully',
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
