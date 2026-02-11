import mongoose from 'mongoose';

const updateSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      required: true,
    },
    category: {
      type: String,
      enum: [
        'Assignment',
        'Exam',
        'Event',
        'General',
        'Holiday',
        'Program',
        'News',
      ],
      required: true,
    },
    isImportant: {
      type: Boolean,
      default: false,
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
  },
  { timestamps: true },
);

export default mongoose.model('Update', updateSchema);
