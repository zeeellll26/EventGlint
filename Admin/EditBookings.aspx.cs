using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditBookings : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Log.aspx"); return; }
            string name = Session["Username"]?.ToString() ?? "A";
            lbl_AvatarInitial.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "A";
            if (!IsPostBack) { BindDropdowns(); LoadGrid(); }
        }

        // ── Bind all dropdowns ─────────────────────────────────────────────
        private void BindDropdowns()
        {
            // Users
            BindDdl(ddlUserId,
                "SELECT UserId, Username + ' (ID:' + CAST(UserId AS NVARCHAR) + ')' AS Label FROM Users ORDER BY Username",
                "UserId", "Label", "-- Select User --");

            // Shows — Event title + date + time
            BindDdl(ddlShowId,
                @"SELECT sh.ShowId,
                    e.Title + ' | ' + CONVERT(NVARCHAR,sh.ShowDate,106) + ' ' + CONVERT(NVARCHAR,sh.StartTime,108) AS Label
                  FROM Shows sh JOIN Events e ON e.EventId=sh.EventId
                  ORDER BY sh.ShowDate DESC",
                "ShowId", "Label", "-- Select Show --");

            // Coupons — optional
            BindDdl(ddlCouponId,
                "SELECT CouponId, Code + ' (' + DiscountType + ' ' + CAST(DiscountValue AS NVARCHAR) + ')' AS Label FROM Coupons WHERE IsActive=1 ORDER BY Code",
                "CouponId", "Label", "-- No Coupon --");
        }

        private void BindDdl(DropDownList ddl, string sql, string val, string text, string def)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(sql, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    ddl.DataSource = dt;
                    ddl.DataValueField = val;
                    ddl.DataTextField = text;
                    ddl.DataBind();
                    ddl.Items.Insert(0, new ListItem(def, ""));
                }
            }
            catch { ddl.Items.Insert(0, new ListItem("-- Error loading --", "")); }
        }

        // ── Load Grid ──────────────────────────────────────────────────────
        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(@"
                        SELECT b.BookingId, u.Username AS UserName,
                               e.Title + ' ' + CONVERT(NVARCHAR,sh.ShowDate,106) AS ShowLabel,
                               b.BookingDate, b.FinalAmount, b.BookingRef, b.Status
                        FROM Bookings b
                        JOIN Users u  ON u.UserId  = b.UserId
                        JOIN Shows sh ON sh.ShowId = b.ShowId
                        JOIN Events e ON e.EventId = sh.EventId
                        ORDER BY b.BookingId DESC", con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvBookings.DataSource = dt;
                    gvBookings.DataBind();
                    lblCount.Text = dt.Rows.Count + " record(s)";
                }
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        // ── INSERT ─────────────────────────────────────────────────────────
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Bookings (UserId,ShowId,BookingDate,TotalAmount,DiscountAmount,FinalAmount,Status,BookingRef,CouponId)
                        VALUES (@uid,@sid,@bd,@ta,@da,@fa,@st,@ref,@cid)", con);
                    SetParams(cmd);
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Booking inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        // ── SAVE ───────────────────────────────────────────────────────────
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtBookingId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Bookings SET UserId=@uid,ShowId=@sid,BookingDate=@bd,
                        TotalAmount=@ta,DiscountAmount=@da,FinalAmount=@fa,
                        Status=@st,BookingRef=@ref,CouponId=@cid
                        WHERE BookingId=@id", con);
                    SetParams(cmd);
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtBookingId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Booking updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        private void SetParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@uid", int.Parse(ddlUserId.SelectedValue));
            cmd.Parameters.AddWithValue("@sid", int.Parse(ddlShowId.SelectedValue));
            cmd.Parameters.AddWithValue("@bd", DateTime.Parse(txtBookingDate.Text));
            cmd.Parameters.AddWithValue("@ta", decimal.Parse(txtTotalAmount.Text));
            cmd.Parameters.AddWithValue("@da", string.IsNullOrEmpty(txtDiscountAmount.Text) ? 0 : decimal.Parse(txtDiscountAmount.Text));
            cmd.Parameters.AddWithValue("@fa", decimal.Parse(txtFinalAmount.Text));
            cmd.Parameters.AddWithValue("@st", rblStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@ref", txtBookingRef.Text.Trim());
            cmd.Parameters.AddWithValue("@cid", string.IsNullOrEmpty(ddlCouponId.SelectedValue) ? (object)DBNull.Value : int.Parse(ddlCouponId.SelectedValue));
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }

        // ── GridView ───────────────────────────────────────────────────────
        protected void gvBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Bookings WHERE BookingId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtBookingId.Text = r["BookingId"].ToString();
                        ddlUserId.SelectedValue = r["UserId"].ToString();
                        ddlShowId.SelectedValue = r["ShowId"].ToString();
                        txtBookingDate.Text = Convert.ToDateTime(r["BookingDate"]).ToString("yyyy-MM-dd");
                        txtTotalAmount.Text = r["TotalAmount"].ToString();
                        txtDiscountAmount.Text = r["DiscountAmount"].ToString();
                        txtFinalAmount.Text = r["FinalAmount"].ToString();
                        rblStatus.SelectedValue = r["Status"].ToString();
                        txtBookingRef.Text = r["BookingRef"].ToString();
                        if (r["CouponId"] != DBNull.Value) ddlCouponId.SelectedValue = r["CouponId"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Bookings WHERE BookingId=@id", con);
                    cmd.Parameters.AddWithValue("@id", id);
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("🗑️ Booking deleted!", true); ClearFields(); LoadGrid();
            }
        }

        private void ClearFields()
        {
            txtBookingId.Text = txtBookingDate.Text = txtTotalAmount.Text =
            txtDiscountAmount.Text = txtFinalAmount.Text = txtBookingRef.Text = "";
            ddlUserId.SelectedIndex = ddlShowId.SelectedIndex = ddlCouponId.SelectedIndex = 0;
            rblStatus.SelectedIndex = 1;
        }

        private bool Validate()
        {
            if (string.IsNullOrEmpty(ddlUserId.SelectedValue)) { ShowMessage("⚠️ Select a User.", false); return false; }
            if (string.IsNullOrEmpty(ddlShowId.SelectedValue)) { ShowMessage("⚠️ Select a Show.", false); return false; }
            if (string.IsNullOrEmpty(txtBookingDate.Text)) { ShowMessage("⚠️ Enter Booking Date.", false); return false; }
            if (string.IsNullOrEmpty(txtTotalAmount.Text)) { ShowMessage("⚠️ Enter Total Amount.", false); return false; }
            if (string.IsNullOrEmpty(txtFinalAmount.Text)) { ShowMessage("⚠️ Enter Final Amount.", false); return false; }
            return true;
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = success ? "alert msg-success" : "alert msg-error";
            lblMessage.Visible = true;
        }

        public string GetStatusBadge(string s)
        {
            switch (s)
            {
                case "Confirmed": return "s-confirmed";
                case "Pending": return "s-pending";
                case "Cancelled": return "s-cancelled";
                case "Refunded": return "s-refunded";
                default: return "s-pending";
            }
        }
    }
}