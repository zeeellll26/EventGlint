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
    public partial class SeatCategories : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Bind_Grid();
                BindHallDDL();
            }

        }

        protected void btn_Insert_Click(object sender, EventArgs e)
        {
            String selectedtype = string.Empty;
            if (rbt_gold.Checked)
            {
                selectedtype = rbt_gold.Text;
            }
            else if (rbt_silver.Checked)
            {
                selectedtype = rbt_silver.Text;
            }
            else
            {
                selectedtype = rbt_platinum.Text;
            }
            SqlConnection con = new SqlConnection(strcon);

            string qry = "INSERT INTO SeatCategories(HallId,Name,Price,ColorCode) VALUES(@id,@name,@price,@color)";

            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@id", ddl_Hall.SelectedValue);
            cmd.Parameters.AddWithValue("@name", selectedtype);
            cmd.Parameters.AddWithValue("@price", txt_price.Text);
            cmd.Parameters.AddWithValue("@color", txt_color.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Response.Write("<script>alert('Record Inserted..');</script>");

            Bind_Grid();
        }

        protected void btn_Update_Click(object sender, EventArgs e)
        {
            String selectedtype = string.Empty;
            if (rbt_gold.Checked)
            {
                selectedtype = rbt_gold.Text;
            }
            else if (rbt_silver.Checked)
            {
                selectedtype = rbt_silver.Text;
            }
            else
            {
                selectedtype = rbt_platinum.Text;
            }
            SqlConnection con = new SqlConnection(strcon);

            string qry = "UPDATE SeatCategories SET HallId=@id, Name=@name, Price=@price, ColorCode=@color WHERE CategoryId=@c_id";

            SqlCommand cmd = new SqlCommand(qry, con);

            int catId = Convert.ToInt32(gv_Category.DataKeys[gv_Category.SelectedIndex].Value);

            cmd.Parameters.AddWithValue("@c_id", catId);
            cmd.Parameters.AddWithValue("@id", ddl_Hall.SelectedValue);
            cmd.Parameters.AddWithValue("@name", selectedtype);
            cmd.Parameters.AddWithValue("@price", txt_price.Text);
            cmd.Parameters.AddWithValue("@color", txt_color.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Response.Write("<script>alert('Record Updated');</script>");
            Bind_Grid();
        }
        protected void Bind_Grid()
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = @"SELECT sc.CategoryId,
               sc.HallId,
               h.Name AS HallName,
               sc.Name AS SeatCategory,
               sc.Price,
               sc.ColorCode
        FROM SeatCategories sc
        INNER JOIN Halls h ON sc.HallId = h.HallId";

            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataSet ds = new DataSet();
            adpt.Fill(ds);

            gv_Category.DataSource = ds;
            gv_Category.DataBind();
        }


        protected void gv_Category_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gv_Category.SelectedRow;

            int hallId = Convert.ToInt32(gv_Category.DataKeys[gv_Category.SelectedIndex].Values["HallId"]);
            ddl_Hall.SelectedValue = hallId.ToString();

            string cat = row.Cells[4].Text;

            if (cat == "Silver") rbt_silver.Checked = true;
            else if (cat == "Gold") rbt_gold.Checked = true;
            else if (cat == "Platinum") rbt_platinum.Checked = true;

            txt_price.Text = row.Cells[5].Text;
            txt_color.Text = row.Cells[6].Text;
        }
        protected void gv_Category_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = gv_Category.Rows[e.RowIndex];
            //int CategoryId = Convert.ToInt32(row.Cells[1].Text);
            int CategoryId = Convert.ToInt32(gv_Category.DataKeys[e.RowIndex].Value);


            string qry = "DELETE FROM SeatCategories WHERE CategoryId = @CategoryId";

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(qry, con);

            cmd.Parameters.AddWithValue("@CategoryId", CategoryId);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            Bind_Grid();
        }

        protected void BindHallDDL()
        {
            SqlConnection con = new SqlConnection(strcon);

            string qry = "SELECT HallId, Name FROM Halls";

            SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
            DataTable dt = new DataTable();
            adpt.Fill(dt);

            ddl_Hall.DataSource = dt;
            ddl_Hall.DataTextField = "Name";
            ddl_Hall.DataValueField = "HallId";
            ddl_Hall.DataBind();

            ddl_Hall.Items.Insert(0, new ListItem("Select Hall", "0"));
        }

    }
}