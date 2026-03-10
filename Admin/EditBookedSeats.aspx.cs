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
    public partial class EditBookedSeats : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bind_grid();
            }
        }

        public void bind_grid()
        {
            SqlConnection con = new SqlConnection(strcon);
            String qry = "select * from BookedSeats";

            con.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataSet ds = new DataSet();
            adpt.Fill(ds);

            gv_bookedSeats.DataSource = ds;
            gv_bookedSeats.DataBind();
            con.Close();

        }

        protected void gv_bookedSeats_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_bookedSeats.SelectedRow;
            txt_bookedSeatid.Text = row.Cells[1].Text;
            txt_bookingid.Text = row.Cells[2].Text;
            txt_seatid.Text = row.Cells[3].Text;
            txt_showid.Text = row.Cells[4].Text;
            txt_pricePaid.Text = row.Cells[5].Text;
            txt_status.Text = row.Cells[6].Text;
            txt_heldUnit.Text = row.Cells[7].Text;
        }

        protected void gv_bookedSeats_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_bookedSeats.Rows[e.RowIndex];
            int BookedSeatId = Convert.ToInt32(row.Cells[1].Text);

            String qry = "delete from BookedSeats where BookedSeatId=@BookedSeatId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@BookedSeatId", BookedSeatId);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            bind_grid();
        }

        protected void btn_bookSeat_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            String qry = "insert into BookedSeats(BookedSeatId,BookingId,SeatId,ShowId,PricePaid,Status,HeldUntil)values(@BookedSeatId,@BookingId,@SeatId,@ShowId,@PricePaid,@Status,@HeldUntil)";

            SqlCommand cmd = new SqlCommand(qry, con);
            cmd.Parameters.AddWithValue("@BookedSeatId", txt_bookedSeatid.Text);
            cmd.Parameters.AddWithValue("@BookingId", txt_bookingid.Text);
            cmd.Parameters.AddWithValue("@SeatId", txt_seatid.Text);
            cmd.Parameters.AddWithValue("@ShowId", txt_showid.Text);
            cmd.Parameters.AddWithValue("@PricePaid", txt_pricePaid.Text);
            cmd.Parameters.AddWithValue("@Status", txt_status.Text);
            cmd.Parameters.AddWithValue("@HeldUntil", txt_heldUnit.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record inserted...!');</script>");
            con.Close();
        }
    }
}