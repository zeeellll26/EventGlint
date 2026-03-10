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
    public partial class EditBookings : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                LoadGrid();
            }
        }
        void LoadGrid()
        {
            SqlDataAdapter da = new SqlDataAdapter("select * from Bookings", con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            GridView11.DataSource = dt;
            GridView11.DataBind();
        }

        //// SHOW DROPDOWN 
        //void BindShow()
        //{
        //    SqlCommand cmd = new SqlCommand("select ShowId, ShowName from Shows", con);
        //    SqlDataAdapter da = new SqlDataAdapter(cmd);
        //    DataTable dt = new DataTable();
        //    da.Fill(dt);

        //    ddlShowId.DataSource = dt;
        //    ddlShowId.DataTextField = "ShowName";
        //    ddlShowId.DataValueField = "ShowId";
        //    ddlShowId.DataBind();

        //    ddlShowId.Items.Insert(0, "Select Show");
        //}

        //// COUPON DROPDOWN
        //void BindCoupon()
        //{
        //    SqlCommand cmd = new SqlCommand("select CouponId, CouponName from Coupons", con);
        //    SqlDataAdapter da = new SqlDataAdapter(cmd);
        //    DataTable dt = new DataTable();
        //    da.Fill(dt);

        //    ddlCouponId.DataSource = dt;
        //    ddlCouponId.DataTextField = "CouponName";
        //    ddlCouponId.DataValueField = "CouponId";
        //    ddlCouponId.DataBind();

        //    ddlCouponId.Items.Insert(0, "Select Coupon");
        //}

        // INSERT
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            SqlCommand cmd = new SqlCommand("insert into Bookings values(@UserId,@ShowId,@BookingDate,@TotalAmount,@DiscountAmount,@FinalAmount,@Status,@BookingRef,@CouponId)", con);

            cmd.Parameters.AddWithValue("@UserId", txtUserId.Text);
            cmd.Parameters.AddWithValue("@ShowId", ddlShowId.SelectedValue);
            cmd.Parameters.AddWithValue("@BookingDate", txtBookingDate.Text);
            cmd.Parameters.AddWithValue("@TotalAmount", txtTotalAmount.Text);
            cmd.Parameters.AddWithValue("@DiscountAmount", txtDiscountAmount.Text);
            cmd.Parameters.AddWithValue("@FinalAmount", txtFinalAmount.Text);
            cmd.Parameters.AddWithValue("@Status", rblStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@BookingRef", txtBookingRef.Text);
            cmd.Parameters.AddWithValue("@CouponId", ddlCouponId.SelectedValue);

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("inserted successfully!");
            con.Close();

            LoadGrid();
        }


        // GRIDVIEW SELECT
        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtBookingId.Text = GridView11.SelectedRow.Cells[1].Text;
            txtUserId.Text = GridView11.SelectedRow.Cells[2].Text;
            ddlShowId.SelectedValue = GridView11.SelectedRow.Cells[3].Text;
            txtBookingDate.Text = GridView11.SelectedRow.Cells[4].Text;
            txtTotalAmount.Text = GridView11.SelectedRow.Cells[5].Text;
            txtDiscountAmount.Text = GridView11.SelectedRow.Cells[6].Text;
            txtFinalAmount.Text = GridView11.SelectedRow.Cells[7].Text;
            rblStatus.SelectedValue = GridView11.SelectedRow.Cells[8].Text;
            txtBookingRef.Text = GridView11.SelectedRow.Cells[9].Text;
            ddlCouponId.SelectedValue = GridView11.SelectedRow.Cells[10].Text;
        }

        // UPDATE
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            SqlCommand cmd = new SqlCommand("update Bookings set UserId=@UserId,ShowId=@ShowId,BookingDate=@BookingDate,TotalAmount=@TotalAmount,DiscountAmount=@DiscountAmount,FinalAmount=@FinalAmount,Status=@Status,BookingRef=@BookingRef,CouponId=@CouponId where BookingId=@BookingId", con);

            cmd.Parameters.AddWithValue("@BookingId", txtBookingId.Text);
            cmd.Parameters.AddWithValue("@UserId", txtUserId.Text);
            cmd.Parameters.AddWithValue("@ShowId", ddlShowId.SelectedValue);
            cmd.Parameters.AddWithValue("@BookingDate", txtBookingDate.Text);
            cmd.Parameters.AddWithValue("@TotalAmount", txtTotalAmount.Text);
            cmd.Parameters.AddWithValue("@DiscountAmount", txtDiscountAmount.Text);
            cmd.Parameters.AddWithValue("@FinalAmount", txtFinalAmount.Text);
            cmd.Parameters.AddWithValue("@Status", rblStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@BookingRef", txtBookingRef.Text);
            cmd.Parameters.AddWithValue("@CouponId", ddlCouponId.SelectedValue);

            con.Open();
            cmd.ExecuteNonQuery();
            Response.Write("updated successfully!");

            con.Close();

            LoadGrid();
        }

        // DELETE
        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(GridView11.DataKeys[e.RowIndex].Value);

            SqlCommand cmd = new SqlCommand("delete from Bookings where BookingId=@BookingId", con);
            cmd.Parameters.AddWithValue("@BookingId", id);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            LoadGrid();
            Response.Write("deleted successfully!");

        }

    }
}
