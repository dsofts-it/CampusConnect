import User from '../models/User.js';

export const getProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const userDetails = await User.findById(userId);

    if (!userDetails) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'User data fetched successfully',
      data: userDetails,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
