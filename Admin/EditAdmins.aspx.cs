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
    public partial class EditAdmins : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Bind_Grid();
            }
        }

        protected void Bind_Grid()
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "SELECT * FROM Admins";
            
            con.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataSet ds = new DataSet();
            adpt.Fill(ds);

            gv_Admins.DataSource = ds;
            gv_Admins.DataBind();
            con.Close();
        }

        protected void gv_Admins_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_Admins.SelectedRow;
            txt_AdminID.Text = row.Cells[1].Text;
            txt_Username.Text = row.Cells[2].Text;
            txt_Email.Text = row.Cells[3].Text;
            txt_Password.Text = row.Cells[4].Text;
            txt_Role.Text = row.Cells[5].Text;
            txt_CreatedAt.Text = row.Cells[6].Text;
        }
        
        protected void gv_Admins_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_Admins.Rows[e.RowIndex];
            int adminID = Convert.ToInt32(row.Cells[1].Text);

            string qry = "DELETE FROM Admins WHERE AdminId = @AdminId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@AdminId", adminID);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            Bind_Grid();
        }

        protected void btn_Save_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "UPDATE Admins SET Username = @Username, Email = @Email, Password = @Password, Role = @Role WHERE AdminId = @AdminId";

            SqlCommand cmd = new SqlCommand(qry, con);
            cmd.Parameters.AddWithValue("@AdminId", txt_AdminID.Text);
            cmd.Parameters.AddWithValue("@Username", txt_Username.Text);
            cmd.Parameters.AddWithValue("@Email", txt_Email.Text);
            cmd.Parameters.AddWithValue("@Password", txt_Password.Text);
            cmd.Parameters.AddWithValue("@Role", txt_Role.Text);
            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("Admin Details Updated..");
            con.Close();
        }

        protected void btn_Insert_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "INSERT INTO Admins(Username,Email,Password,Role) VALUES(@Username,@Email,@Password,@Role);";

            SqlCommand cmd = new SqlCommand(qry, con);
            //cmd.Parameters.AddWithValue("@AdminId", txt_AdminID.Text);
            cmd.Parameters.AddWithValue("@Username", txt_Username.Text);
            cmd.Parameters.AddWithValue("@Email", txt_Email.Text);
            cmd.Parameters.AddWithValue("@Password", txt_Password.Text);
            cmd.Parameters.AddWithValue("@Role", txt_Role.Text);
            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record Inserted..');</script>");
            con.Close();
        }
    }
}