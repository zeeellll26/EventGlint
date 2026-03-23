using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class ContactUs : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        // ── Page Load ──────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserInfo();

                // Hide feedback panels on fresh load
                pnlSuccess.Visible = false;
                pnlError.Visible = false;
            }
        }

        // ── Load sidebar user info ─────────────────────────────────────────
        private void LoadUserInfo()
        {
            // Updated to Yashvi Sarang as requested
            string userName = "Yashvi Sarang";
            lblUserName.Text = userName;
            lblUserRole.Text = "Pro Member ✦";
            lblAvatarInitial.Text = userName.Substring(0, 1).ToUpper();   // "Y"
            lblTopAvatar.Text = userName.Substring(0, 1).ToUpper();   // "Y"
            lblLocation.Text = "Surat, Gujarat";
        }

        // ── Send Message button ────────────────────────────────────────────
        protected void btnSend_Click(object sender, EventArgs e)
        {
            // Server-side validation check
            if (!Page.IsValid) return;

            // Hide any previous messages
            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string subject = ddlSubject.SelectedItem.Text;
            string message = txtMessage.Text.Trim();

            // Extra manual validation
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(message))
            {
                pnlError.Visible = true;
                lblError.Text = "Please fill in all required fields (Name, Email, Message).";
                return;
            }

            // Message length check
            if (message.Length > 500)
            {
                pnlError.Visible = true;
                lblError.Text = "Message must be 500 characters or fewer.";
                return;
            }

            try
            {
                // ── TODO: Uncomment and configure SMTP to send real emails ──
                //
                // string body =
                //     $"Name:    {name}\n" +
                //     $"Email:   {email}\n" +
                //     $"Phone:   {phone}\n" +
                //     $"Subject: {subject}\n\n" +
                //     $"Message:\n{message}";
                //
                // using (var mail = new MailMessage())
                // {
                //     mail.To.Add("hello@eventnearme.in");
                //     mail.From    = new MailAddress(email, name);
                //     mail.Subject = $"[EventNearMe Contact] {subject}";
                //     mail.Body    = body;
                //
                //     using (var smtp = new SmtpClient("smtp.gmail.com", 587))
                //     {
                //         smtp.Credentials = new System.Net.NetworkCredential("your@gmail.com", "app-password");
                //         smtp.EnableSsl   = true;
                //         smtp.Send(mail);
                //     }
                // }

                // ── TODO: Optionally save enquiry to database ──
                // SaveEnquiryToDB(name, email, phone, subject, message);

                // Show success
                pnlSuccess.Visible = true;
                lblSuccess.Text = $"Thank you, {name}! Your message has been sent. We'll reply to {email} within 24 hours.";

                // Clear form
                ClearForm();
            }
            catch (Exception ex)
            {
                // Log error (replace with your logging framework)
                System.Diagnostics.Debug.WriteLine("Contact form error: " + ex.Message);

                pnlError.Visible = true;
                lblError.Text = "Something went wrong while sending your message. Please try again or email us directly at hello@eventnearme.in.";
            }
        }

        // ── Clear all form fields ──────────────────────────────────────────
        private void ClearForm()
        {
            txtName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPhone.Text = string.Empty;
            txtMessage.Text = string.Empty;
            ddlSubject.SelectedIndex = 0;
        }

        // ── Optional: Save enquiry to database ────────────────────────────
        // private void SaveEnquiryToDB(string name, string email, string phone, string subject, string message)
        // {
        //     // Example with Entity Framework:
        //     // using (var db = new AppDbContext())
        //     // {
        //     //     db.ContactEnquiries.Add(new ContactEnquiry
        //     //     {
        //     //         Name        = name,
        //     //         Email       = email,
        //     //         Phone       = phone,
        //     //         Subject     = subject,
        //     //         Message     = message,
        //     //         SubmittedAt = DateTime.Now,
        //     //         IsRead      = false
        //     //     });
        //     //     db.SaveChanges();
        //     // }
        // }

    }
}