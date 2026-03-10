using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditUsers : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            Bind_Grid();
            if (!IsPostBack)
            {
                Bind_ddl_City();
            }
        }

        protected void Bind_ddl_City()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string qry = "SELECT * FROM Cities";

            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataTable dt = new DataTable();
            adpt.Fill(dt);

            ddl_City.DataSource = dt;
            ddl_City.DataBind();
            ddl_City.DataTextField = "Name";
            ddl_City.DataValueField = "CityId";
            ddl_City.DataBind();

            ddl_City.Items.Insert(0, new ListItem("Select City", "0"));
            con.Close();
        }

        protected void Bind_Grid()
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "SELECT * FROM Users";

            con.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataSet ds = new DataSet();
            adpt.Fill(ds);

            gv_Users.DataSource = ds;
            gv_Users.DataBind();
            con.Close();
        }

        protected void gv_Users_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_Users.SelectedRow;
            txt_UserId.Text = row.Cells[1].Text;
            txt_Username.Text = row.Cells[2].Text;
            txt_Email.Text = row.Cells[3].Text;
            txt_Phone.Text = row.Cells[4].Text;
            txt_Password.Text = row.Cells[5].Text;
            txt_ProfilePic.Text = row.Cells[6].Text;
            txt_DateOfBirth.Text = row.Cells[7].Text;

            for (int i = 0; i < ddl_City.Items.Count; i++)
            {
                if (ddl_City.Items[i].Text == row.Cells[8].Text)
                {
                    ddl_City.SelectedIndex = i;
                }
            }

            txt_CreatedAt.Text = row.Cells[9].Text;
        }


        protected void gv_Users_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_Users.Rows[e.RowIndex];
            int userID = Convert.ToInt32(row.Cells[1].Text);

            string qry = "DELETE FROM Users WHERE UserId = @UserId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@UserId", userID);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            Bind_Grid();
        }

        protected void btn_Update_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "UPDATE Users SET Username = @Username, Email = @Email, Phone = @Phone, Password = @Password, DateOfBirth = @DateOfBirth, CityId = @City WHERE UserId = @UserId";

            SqlCommand cmd = new SqlCommand(qry, con);
            cmd.Parameters.AddWithValue("@UserId", txt_UserId.Text);
            cmd.Parameters.AddWithValue("@Username", txt_Username.Text);
            cmd.Parameters.AddWithValue("@Email", txt_Email.Text);
            cmd.Parameters.AddWithValue("@Phone", txt_Phone.Text);
            cmd.Parameters.AddWithValue("@Password", txt_Password.Text);
            //cmd.Parameters.AddWithValue("@ProfilePic", txt_ProfilePic.Text);
            cmd.Parameters.AddWithValue("@DateOfBirth", txt_DateOfBirth.Text);
            cmd.Parameters.AddWithValue("@City", ddl_City.SelectedIndex);
            //cmd.Parameters.AddWithValue("@CreatedAt", txt_CreatedAt.Text);
            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("User Details Updated..");
            con.Close();
        }

        protected void btn_Insert_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "INSERT INTO Users(Username,Email,Phone,Password,DateOfBirth,CityId) VALUES(@Username,@Email,@Phone,@Password,@DateOfBirth,@City);";

            SqlCommand cmd = new SqlCommand(qry, con);
            //cmd.Parameters.AddWithValue("@UserId", txt_UserId.Text);
            cmd.Parameters.AddWithValue("@Username", txt_Username.Text);
            cmd.Parameters.AddWithValue("@Email", txt_Email.Text);
            cmd.Parameters.AddWithValue("@Phone", txt_Phone.Text);
            cmd.Parameters.AddWithValue("@Password", txt_Password.Text);
            //cmd.Parameters.AddWithValue("@ProfilePic", txt_ProfilePic.Text);
            cmd.Parameters.AddWithValue("@DateOfBirth", txt_DateOfBirth.Text);
            cmd.Parameters.AddWithValue("@City", ddl_City.SelectedIndex);

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record Inserted..');</script>");
            con.Close();
        }
    }
}