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
    public partial class EditVenue : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                Bind_Grid();
                BindDDL();
                BindVenue();
            }

        }
        protected void btn_Insert_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "INSERT INTO Venues(Name,CityId,Address,Phone,Email,Amenities,Images,CreatedAt) VALUES(@name,@cityid,@add,@phone,@email,@amen,@img,@create);";

            SqlCommand cmd = new SqlCommand(qry, con);
            //cmd.Parameters.AddWithValue("@AdminId", txt_AdminID.Text);
            //cmd.Parameters.AddWithValue("@name", ddl_Venue.SelectedValue);
            cmd.Parameters.AddWithValue("@name", ddl_Venue.SelectedItem.Text);
            cmd.Parameters.AddWithValue("@cityid", ddl_City.SelectedValue);
            cmd.Parameters.AddWithValue("@add", txt_Add.Text);
            cmd.Parameters.AddWithValue("@phone", txt_Phone.Text);
            cmd.Parameters.AddWithValue("@email", txt_Email.Text);
            cmd.Parameters.AddWithValue("@amen", txt_Amenities.Text);
            cmd.Parameters.AddWithValue("@img", txt_Images.Text);
            cmd.Parameters.AddWithValue("@create", txt_CreatedAt.Text);
            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record Inserted..');</script>");
            con.Close();
        }



        protected void btn_Update_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "UPDATE Venues SET Name=@name, CityId=@cityid, Address=@add, Phone=@phone, Email=@email, Amenities=@amen, Images=@img, CreatedAt=@create WHERE VenueId=@venueid";

            SqlCommand cmd = new SqlCommand(qry, con);

            int venueId = Convert.ToInt32(gv_Venues.DataKeys[gv_Venues.SelectedIndex].Value);

            cmd.Parameters.AddWithValue("@venueid", venueId);
            //cmd.Parameters.AddWithValue("@name", ddl_Venue.SelectedValue);
            cmd.Parameters.AddWithValue("@name", ddl_Venue.SelectedItem.Text);
            cmd.Parameters.AddWithValue("@cityid", ddl_City.SelectedValue);
            cmd.Parameters.AddWithValue("@add", txt_Add.Text);
            cmd.Parameters.AddWithValue("@phone", txt_Phone.Text);
            cmd.Parameters.AddWithValue("@email", txt_Email.Text);
            cmd.Parameters.AddWithValue("@amen", txt_Amenities.Text);
            cmd.Parameters.AddWithValue("@img", txt_Images.Text);
            cmd.Parameters.AddWithValue("@create", txt_CreatedAt.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Bind_Grid();

            Response.Write("<script>alert('Record Updated Successfully');</script>");
        }
        protected void gv_Venues_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_Venues.SelectedRow;

            // Venue
            string venueName = row.Cells[2].Text;
            if (ddl_Venue.Items.FindByText(venueName) != null)
            {
                ddl_Venue.ClearSelection();
                ddl_Venue.Items.FindByText(venueName).Selected = true;
            }

            // City
            string cityName = row.Cells[3].Text;
            if (ddl_City.Items.FindByText(cityName) != null)
            {
                ddl_City.ClearSelection();
                ddl_City.Items.FindByText(cityName).Selected = true;
            }

            txt_Add.Text = row.Cells[4].Text;
            txt_Phone.Text = row.Cells[5].Text;
            txt_Email.Text = row.Cells[6].Text;
            txt_Amenities.Text = row.Cells[7].Text == "&nbsp;" ? "" : row.Cells[7].Text;
            txt_Images.Text = row.Cells[8].Text == "&nbsp;" ? "" : row.Cells[8].Text;
            txt_CreatedAt.Text = row.Cells[9].Text;
        }

        public void BindVenue()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            string qry = "SELECT VenueId, Name FROM Venues";

            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataTable dt = new DataTable();
            adpt.Fill(dt);

            ddl_Venue.DataSource = dt;
            ddl_Venue.DataTextField = "Name";
            ddl_Venue.DataValueField = "VenueId";
            ddl_Venue.DataBind();

            ddl_Venue.Items.Insert(0, new ListItem("Select Venue", "0"));

            con.Close();
        }
        protected void gv_Venues_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_Venues.Rows[e.RowIndex];
            int vID = Convert.ToInt32(row.Cells[1].Text);

            string qry = "DELETE FROM Venues WHERE VenueId = @VId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@VId", vID);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            Bind_Grid();
        }

        protected void ddl_City_SelectedIndexChanged(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from Venues where CityId=@CityId", con);
            cmd.Parameters.AddWithValue("CityId", ddl_City.SelectedValue);
            ddl_Venue.DataSource = cmd.ExecuteReader();
            ddl_Venue.DataTextField = "Name";
            ddl_Venue.DataValueField = "VenueId";
            ddl_Venue.DataBind();
            con.Close();
        }
        public void BindDDL()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            String query = "select * from Cities";
            SqlDataAdapter sda = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            ddl_City.DataSource = dt;
            ddl_City.DataTextField = "Name";
            ddl_City.DataValueField = "CityId";
            ddl_City.DataBind();
            ddl_City.Items.Insert(0, new ListItem("Select City", "0"));
            con.Close();
        }

        public void Bind_Grid()
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = @"SELECT v.VenueId, v.Name, c.Name AS City, 
                   v.Address, v.Phone, v.Email, 
                   v.Amenities, v.Images, v.CreatedAt
                   FROM Venues v
                   INNER JOIN Cities c ON v.CityId = c.CityId";

            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataTable dt = new DataTable();
            adpt.Fill(dt);

            gv_Venues.DataSource = dt;
            gv_Venues.DataBind();
        }

    }
}