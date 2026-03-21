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
        //String connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        // =====================================================================
        //  Page Load
        // =====================================================================
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("~/Log.aspx");
                return;
            }

            string name = Session["Username"]?.ToString() ?? "A";
            lbl_AvatarInitial.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "A";

            if (!IsPostBack)
                LoadGrid();
        }

        // =====================================================================
        //  Load GridView
        // =====================================================================
        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT BookedSeatId, BookingId, SeatId, ShowId, PricePaid, Status, HeldUntil FROM BookedSeats ORDER BY BookedSeatId DESC", con);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvBookedSeats.DataSource = dt;
                    gvBookedSeats.DataBind();
                    lblCount.Text = dt.Rows.Count + " record(s)";
                }
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error loading data: " + ex.Message, false);
            }
        }

        // =====================================================================
        //  INSERT
        // =====================================================================
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!ValidateFields()) return;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO BookedSeats (BookingId, SeatId, ShowId, PricePaid, Status, HeldUntil)
                          VALUES (@bid, @sid, @shid, @price, @status, @held)", con);

                    cmd.Parameters.AddWithValue("@bid", int.Parse(txtBookingId.Text.Trim()));
                    cmd.Parameters.AddWithValue("@sid", int.Parse(txtSeatId.Text.Trim()));
                    cmd.Parameters.AddWithValue("@shid", int.Parse(txtShowId.Text.Trim()));
                    cmd.Parameters.AddWithValue("@price", decimal.Parse(txtPricePaid.Text.Trim()));
                    cmd.Parameters.AddWithValue("@status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@held",
                        string.IsNullOrEmpty(txtHeldUntil.Text) ? (object)DBNull.Value : DateTime.Parse(txtHeldUntil.Text));

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ShowMessage("✅ Booked seat inserted successfully!", true);
                ClearFields();
                LoadGrid();
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        // =====================================================================
        //  SAVE (Update)
        // =====================================================================
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtBookedSeatId.Text))
            {
                ShowMessage("⚠️ Please select a record first using the Edit button.", false);
                return;
            }
            if (!ValidateFields()) return;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE BookedSeats
                          SET BookingId=@bid, SeatId=@sid, ShowId=@shid,
                              PricePaid=@price, Status=@status, HeldUntil=@held
                          WHERE BookedSeatId=@id", con);

                    cmd.Parameters.AddWithValue("@bid", int.Parse(txtBookingId.Text.Trim()));
                    cmd.Parameters.AddWithValue("@sid", int.Parse(txtSeatId.Text.Trim()));
                    cmd.Parameters.AddWithValue("@shid", int.Parse(txtShowId.Text.Trim()));
                    cmd.Parameters.AddWithValue("@price", decimal.Parse(txtPricePaid.Text.Trim()));
                    cmd.Parameters.AddWithValue("@status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@held",
                        string.IsNullOrEmpty(txtHeldUntil.Text) ? (object)DBNull.Value : DateTime.Parse(txtHeldUntil.Text));
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtBookedSeatId.Text.Trim()));

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ShowMessage("✅ Booked seat updated successfully!", true);
                ClearFields();
                LoadGrid();
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        // =====================================================================
        //  CLEAR
        // =====================================================================
        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearFields();
            lblMessage.Visible = false;
        }

        // =====================================================================
        //  GridView RowCommand
        // =====================================================================
        protected void gvBookedSeats_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "SelectRow")
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        SqlCommand cmd = new SqlCommand(
                            "SELECT * FROM BookedSeats WHERE BookedSeatId=@id", con);
                        cmd.Parameters.AddWithValue("@id", id);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            DataRow row = dt.Rows[0];
                            txtBookedSeatId.Text = row["BookedSeatId"].ToString();
                            txtBookingId.Text = row["BookingId"].ToString();
                            txtSeatId.Text = row["SeatId"].ToString();
                            txtShowId.Text = row["ShowId"].ToString();
                            txtPricePaid.Text = row["PricePaid"].ToString();
                            ddlStatus.SelectedValue = row["Status"].ToString();
                            txtHeldUntil.Text = row["HeldUntil"] == DBNull.Value ? "" :
                                Convert.ToDateTime(row["HeldUntil"]).ToString("yyyy-MM-ddTHH:mm");
                            lblMessage.Visible = false;
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("❌ Error: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        SqlCommand cmd = new SqlCommand(
                            "DELETE FROM BookedSeats WHERE BookedSeatId=@id", con);
                        cmd.Parameters.AddWithValue("@id", id);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }

                    ShowMessage("🗑️ Record deleted successfully!", true);
                    ClearFields();
                    LoadGrid();
                }
                catch (Exception ex)
                {
                    ShowMessage("❌ Error: " + ex.Message, false);
                }
            }
        }

        // =====================================================================
        //  Helpers
        // =====================================================================
        private void ClearFields()
        {
            txtBookedSeatId.Text = txtBookingId.Text = txtSeatId.Text =
            txtShowId.Text = txtPricePaid.Text = txtHeldUntil.Text = "";
            ddlStatus.SelectedIndex = 0;
        }

        private bool ValidateFields()
        {
            if (string.IsNullOrEmpty(txtBookingId.Text.Trim()))
            { ShowMessage("⚠️ Booking ID is required.", false); return false; }
            if (string.IsNullOrEmpty(txtSeatId.Text.Trim()))
            { ShowMessage("⚠️ Seat ID is required.", false); return false; }
            if (string.IsNullOrEmpty(txtShowId.Text.Trim()))
            { ShowMessage("⚠️ Show ID is required.", false); return false; }
            if (string.IsNullOrEmpty(txtPricePaid.Text.Trim()))
            { ShowMessage("⚠️ Price Paid is required.", false); return false; }
            if (string.IsNullOrEmpty(ddlStatus.SelectedValue))
            { ShowMessage("⚠️ Please select a Status.", false); return false; }
            return true;
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = success ? "alert msg-success" : "alert msg-error";
            lblMessage.Visible = true;
        }

        public string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Confirmed": return "s-confirmed";
                case "Held": return "s-held";
                case "Released": return "s-released";
                default: return "s-held";
            }
        }
    }
}