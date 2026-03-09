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
    public partial class EditCities : System.Web.UI.Page
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

            string qry = "SELECT * FROM Cities";

            con.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataSet ds = new DataSet();
            adpt.Fill(ds);

            gv_Cities.DataSource = ds;
            gv_Cities.DataBind();
            con.Close();
        }

        protected void gv_Cities_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_Cities.SelectedRow;
            txt_CityId.Text = row.Cells[1].Text;
            txt_Name.Text = row.Cells[2].Text;
            txt_State.Text = row.Cells[3].Text;
            txt_Country.Text = row.Cells[4].Text;
            txt_CreatedAt.Text = row.Cells[5].Text;
        }


        //protected void gv_Cities_RowDeleting(object sender, GridViewDeleteEventArgs e)
        //{
        //    GridViewRow row = gv_Cities.Rows[e.RowIndex];
        //    int cityID = Convert.ToInt32(row.Cells[1].Text);

        //    string qry = "DELETE FROM Cities WHERE CityId = @CityId";

        //    SqlConnection con = new SqlConnection(strcon);
        //    SqlCommand cmd = new SqlCommand(qry, con);

        //    cmd.Parameters.AddWithValue("@CityId", cityID);
        //    con.Open();
        //    cmd.ExecuteNonQuery();
        //    con.Close();
        //    Bind_Grid();
        //}

        protected void btn_Update_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "UPDATE Cities SET Name = @Name, State = @State, Country = @Country WHERE CityId = @CityId";

            SqlCommand cmd = new SqlCommand(qry, con);
            cmd.Parameters.AddWithValue("@CityId", txt_CityId.Text);
            cmd.Parameters.AddWithValue("@Name", txt_Name.Text);
            cmd.Parameters.AddWithValue("@State", txt_State.Text);
            cmd.Parameters.AddWithValue("@Country", txt_Country.Text);
            //cmd.Parameters.AddWithValue("@CreatedAt", txt_CreatedAt.Text);
            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("City Details Updated..");
            con.Close();
        }

        protected void btn_Insert_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "INSERT INTO Cities(Name,State,Country) VALUES(@Name,@State,@Country);";

            SqlCommand cmd = new SqlCommand(qry, con);
            //cmd.Parameters.AddWithValue("@CityId", txt_CityId.Text);
            cmd.Parameters.AddWithValue("@Name", txt_Name.Text);
            cmd.Parameters.AddWithValue("@State", txt_State.Text);
            cmd.Parameters.AddWithValue("@Country", txt_Country.Text);
            //cmd.Parameters.AddWithValue("@CreatedAt", txt_CreatedAt.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Record Inserted..');</script>");
            con.Close();
        }
    }
}