using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class AboutUs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                LoadUserInfo();
            }
        }

        private void LoadUserInfo()
        {
            // Check if user is logged in via Session
            if (Session["UserName"] != null)
            {
                string fullName = Session["UserName"].ToString();
                string role = Session["UserRole"] != null
                                  ? Session["UserRole"].ToString()
                                  : "Pro Member ✦";

                // Display name
                lblUserName.Text = fullName;
                lblUserRole.Text = role;

                // Avatar initial — first letter of name
                string initial = fullName.Length > 0
                                 ? fullName[0].ToString().ToUpper()
                                 : "U";

                lblAvatarInitial.Text = initial;
                lblTopAvatar.Text = initial;
            }
            else
            {
                // Defaults when no session (guest / not logged in)
                lblUserName.Text = "Guest User";
                lblUserRole.Text = "Member";
                lblAvatarInitial.Text = "G";
                lblTopAvatar.Text = "G";
            }
        }
    }
}