# College Update Hub Backend

Complete Node.js backend for the "College Update Hub" mobile application.
Features:

- Node.js & Express.js
- MongoDB (Mongoose) integration
- JWT Authentication (Role-based: Student & Teacher)
- Email OTP Login via Nodemailer

## Setup Instructions

1.  **Clone the repository** (if not already done).
2.  **Install dependencies**:
    ```bash
    npm install
    ```
3.  **Configure Environment Variables**:
    - Rename `.env.example` to `.env` (or create `.env`).
    - Update `MONGODB_URI` with your MongoDB connection string.
    - Update `JWT_SECRET` with a strong secret key.
    - Update SMTP details (`SMTP_HOST`, `SMTP_PORT`, `SMTP_EMAIL`, `SMTP_PASSWORD`) for email sending.
      - _Note: For Gmail, use an App Password if 2FA is enabled._

4.  **Start the Server**:
    ```bash
    npm run dev
    ```
    Server runs on `http://localhost:4000`.

## API Documentation

### Authentication

#### 1. Send OTP

- **Endpoint**: `POST /api/auth/send-otp`
- **Body**:
  ```json
  {
    "email": "student@college.com",
    "role": "student"
  }
  ```
- **Response**: `{ "message": "OTP sent successfully" }`

#### 2. Verify OTP

- **Endpoint**: `POST /api/auth/verify-otp`
- **Body**:
  ```json
  {
    "email": "student@college.com",
    "otp": "123456"
  }
  ```
- **Response**:
  ```json
  {
    "token": "jwt_token...",
    "role": "student",
    "user": { ... },
    "message": "User logged in successfully"
  }
  ```

### User

#### 3. Get Profile

- **Endpoint**: `GET /api/users/me`
- **Headers**: `Authorization: Bearer <token>`
- **Response**: User profile details.

### Updates (Notices)

#### 4. Create Update (Teacher Only)

- **Endpoint**: `POST /api/updates`
- **Headers**: `Authorization: Bearer <token>`
- **Body**:
  ```json
  {
    "title": "Mid Term Exam",
    "description": "Details...",
    "category": "Exam",
    "isImportant": true
  }
  ```

#### 5. Update Update (Teacher Only)

- **Endpoint**: `PUT /api/updates/:id`
- **Headers**: `Authorization: Bearer <token>`
- **Body**: `{ "title": "New Title" }`

#### 6. Delete Update (Teacher Only)

- **Endpoint**: `DELETE /api/updates/:id`
- **Headers**: `Authorization: Bearer <token>`

#### 7. Get All Updates

- **Endpoint**: `GET /api/updates`
- **Headers**: `Authorization: Bearer <token>`
- **Query Params**: `?category=Exam&isImportant=true`

## Postman Collection

A `Postman_Collection.json` file is included in the root directory. Import it into Postman to test the APIs.

## Keep the backend responsive

Render (free) web services pause after 15 minutes of inactivity, so the first login/request after an idle period can take several minutes while the process warms up. To keep this app always responsive:

1. In the Render dashboard, add an environment variable named `KEEP_ALIVE_URL` that points to your deployed root or a lightweight health route (for example `https://campus-update.onrender.com/`).
2. (Optional) Set `KEEP_ALIVE_INTERVAL_MS` to the number of milliseconds between pings; it defaults to `780000` (13 minutes), which is just under Render’s 15-minute idle timeout.
3. Once those values are saved, the backend will automatically ping the configured URL every interval to keep the service warm and speed up the first login after idle periods.
