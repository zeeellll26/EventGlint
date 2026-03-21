using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditCoupons : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Log.aspx"); return; }
            lbl_AvatarInitial.Text = (Session["Username"]?.ToString() ?? "A")[0].ToString().ToUpper();
            if (!IsPostBack) LoadGrid();
        }

        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT CouponId,Code,DiscountType,DiscountValue,ValidFrom,ValidTill,UsedCount FROM Coupons ORDER BY CouponId DESC", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    gvCoupons.DataSource = dt; gvCoupons.DataBind();
                    lblCount.Text = dt.Rows.Count + " record(s)";
                }
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"INSERT INTO Coupons(Code,DiscountType,DiscountValue,MaxDiscount,MinOrderValue,ValidFrom,ValidTill,UsageLimit,UsedCount,CreatedAt)
                        VALUES(@code,@type,@val,@max,@min,@from,@till,@limit,@used,GETDATE())", con);
                    SetParams(cmd);
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Coupon inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtCouponId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"UPDATE Coupons SET Code=@code,DiscountType=@type,DiscountValue=@val,MaxDiscount=@max,
                        MinOrderValue=@min,ValidFrom=@from,ValidTill=@till,UsageLimit=@limit,UsedCount=@used WHERE CouponId=@id", con);
                    SetParams(cmd);
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtCouponId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Coupon updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        private void SetParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@code", txtCode.Text.Trim().ToUpper());
            cmd.Parameters.AddWithValue("@type", rbPercentage.Checked ? "Percentage" : "Flat");
            cmd.Parameters.AddWithValue("@val", decimal.Parse(txtDiscountValue.Text));
            cmd.Parameters.AddWithValue("@max", string.IsNullOrEmpty(txtMaxDiscount.Text) ? (object)DBNull.Value : decimal.Parse(txtMaxDiscount.Text));
            cmd.Parameters.AddWithValue("@min", string.IsNullOrEmpty(txtMinOrder.Text) ? (object)DBNull.Value : decimal.Parse(txtMinOrder.Text));
            cmd.Parameters.AddWithValue("@from", DateTime.Parse(txtValidFrom.Text));
            cmd.Parameters.AddWithValue("@till", DateTime.Parse(txtValidTill.Text));
            cmd.Parameters.AddWithValue("@limit", string.IsNullOrEmpty(txtUsageLimit.Text) ? (object)DBNull.Value : int.Parse(txtUsageLimit.Text));
            cmd.Parameters.AddWithValue("@used", string.IsNullOrEmpty(txtUsedCount.Text) ? 0 : int.Parse(txtUsedCount.Text));
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }

        protected void gvCoupons_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Coupons WHERE CouponId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtCouponId.Text = r["CouponId"].ToString();
                        txtCode.Text = r["Code"].ToString();
                        rbPercentage.Checked = r["DiscountType"].ToString() == "Percentage";
                        rbFlat.Checked = r["DiscountType"].ToString() == "Flat";
                        txtDiscountValue.Text = r["DiscountValue"].ToString();
                        txtMaxDiscount.Text = r["MaxDiscount"] == DBNull.Value ? "" : r["MaxDiscount"].ToString();
                        txtMinOrder.Text = r["MinOrderValue"] == DBNull.Value ? "" : r["MinOrderValue"].ToString();
                        txtValidFrom.Text = Convert.ToDateTime(r["ValidFrom"]).ToString("yyyy-MM-dd");
                        txtValidTill.Text = Convert.ToDateTime(r["ValidTill"]).ToString("yyyy-MM-dd");
                        txtUsageLimit.Text = r["UsageLimit"] == DBNull.Value ? "" : r["UsageLimit"].ToString();
                        txtUsedCount.Text = r["UsedCount"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Coupons WHERE CouponId=@id", con);
                    cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("🗑️ Coupon deleted!", true); ClearFields(); LoadGrid();
            }
        }

        private void ClearFields()
        {
            txtCouponId.Text = txtCode.Text = txtDiscountValue.Text = txtMaxDiscount.Text =
            txtMinOrder.Text = txtValidFrom.Text = txtValidTill.Text = txtUsageLimit.Text = txtUsedCount.Text = "";
            rbPercentage.Checked = false; rbFlat.Checked = false;
        }
        private bool Validate()
        {
            if (string.IsNullOrEmpty(txtCode.Text.Trim())) { ShowMessage("⚠️ Coupon Code required.", false); return false; }
            if (!rbPercentage.Checked && !rbFlat.Checked) { ShowMessage("⚠️ Select Discount Type.", false); return false; }
            if (string.IsNullOrEmpty(txtDiscountValue.Text.Trim())) { ShowMessage("⚠️ Discount Value required.", false); return false; }
            if (string.IsNullOrEmpty(txtValidFrom.Text)) { ShowMessage("⚠️ Valid From required.", false); return false; }
            if (string.IsNullOrEmpty(txtValidTill.Text)) { ShowMessage("⚠️ Valid Till required.", false); return false; }
            return true;
        }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}