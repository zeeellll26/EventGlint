using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace EventGlint
{
    public partial class Register : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_Register_Click(object sender, EventArgs e)
        {
            string email = txt_Email.Text.Trim();
            string pass = txt_Password.Text;
            string confpass = txt_ConfirmPassword.Text;

            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            if(pass != confpass)
            {
                Response.Write("<script>alert('Passwords do not match!');</script>");
                return;
            }
            if(string.IsNullOrEmpty(pass))
            {
                Response.Write("<script>alert('Password Required!');</script>");
                return;
            }

            String query = "INSERT INTO UserLogin VALUES(@email,@pass)";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@pass", pass);
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Registerd Successfully!');</script>");
        }
    }
}