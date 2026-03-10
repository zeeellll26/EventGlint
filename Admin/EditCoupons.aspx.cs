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
    public partial class EditCoupons : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGrid();
            }

        }

        void LoadGrid()
        {
            SqlConnection con = new SqlConnection(strcon);
            SqlDataAdapter da = new SqlDataAdapter("select * from Coupons", con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        // INSERT
        protected void btnSave_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            string query = "insert into Coupons(Code,DiscountType,DiscountValue,MaxDiscount,MinOrderValue,ValidFrom,ValidTill,UsageLimit,UsedCount,CreatedAt)" +
                " values(@Code,@Type,@Value,@Max,@Min,@From,@Till,@Limit,@Used,@Created)";

            SqlCommand cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@Code", txtCode.Text);
            cmd.Parameters.AddWithValue("@Type", rblDiscountType.SelectedValue);
            cmd.Parameters.AddWithValue("@Value", txtDiscountValue.Text);
            cmd.Parameters.AddWithValue("@Max", txtMaxDiscount.Text);
            cmd.Parameters.AddWithValue("@Min", txtMinOrderValue.Text);
            cmd.Parameters.AddWithValue("@From", Convert.ToDateTime(txtValidFrom.Text));
            cmd.Parameters.AddWithValue("@Till", Convert.ToDateTime(txtValidTill.Text));
            cmd.Parameters.AddWithValue("@Limit", txtUsageLimit.Text);
            cmd.Parameters.AddWithValue("@Used", txtUsedCount.Text);
            cmd.Parameters.AddWithValue("@Created", Convert.ToDateTime(txtCreatedAt.Text));

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("inserted successfully!");
            con.Close();

            LoadGrid();
        }

        // SELECT RECORD FROM GRID
        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtCode.Text = GridView1.SelectedRow.Cells[2].Text;
            rblDiscountType.SelectedValue = GridView1.SelectedRow.Cells[3].Text;
            txtDiscountValue.Text = GridView1.SelectedRow.Cells[4].Text;
            txtMaxDiscount.Text = GridView1.SelectedRow.Cells[5].Text;
            txtMinOrderValue.Text = GridView1.SelectedRow.Cells[6].Text;
            txtValidFrom.Text = GridView1.SelectedRow.Cells[7].Text;
            txtValidTill.Text = GridView1.SelectedRow.Cells[8].Text;
            txtUsageLimit.Text = GridView1.SelectedRow.Cells[9].Text;
            txtUsedCount.Text = GridView1.SelectedRow.Cells[10].Text;
            txtCreatedAt.Text = GridView1.SelectedRow.Cells[11].Text;
        }

        // UPDATE
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            int id = Convert.ToInt32(GridView1.SelectedRow.Cells[1].Text);

            string query = "UPDATE Coupons SET Code=@Code, DiscountType=@Type, DiscountValue=@Value, MaxDiscount=@max, MinOrderValue=@Min, ValidFrom=@From, ValidTill=@Till, UsageLimit=@Limit, UsedCount=@Used, CreatedAt=@Created WHERE CouponId=@Id";

            SqlCommand cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@Code", txtCode.Text);
            cmd.Parameters.AddWithValue("@Type", rblDiscountType.SelectedValue);
            cmd.Parameters.AddWithValue("@Value", txtDiscountValue.Text);
            cmd.Parameters.AddWithValue("@max", txtMaxDiscount.Text);
            cmd.Parameters.AddWithValue("@Min", txtMinOrderValue.Text);
            DateTime fromDate, tillDate, createdDate;

            DateTime.TryParse(txtValidFrom.Text, out fromDate);
            DateTime.TryParse(txtValidTill.Text, out tillDate);
            DateTime.TryParse(txtCreatedAt.Text, out createdDate);

            cmd.Parameters.AddWithValue("@From", fromDate);
            cmd.Parameters.AddWithValue("@Till", tillDate);
            cmd.Parameters.AddWithValue("@Limit", txtUsageLimit.Text);
            cmd.Parameters.AddWithValue("@Used", txtUsedCount.Text);
            cmd.Parameters.AddWithValue("@Created", createdDate);
            cmd.Parameters.AddWithValue("@Id", id);

            con.Open();
            cmd.ExecuteNonQuery();
            LoadGrid();
            con.Close();

            Response.Write("Updated Successfully");
        }


        // DELETE
        protected void GridView1_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);

            int id = Convert.ToInt32(GridView1.SelectedRow.Cells[1].Text);

            string query = "DELETE FROM Coupons WHERE CouponId=@Id";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Id", id);

            con.Open();
            cmd.ExecuteNonQuery();
            LoadGrid();
            con.Close();

            Response.Write("Deleted Successfully");

        }
    }
}



