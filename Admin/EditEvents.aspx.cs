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
    public partial class EditEvents : System.Web.UI.Page
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
            String qry = "select * from Events";

            con.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataSet ds = new DataSet();
            adpt.Fill(ds);

            gv_event.DataSource = ds;
            gv_event.DataBind();
            con.Close();
        }
        protected void gv_event_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_event.SelectedRow;
            txt_eventId.Text = row.Cells[1].Text;
            txt_title.Text = row.Cells[2].Text;
            txt_eventType.Text = row.Cells[3].Text;
            txt_description.Text = row.Cells[4].Text;
            txt_durationMins.Text = row.Cells[5].Text;
            txt_language.Text = row.Cells[6].Text;
            txt_genre.Text = row.Cells[7].Text;
            txt_releaseDate.Text = row.Cells[8].Text;
            txt_endDate.Text = row.Cells[9].Text;
            txt_createdAt.Text = row.Cells[10].Text;
            txt_createdBy.Text = row.Cells[11].Text;
        }

        protected void gv_event_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_event.Rows[e.RowIndex];
            int EventId = Convert.ToInt32(row.Cells[1].Text);

            String qry = "delete from Events where EventId=@EventId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@EventId", EventId);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            bind_grid();
        }

        protected void btn_bookEvent_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            String qry = "insert into Events(EventId,Title,EventType,Description,DurationMins,Language,Genre,ReleaseDate,EndDate,CreatedAt,CreatedBy)values(@EventId,@Title,@EventType,@Description,@DurationMins,@Language,@Genre,@ReleaseDate,@EndDate,@CreatedAt,@CreatedBy)";

            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@EventId", txt_eventId.Text);
            cmd.Parameters.AddWithValue("@Title", txt_title.Text);
            cmd.Parameters.AddWithValue("@EventType", txt_eventType.Text);
            cmd.Parameters.AddWithValue("@Description", txt_description.Text);
            cmd.Parameters.AddWithValue("@DurationMins", txt_durationMins.Text);
            cmd.Parameters.AddWithValue("@Language", txt_language.Text);
            cmd.Parameters.AddWithValue("@Genre", txt_genre.Text);
            cmd.Parameters.AddWithValue("@ReleaseDate", txt_releaseDate.Text);
            cmd.Parameters.AddWithValue("@EndDate", txt_endDate.Text);
            cmd.Parameters.AddWithValue("@CreatedAt", txt_createdAt.Text);
            cmd.Parameters.AddWithValue("@CreatedBy", txt_createdBy.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record inserted...!');</script>");
            con.Close();

        }
    }
}
