import nodemailer from 'nodemailer';

const sendEmail = async (email, title, body) => {
  try {
    const smtpUser = process.env.SMTP_EMAIL;
    const smtpPass = process.env.SMTP_PASSWORD;

    console.log('Using SMTP User:', smtpUser);
    console.log('Using SMTP Pass length:', smtpPass ? smtpPass.length : 0);

    let transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      port: process.env.SMTP_PORT,
      secure: false, // true for 465, false for other ports
      auth: {
        user: smtpUser,
        pass: smtpPass,
      },
      tls: {
        ciphers: 'SSLv3', // Helps with some handshake issues
      },
      family: 4, // Force IPv4 to avoid ENETUNREACH on Render
    });

    let info = await transporter.sendMail({
      from: `"College Update Hub" <${process.env.SMTP_EMAIL}>`,
      to: email, // list of receivers
      subject: title, // Subject line
      html: body, // html body
    });

    console.log('Message sent: %s', info.messageId);
    return info;
  } catch (error) {
    console.log('Error sending email: ', error);
    throw error;
  }
};

export default sendEmail;
