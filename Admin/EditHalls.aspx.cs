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
    public partial class EditHalls : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Bind_Grid();
                BindDDL();
            }

        }



        protected void btn_Insert_Click(object sender, EventArgs e)
        {
            String selectedtype = string.Empty;

            if (rbt_2d.Checked)
            {
                selectedtype = rbt_2d.Text;
            }
            else if (rbt_3d.Checked)
            {
                selectedtype = rbt_3d.Text;
            }
            else if (rbt_imax.Checked)
            {
                selectedtype = rbt_imax.Text;
            }
            else
            {
                selectedtype = rbt_4dx.Text;
            }

            SqlConnection con = new SqlConnection(strcon);

            string qry = "INSERT INTO Halls(VenueId,Name,HallType,TotalCapacity) VALUES(@id,@name,@type,@totcap);";

            SqlCommand cmd = new SqlCommand(qry, con);


            //cmd.Parameters.AddWithValue("@id", ddl_Venue.SelectedItem.Text);
            cmd.Parameters.AddWithValue("@id", ddl_Venue.SelectedValue);
            cmd.Parameters.AddWithValue("@name", ddl_Hall.SelectedItem.Text);
            cmd.Parameters.AddWithValue("@type", selectedtype);
            //cmd.Parameters.AddWithValue("@totcap", txt_tot_cap.Text);
            cmd.Parameters.AddWithValue("@totcap", Convert.ToInt32(txt_tot_cap.Text));
            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record Inserted..');</script>");
            con.Close();

        }

        protected void btn_Update_Click(object sender, EventArgs e)
        {
            string selectedtype = "";

            if (rbt_2d.Checked)
                selectedtype = rbt_2d.Text;
            else if (rbt_3d.Checked)
                selectedtype = rbt_3d.Text;
            else if (rbt_imax.Checked)
                selectedtype = rbt_imax.Text;
            else
                selectedtype = rbt_4dx.Text;

            SqlConnection con = new SqlConnection(strcon);

            string qry = "UPDATE Halls SET VenueId=@id, Name=@name, HallType=@type, TotalCapacity=@totcap WHERE HallId=@h_id";

            SqlCommand cmd = new SqlCommand(qry, con);

            int hallId = Convert.ToInt32(gv_Halls.DataKeys[gv_Halls.SelectedIndex].Value);

            cmd.Parameters.AddWithValue("@h_id", hallId);
            cmd.Parameters.AddWithValue("@id", ddl_Venue.SelectedValue);
            cmd.Parameters.AddWithValue("@name", ddl_Hall.SelectedItem.Text);
            cmd.Parameters.AddWithValue("@type", selectedtype);
            cmd.Parameters.AddWithValue("@totcap", Convert.ToInt32(txt_tot_cap.Text));

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Response.Write("<script>alert('Record Updated');</script>");
            Bind_Grid();
        }

        public void Bind_Grid()
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = @"SELECT h.HallId,
                          v.Name AS VenueName,
                          h.Name,
                          h.HallType,
                          h.TotalCapacity
                   FROM Halls h
                   INNER JOIN Venues v ON h.VenueId = v.VenueId";

            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataTable dt = new DataTable();
            adpt.Fill(dt);

            gv_Halls.DataSource = dt;
            gv_Halls.DataBind();
        }

        protected void gv_Halls_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_Halls.SelectedRow;

            // Venue
            string venueName = row.Cells[2].Text;
            if (ddl_Venue.Items.FindByText(venueName) != null)
            {
                ddl_Venue.ClearSelection();
                ddl_Venue.Items.FindByText(venueName).Selected = true;
            }

            // 🔹 Load halls for selected venue
            LoadHalls();

            // Hall
            string hallName = row.Cells[3].Text;
            if (ddl_Hall.Items.FindByText(hallName) != null)
            {
                ddl_Hall.ClearSelection();
                ddl_Hall.Items.FindByText(hallName).Selected = true;
            }

            string hallType = row.Cells[4].Text;

            if (hallType == "2D") rbt_2d.Checked = true;
            else if (hallType == "3D") rbt_3d.Checked = true;
            else if (hallType == "IMAX") rbt_imax.Checked = true;
            else if (hallType == "4DX") rbt_4dx.Checked = true;

            txt_tot_cap.Text = row.Cells[5].Text;
        }

        public void LoadHalls()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            SqlCommand cmd = new SqlCommand("select * from Halls where VenueId=@VenueId", con);
            cmd.Parameters.AddWithValue("@VenueId", ddl_Venue.SelectedValue);

            ddl_Hall.DataSource = cmd.ExecuteReader();
            ddl_Hall.DataTextField = "Name";
            ddl_Hall.DataValueField = "HallId";
            ddl_Hall.DataBind();

            con.Close();
        }
        //You are trying to delete a Hall that still has Seats connected to it.


        //protected void gv_Halls_RowDeleting(object sender, GridViewDeleteEventArgs e)
        //{
        //    GridViewRow row = gv_Halls.Rows[e.RowIndex];
        //    int HallId = Convert.ToInt32(row.Cells[1].Text);

        //    string qry = "DELETE FROM Halls WHERE HallId = @HallId";

        //    SqlConnection con = new SqlConnection(strcon);
        //    SqlCommand cmd = new SqlCommand(qry, con);

        //    cmd.Parameters.AddWithValue("@HallId", HallId);
        //    con.Open();
        //    cmd.ExecuteNonQuery();
        //    con.Close();
        //    Bind_Grid();
        //}
        protected void gv_Halls_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_Halls.Rows[e.RowIndex];
            int HallId = Convert.ToInt32(row.Cells[1].Text);

            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            // delete seats first
            SqlCommand cmd1 = new SqlCommand("DELETE FROM Seats WHERE HallId=@HallId", con);
            cmd1.Parameters.AddWithValue("@HallId", HallId);
            cmd1.ExecuteNonQuery();

            // then delete hall
            SqlCommand cmd2 = new SqlCommand("DELETE FROM Halls WHERE HallId=@HallId", con);
            cmd2.Parameters.AddWithValue("@HallId", HallId);
            cmd2.ExecuteNonQuery();

            con.Close();

            Bind_Grid();
        }

        protected void ddl_Venue_SelectedIndexChanged(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from Halls where VenueId=@VenueId", con);
            cmd.Parameters.AddWithValue("VenueId", ddl_Venue.SelectedValue);
            ddl_Hall.DataSource = cmd.ExecuteReader();
            ddl_Hall.DataTextField = "Name";
            ddl_Hall.DataValueField = "HallId";
            ddl_Hall.DataBind();
            con.Close();
        }

        public void BindDDL()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            String query = "select * from Venues";
            SqlDataAdapter sda = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            ddl_Venue.DataSource = dt;
            ddl_Venue.DataBind();
            ddl_Venue.DataTextField = "Name";
            ddl_Venue.DataValueField = "VenueId";
            ddl_Venue.DataBind();
            con.Close();

        }

    }
}