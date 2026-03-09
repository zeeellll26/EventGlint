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
    public partial class EditShows : System.Web.UI.Page
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
            String qry = "select * from Shows";

            con.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataSet ds = new DataSet();
            adpt.Fill(ds);

            gv_shows.DataSource = ds;
            gv_shows.DataBind();
            con.Close();
        }

        protected void gv_shows_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_shows.SelectedRow;
            txt_showId.Text = row.Cells[1].Text;
            txt_eventid.Text = row.Cells[2].Text;
            txt_hallid.Text = row.Cells[3].Text;
            txt_showDate.Text = row.Cells[4].Text;
            txt_startTime.Text = row.Cells[5].Text;
            txt_endTime.Text = row.Cells[6].Text;
            txt_status.Text = row.Cells[7].Text;
            txt_createdAt.Text = row.Cells[8].Text;
        }

        protected void gv_shows_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_shows.Rows[e.RowIndex];
            int ShowId = Convert.ToInt32(row.Cells[1].Text);

            String qry = "delete from Shows where ShowId=@ShowId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@ShowId", ShowId);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            bind_grid();
        }

        protected void btn_bookShow_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            String qry = "insert into Shows(ShowId,EventId,HallId,ShowDate,StartTime,EndTime,Status,CreatedAt)values(@ShowId,@EventId,@HallId,@ShowDate,@StartTime,@EndTime,@Status,@CreatedAt)";

            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@ShowId", txt_showId.Text);
            cmd.Parameters.AddWithValue("@EventId", txt_eventid.Text);
            cmd.Parameters.AddWithValue("@HallId", txt_hallid.Text);
            cmd.Parameters.AddWithValue("@ShowDate", txt_showDate.Text);
            cmd.Parameters.AddWithValue("@StartTime", txt_startTime.Text);
            cmd.Parameters.AddWithValue("@EndTime", txt_endTime.Text);
            cmd.Parameters.AddWithValue("@Status", txt_status.Text);
            cmd.Parameters.AddWithValue("@CreatedAt", txt_createdAt.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record inserted...!');</script>");
            con.Close();

        }
    }
}
