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
    public partial class EditSeats : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Bind_Grid();
                BindHall();
            }

        }

        protected void btn_Insert_Click(object sender, EventArgs e)
        {
            bool selectedwheel = rbt_yesw.Checked;
            bool selectedactive = rbt_yesa.Checked;

            SqlConnection con = new SqlConnection(strcon);

            string qry = "INSERT INTO Seats(HallId,CategoryId,RowLabel,SeatNumber,IsWheelChair) VALUES(@hid,@cid,@row,@seat,@wheel)";

            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@hid", ddl_Hall.SelectedValue);
            cmd.Parameters.AddWithValue("@cid", ddl_Cat.SelectedValue);
            cmd.Parameters.AddWithValue("@row", txt_row.Text);
            cmd.Parameters.AddWithValue("@seat", txt_seat.Text);
            cmd.Parameters.AddWithValue("@wheel", selectedwheel);
            //cmd.Parameters.AddWithValue("@active", selectedactive);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Response.Write("<script>alert('Record Inserted..');</script>");
            Bind_Grid();
        }

        protected void btn_Update_Click(object sender, EventArgs e)
        {
            bool selectedwheel = rbt_yesw.Checked;
            bool selectedactive = rbt_yesa.Checked;

            SqlConnection con = new SqlConnection(strcon);

            string qry = "UPDATE Seats SET HallId=@hid, CategoryId=@cid, RowLabel=@row, SeatNumber=@seat, IsWheelChair=@wheel  WHERE SeatId=@sid";

            SqlCommand cmd = new SqlCommand(qry, con);

            int seatId = Convert.ToInt32(gv_Seat.DataKeys[gv_Seat.SelectedIndex].Value);

            cmd.Parameters.AddWithValue("@sid", seatId);
            cmd.Parameters.AddWithValue("@hid", ddl_Hall.SelectedValue);
            cmd.Parameters.AddWithValue("@cid", ddl_Cat.SelectedValue);

            cmd.Parameters.AddWithValue("@row", txt_row.Text);
            cmd.Parameters.AddWithValue("@seat", txt_seat.Text);
            cmd.Parameters.AddWithValue("@wheel", selectedwheel);
            //cmd.Parameters.AddWithValue("@active", selectedactive);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Response.Write("<script>alert('Record Updated');</script>");
            Bind_Grid();
        }
        protected void Bind_Grid()
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = @"SELECT   
s.SeatId,  
s.HallId,  
s.CategoryId,  
h.Name AS HallName,  
c.Name AS CategoryName,  
s.RowLabel,  
s.SeatNumber,  
CASE WHEN s.IsWheelChair = 1 THEN 'Yes' ELSE 'No' END AS IsWheelChair
FROM Seats s  
JOIN Halls h ON s.HallId = h.HallId  
JOIN SeatCategories c ON s.CategoryId = c.CategoryId";
            //CASE WHEN s.IsActive = 1 THEN 'Yes' ELSE 'No' END AS IsActive

            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataTable dt = new DataTable();
            adpt.Fill(dt);

            gv_Seat.DataSource = dt;
            gv_Seat.DataBind();

        }


        //protected void gv_Seat_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    GridViewRow row = gv_Seat.SelectedRow;

        //    int hallId = Convert.ToInt32(gv_Seat.DataKeys[gv_Seat.SelectedIndex].Values["HallId"]);
        //    int catId = Convert.ToInt32(gv_Seat.DataKeys[gv_Seat.SelectedIndex].Values["CategoryId"]);

        //    ddl_Hall.SelectedValue = hallId.ToString();
        //    ddl_Cat.SelectedValue = catId.ToString();

        //    txt_row.Text = row.Cells[5].Text;
        //    txt_seat.Text = row.Cells[6].Text;

        //    string wheel = row.Cells[7].Text;
        //    string active = row.Cells[8].Text;

        //    if (wheel == "True")
        //        rbt_yesw.Checked = true;
        //    else
        //        rbt_now.Checked = true;

        //    if (active == "True")
        //        rbt_yesa.Checked = true;
        //    else
        //        rbt_noa.Checked = true;
        //}
        protected void gv_Seat_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_Seat.SelectedRow;

            int hallId = Convert.ToInt32(gv_Seat.DataKeys[gv_Seat.SelectedIndex].Values["HallId"]);
            int catId = Convert.ToInt32(gv_Seat.DataKeys[gv_Seat.SelectedIndex].Values["CategoryId"]);

            ddl_Hall.SelectedValue = hallId.ToString();
            LoadCategoryByHall(hallId);
            ddl_Cat.SelectedValue = catId.ToString();

            txt_row.Text = row.Cells[6].Text;
            txt_seat.Text = row.Cells[7].Text;

            string wheel = row.Cells[8].Text;
            string active = row.Cells[9].Text;

            rbt_yesw.Checked = (wheel == "Yes");
            rbt_now.Checked = (wheel == "No");

            rbt_yesa.Checked = (active == "Yes");
            rbt_noa.Checked = (active == "No");
        }
        public void LoadCategoryByHall(int hallId)
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            SqlCommand cmd = new SqlCommand("select CategoryId, Name from SeatCategories where HallId=@hid", con);
            cmd.Parameters.AddWithValue("@hid", hallId);

            ddl_Cat.DataSource = cmd.ExecuteReader();
            ddl_Cat.DataTextField = "Name";
            ddl_Cat.DataValueField = "CategoryId";
            ddl_Cat.DataBind();

            ddl_Cat.Items.Insert(0, new ListItem("Select Category", "0"));
            con.Close();
        }
        protected void gv_Seat_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int SeatId = Convert.ToInt32(gv_Seat.DataKeys[e.RowIndex].Value);

            string qry = "DELETE FROM Seats WHERE SeatId=@SeatId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@SeatId", SeatId);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Bind_Grid();
        }

        protected void ddl_Hall_SelectedIndexChanged(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            SqlCommand cmd = new SqlCommand("select * from SeatCategories where HallId=@hid", con);
            cmd.Parameters.AddWithValue("@hid", ddl_Hall.SelectedValue);

            ddl_Cat.DataSource = cmd.ExecuteReader();
            ddl_Cat.DataTextField = "Name";
            ddl_Cat.DataValueField = "CategoryId";
            ddl_Cat.DataBind();

            ddl_Cat.Items.Insert(0, new ListItem("Select Category", "0"));
            con.Close();
        }

        public void BindHall()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            String query = "select * from Halls";
            SqlDataAdapter sda = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            ddl_Hall.DataSource = dt;
            ddl_Hall.DataTextField = "Name";
            ddl_Hall.DataValueField = "HallId";
            ddl_Hall.DataBind();

            ddl_Hall.Items.Insert(0, new ListItem("Select Hall", "0"));
            con.Close();
        }

    }
}