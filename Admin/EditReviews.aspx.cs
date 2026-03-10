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
    public partial class EditReviews : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Bind_Grid();
                Bind_ddl_Events();
            }
        }

        protected void Bind_ddl_Events()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string qry = "SELECT * FROM Events";

            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataTable dt = new DataTable();
            adpt.Fill(dt);

            ddl_Events.DataSource = dt;
            ddl_Events.DataBind();
            ddl_Events.DataTextField = "Title";
            ddl_Events.DataValueField = "EventId";
            ddl_Events.DataBind();

            ddl_Events.Items.Insert(0, new ListItem("Select Event", "0"));
            con.Close();
        }
        protected void Bind_Grid()
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "SELECT * FROM Reviews";

            con.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataSet ds = new DataSet();
            adpt.Fill(ds);

            gv_Reviews.DataSource = ds;
            gv_Reviews.DataBind();
            con.Close();
        }

        protected void gv_Reviews_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_Reviews.SelectedRow;
            txt_ReviewId.Text = row.Cells[1].Text;
            txt_UserId.Text = row.Cells[2].Text;
            for(int i = 0; i < ddl_Events.Items.Count; i++)
            {
                if (ddl_Events.Items[i].Text == row.Cells[3].Text)
                {
                    ddl_Events.SelectedIndex = i;
                }
            }
            txt_Rating.Text = row.Cells[4].Text;
            txt_ReviewText.Text = row.Cells[5].Text;
            txt_CreatedAt.Text = row.Cells[6].Text;
        }


        protected void gv_Reviews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_Reviews.Rows[e.RowIndex];
            int reviewId = Convert.ToInt32(row.Cells[1].Text);

            string qry = "DELETE FROM Reviews WHERE ReviewId = @ReviewId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@ReviewId", reviewId);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            Bind_Grid();
        }

        protected void btn_Update_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "UPDATE Reviews SET EventId = @EventId, Rating = @Rating, ReviewText = @ReviewText WHERE ReviewId = @ReviewId";

            SqlCommand cmd = new SqlCommand(qry, con);
            cmd.Parameters.AddWithValue("@ReviewId", txt_ReviewId.Text);
            cmd.Parameters.AddWithValue("@EventId", ddl_Events.SelectedIndex);
            cmd.Parameters.AddWithValue("@Rating", txt_Rating.Text);
            cmd.Parameters.AddWithValue("@ReviewText", txt_ReviewText.Text);
            //cmd.Parameters.AddWithValue("@CreatedAt", txt_CreatedAt.Text);
            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("Review Details Updated..");
            con.Close();
        }

        protected void btn_Insert_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "INSERT INTO Reviews(UserId,EventId,Rating,ReviewText) VALUES(@UserId,@EventId,@Rating,@ReviewText);";

            SqlCommand cmd = new SqlCommand(qry, con);
            cmd.Parameters.AddWithValue("@UserId", txt_UserId.Text);
            cmd.Parameters.AddWithValue("@EventId", ddl_Events.SelectedValue);
            cmd.Parameters.AddWithValue("@Rating", txt_Rating.Text);
            cmd.Parameters.AddWithValue("@ReviewText", txt_ReviewText.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record Inserted..');</script>");
            con.Close();
        }
    }
}