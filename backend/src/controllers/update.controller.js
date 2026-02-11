import Update from '../models/Update.js';

export const createUpdate = async (req, res) => {
  try {
    const { title, description, category, isImportant, startDate, endDate } =
      req.body;

    if (!title || !description || !category) {
      return res.status(400).json({
        success: false,
        message: 'Please fill all the details',
      });
    }

    const userId = req.user.id;

    const newUpdate = await Update.create({
      title,
      description,
      category,
      isImportant,
      startDate,
      endDate,
      createdBy: userId,
    });

    return res.status(200).json({
      success: true,
      message: 'Update Created Successfully',
      data: newUpdate,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error while creating update',
    });
  }
};

export const updateUpdate = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, category, isImportant, startDate, endDate } =
      req.body;

    const updatedUpdate = await Update.findByIdAndUpdate(
      { _id: id },
      { title, description, category, isImportant, startDate, endDate },
      { new: true },
    );

    if (!updatedUpdate) {
      return res.status(404).json({
        success: false,
        message: 'Update not found',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Update Updated Successfully',
      data: updatedUpdate,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error while updating update',
    });
  }
};

export const deleteUpdate = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedUpdate = await Update.findByIdAndDelete({ _id: id });

    if (!deletedUpdate) {
      return res.status(404).json({
        success: false,
        message: 'Update not found',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Update Deleted Successfully',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error while deleting update',
    });
  }
};

export const getAllUpdates = async (req, res) => {
  try {
    const { category, isImportant } = req.query;

    let query = {};
    if (category) query.category = category;
    if (isImportant) query.isImportant = isImportant === 'true'; // Convert string to boolean

    const allUpdates = await Update.find(query)
      .populate('createdBy', 'name email')
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      message: 'All Updates Fetched Successfully',
      data: allUpdates,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error while fetching updates',
    });
  }
};

export const likeUpdate = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const update = await Update.findById(id);

    if (!update) {
      return res.status(404).json({
        success: false,
        message: 'Update not found',
      });
    }

    // Check if user has already liked
    if (update.likes.includes(userId)) {
      // Unlike
      update.likes.pull(userId);
    } else {
      // Like
      update.likes.push(userId);
    }

    await update.save();

    return res.status(200).json({
      success: true,
      message: 'Like status updated',
      data: update,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error while updating like status',
    });
  }
};
